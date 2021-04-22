Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0484A367DE7
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbhDVJl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:41:56 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:51429 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230285AbhDVJlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:41:55 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 29C87FE1;
        Thu, 22 Apr 2021 05:41:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 22 Apr 2021 05:41:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JutoYl
        GGRIb85ttmwv5ZhquJjpbL9lySoXNE5ybPuHk=; b=ixN9vqZRuavJ9x8dCAzeNZ
        Jr3JSLmBmst3X8ZSvtD8lcHawPsLtintVPb6dFEpRP1RPpcX/jfqFM8JZ71J1oM+
        8rIShWGMFHmOa40iP4dcGdj+MRLaA9yQnboCspNnV3/Q3f66qAgLTvkBiOYJBzZi
        qmUwoNO9q0o8UAhC/Yfi7iXmkothNb+nU079Z9J/btEuUXzVjLZconu+QZGKuoLA
        6t8j6M+ttigJYvyx0HfHdjLv4UmevWdUL+ikhOmFDTCrOsymiTmOlUE7sds8vvcy
        yOPy4QoevZ2yfJRrqMol2gyKTCnN1rVoLsvG+rCkKnqQIG6EhaBnTSp79qL7hNqQ
        ==
X-ME-Sender: <xms:wESBYI38wOidCW3evx39jM_ET-I7PuuBeW3c_B1mnCt5lE42DZU8vQ>
    <xme:wESBYDFSBN3msuhOrFZ7z0rpyajODhGOMBVikxkUa7tf8NFtDSqR_lZJ-doE0wlf3
    rFCPht2OeOKiIE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddutddgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecukfhppeekgedrvddvledrudehfedrudek
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:wESBYA5dOzdUfNw4ETmkH3Rt9pnPTtoiNgo_lnJ_W0vXEUtxLyZUHw>
    <xmx:wESBYB2frAtWmF8L-NYVCTwL7ZOQoAM7Awmgezsc54GxvjBjhWruag>
    <xmx:wESBYLGRcyBTQOkD5uIZukGsa4nktvaUg355TsFi7H5Hm66Tc9hDZw>
    <xmx:wESBYCw6dOwLkg4T7Qq8ZPuwhcM4mnk3kVrXXVrAJgMprejVMz3QeQ>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0EB6C240065;
        Thu, 22 Apr 2021 05:41:19 -0400 (EDT)
Date:   Thu, 22 Apr 2021 12:41:15 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool-next 6/7] netlink: add support for standard stats
Message-ID: <YIFEu5cqJmI+4NGv@shredder.lan>
References: <20210420003112.3175038-1-kuba@kernel.org>
 <20210420003112.3175038-7-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420003112.3175038-7-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 05:31:11PM -0700, Jakub Kicinski wrote:
> Add support for standard-based stats.
> 
> Unlike ethtool -S eth0 the new stats should be allow cross-vendor
> compatibility. The interface depends on bitsets and is rather simple.

[...]

> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Tested-by: Ido Schimmel <idosch@nvidia.com>

One comment below

[...]

> diff --git a/netlink/stats.c b/netlink/stats.c
> new file mode 100644
> index 000000000000..e7e69f002cd5
> --- /dev/null
> +++ b/netlink/stats.c
> @@ -0,0 +1,264 @@
> +/*
> + * stats.c - netlink implementation of stats
> + *
> + * Implementation of "ethtool -S <dev> <types>" and

and ?

> + */
