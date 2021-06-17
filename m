Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09A53AB9AD
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhFQQbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 12:31:23 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38775 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230269AbhFQQbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 12:31:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4C7435C0060;
        Thu, 17 Jun 2021 12:29:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 17 Jun 2021 12:29:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BDqBQk
        /MVOeXZH/Qio6RZGLnf+wK9Jub3rb9LLGOjUI=; b=DBxsWH5aOxiKLA1CwNh53I
        bGSxiPlNZrODvg7+hqYbmr8H5T5pFUjMtMyy44vV0uu3WVlA2N7Jk2NXxJ5UpjPM
        13ZdsrSW7gZ4rHXAmP2vaawR/n0CXFCLTPlvunqNCBT6OL60VJU/UdsEai9exMSB
        p+rDcmUiu7dEAUL6ASGd2wQk+dQ7z7hr540Fx1ePXJ9auWRri4Cs73MnIN5gMwEx
        gOVynCGIWN3clvvwtb2PCWUuHgeZZ6/bKPRb4FysvNOcVBou20bKO+XIld7NFNIq
        WwTXQi0rhaecXLlAHGhqAZtivManwO9ceX82ywTWocRA6fu1HLBzuQQU9n+p53Nw
        ==
X-ME-Sender: <xms:WHjLYC9p8wzyis6qSuUHYk_1yi9ecdzk5CbnkpciFR2AOgVNcfzN7A>
    <xme:WHjLYCsfbjV998LTttRcgVytd3FOF8xuDNW8bv3kXiwxGkvrOE6sB5L63jszVn5Eu
    fjynped95xKm4A>
X-ME-Received: <xmr:WHjLYIA_6Kzke4tHlZi0kRvscXm24Tr-v7ojny45Kt4fAVaLXNgR4WKV6GUH6qQbiO0NrfYJmisgzP0hRLimh72uX_p_uw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefuddguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:WHjLYKd10xbzO8r9D0zvm-COiJeLdKt1fjxSbo_IbEp9ubT8dHc2bA>
    <xmx:WHjLYHPm9Dee4Zcb0eONgWOwH_X_bhLYd0cnAIRu9UfpG1W-6yncAg>
    <xmx:WHjLYEkNPIfSJ-U1qI4McHJ7mKLUMQvx3jpEqlyt3uEZrqSiPqAYXw>
    <xmx:WXjLYMqWDohI5ExIO4wDEsHNTssJcmlTvRN7arFa3pA7qp0HNxUVWw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Jun 2021 12:29:12 -0400 (EDT)
Date:   Thu, 17 Jun 2021 19:29:09 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Amit Cohen <amcohen@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mkubecek@suse.cz, idosch@nvidia.com, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net] ethtool: strset: Fix reply_size value
Message-ID: <YMt4VaNZOcRZ8xRP@shredder>
References: <20210617154252.688724-1-amcohen@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617154252.688724-1-amcohen@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 06:42:52PM +0300, Amit Cohen wrote:
> strset_reply_size() does not take into account the size required for the
> 'ETHTOOL_A_STRSET_STRINGSETS' nested attribute.
> Since commit 4d1fb7cde0cc ("ethtool: add a stricter length check") this
> results in the following warning in the kernel log:
> 
> ethnl cmd 1: calculated reply length 2236, but consumed 2240
> WARNING: CPU: 2 PID: 30549 at net/ethtool/netlink.c:360 ethnl_default_doit+0x29f/0x310
> 
> Add the appropriate size to the calculation.
> 
> Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>

Ha, seems this is addressed by commit e175aef90269 ("ethtool: strset:
fix message length calculation") in net.git which actually motivated
commit 4d1fb7cde0cc ("ethtool: add a stricter length check").

The former is still not in net-next.git, which is why the warning is
triggered there.

The patch can be dropped.
