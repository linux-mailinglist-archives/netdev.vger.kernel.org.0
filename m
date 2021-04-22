Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1843684B3
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 18:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236459AbhDVQWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 12:22:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51911 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232670AbhDVQWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 12:22:18 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9CF5E5C0032;
        Thu, 22 Apr 2021 12:21:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 22 Apr 2021 12:21:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7M6lWg
        hIxRU9BSDTiUARBrvhYrAFcaip96FI1p3HI+U=; b=Ju6Zy0E1ALnD9MrQPF7+Yf
        ZLdkS7n9g25OsjxYErak9ISuly80DAYRXXi3Pa6N6U5vB1IqM1IQgs8VXkgqhQjI
        4YlawFVF23DuuMyDPMTMhTtjEEY8ZvUwOFxt1o9UN8HMMAyGaSbcz0HmB9bIAbTo
        HLb5URb7LTHwOKhhKNnZJuavcB8ZHsFvufxbcBT5H/7GM+C+nvGjm2ZGDaZXUwRx
        cbHuW4Xj2M/Jek1b4Wmiw3rudYd0nDtS6aTBySdosj5w60KnmgWiWIlSEcEyGke2
        R8bhv2KZFDdb2aIeUxIb80+kmTFq9E08n3+6i9eZXheOOkfjoUimmPEh6xWXn2eA
        ==
X-ME-Sender: <xms:laKBYBflThMPZvBg9hPycL3twloMFvDAaWTbrtEYfXxaN_vUN9QMtA>
    <xme:laKBYPNQlIV26wuM2EYASW6XYrejBYOl0GsG-RA2zvMfW7faKUitevL_2SO0rv3FY
    tViOlr6SNTaePg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddutddgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecukfhppeekgedrvddvledrudehfedrudek
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:laKBYKghRXKOJ081ICGBvNULFK6S1ulneYZdRbVSVXDqy381qhme6Q>
    <xmx:laKBYK-wb7-zhtbCXSgGZpffFz2OUE0z1AB2Tvks9uUcIce5FND0FA>
    <xmx:laKBYNs447p0ZH9saVio8VHmWwtA7e9mUyUfIolqSDct9bjS15M2_w>
    <xmx:lqKBYOWCxGGmxrcWuVLp44Ps4zBgH_8kdEEmn02IUcPWbctcbU0eJA>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 62A141080068;
        Thu, 22 Apr 2021 12:21:41 -0400 (EDT)
Date:   Thu, 22 Apr 2021 19:21:37 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] netdevsim: Only use sampling truncation length
 when valid
Message-ID: <YIGikZ2xZhH7ZRZc@shredder.lan>
References: <20210422135050.2429936-1-idosch@idosch.org>
 <20210422091426.6fda8280@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422091426.6fda8280@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 09:14:26AM -0700, Jakub Kicinski wrote:
> On Thu, 22 Apr 2021 16:50:50 +0300 Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > When the sampling truncation length is invalid (zero), pass the length
> > of the packet. Without the fix, no payload is reported to user space
> > when the truncation length is zero.
> > 
> > Fixes: a8700c3dd0a4 ("netdevsim: Add dummy psample implementation")
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!

> 
> > +	md->trunc_size = psample->trunc_size ? psample->trunc_size : len;
> 
> nit:  ... = psample->trunc_size ? : len;  ?

Yea, I don't find this form too readable and always prefer the one I
used when it fits in a single line :)
