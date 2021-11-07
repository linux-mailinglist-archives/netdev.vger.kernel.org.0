Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A7F447460
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 18:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbhKGRSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 12:18:52 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41051 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235923AbhKGRSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 12:18:52 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id C4FEC5C00C8;
        Sun,  7 Nov 2021 12:16:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 07 Nov 2021 12:16:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Liz9He
        z2pQ3I/11xvMmZRFFwaYA7f2I/IxstpB3jmBo=; b=nyDBEMPKwtXB60WUGE1W4K
        ubQ51UbRauaMLJstx3QvCnDyRuYeqf0557P8yrWJFhy8iwgCBlE28Py4aVah8o/V
        /bsR4KBR35JMhnzVSsUeRX4/15DIUfMKfbDKnnTErtuD+D2KENwl92D1CHNb2Na+
        lf4cX7FE20W+x/D/nMCVhOhuEXj+ZP0pPkOp5ZtSxheRlwaD3TJF2l3hbZKzHGlm
        +oboLiz9Iv0PEkiFX6LC31qBHoSNbZhfJYhXZu+IFBJZaIzJvdZH3i4Hux1n52dD
        Mt3gFvuqc5b0WbPdFwrdPTmZgsUFDS6iJSfvZ6b3SHT3rd8wxxrHT/1oKpH572pw
        ==
X-ME-Sender: <xms:2AmIYe8jLCzEO8_L99b59L1qosgvR2djbGcfcgxGRNlepAuNdMLyIw>
    <xme:2AmIYesiXiEJaZu1Vg5Ur6NhwrewuGN9_1WCy1UTV8CXQ5p_acg7T5IdYs5-Pwh21
    ArEQoMb6lzSKkc>
X-ME-Received: <xmr:2AmIYUBYeLr0n3671zhUQNKfkMwAgA1GO4-1iVAv-oQJTGh6iOgqoZopEiWj>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddtgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfgkeev
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2AmIYWd_aqSYI2giy050rLReBYs-X2je6PsuMwe8UM9CpM5SOgwLog>
    <xmx:2AmIYTONBrGW5PMYjdgwgQ6LUShmYNqRpyCk-EIafudLSL2wvDcWng>
    <xmx:2AmIYQmNkCiMSljz1mDcypwbsShQKvpO7_T_Ww67EpOa10bP9F4Rgg>
    <xmx:2AmIYfBiNiNZu8At2pNy-QvYJPWuVPiLXny1K9b2GRNX7AviXkbNEQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 7 Nov 2021 12:16:07 -0500 (EST)
Date:   Sun, 7 Nov 2021 19:16:05 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YYgJ1bnECwUWvNqD@shredder>
References: <9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com>
 <YYABqfFy//g5Gdis@nanopsycho>
 <YYBTg4nW2BIVadYE@shredder>
 <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 04:11:22PM -0700, Jakub Kicinski wrote:
> On Mon, 1 Nov 2021 22:52:19 +0200 Ido Schimmel wrote:
> > > >Signed-off-by: Leon Romanovsky <leonro@nvidia.com>  
> > > 
> > > Looks fine to me.
> > > 
> > > Reviewed-by: Jiri Pirko <jiri@nvidia.com>  
> > 
> > Traces from mlxsw / netdevsim below:
> 
> Thanks a lot for the testing Ido!
> 
> Would you mind giving my RFC a spin as well on your syzbot machinery?

Sorry for the delay. I didn't have a lot of time last week.

I tried to apply your set [1] on top of net-next, but I'm getting a
conflict with patch #5. Can you send me (here / privately) a link to a
git tree that has the patches on top of net-next?

TBH, if you ran the netdevsim selftests with a debug config and nothing
exploded, then I don't expect syzkaller to find anything (major).

[1] https://lore.kernel.org/netdev/20211030231254.2477599-1-kuba@kernel.org/

> 
> Any input on the three discussion points there?
> 
>  (1) should we have a "locked" and "unlocked" API or use lock nesting?

Judging by the netdevsim conversion, it seems that for the vast majority
of APIs (if not all) we will only have an "unlocked" API. Drivers will
hold the devlink instance lock on probe / remove and devlink itself will
hold the lock when calling into drivers (e.g., on reload, port split).

> 
>  (2) should we expose devlink lock so that drivers can use devlink 
>      as a framework for their locking needs?

It is better than dropping locks (e.g., DEVLINK_NL_FLAG_NO_LOCK, which I
expect will go away after the conversion). With the asserts you put in
place, misuses will be caught early.

> 
>  (3) should we let drivers take refs on the devlink instance?

I think it's fine mainly because I don't expect it to be used by too
many drivers other than netdevsim which is somewhat special. Looking at
the call sites of devlink_get() in netdevsim, it is only called from
places (debugfs and trap workqueue) that shouldn't be present in real
drivers.

The tl;dr is that your approach makes sense to me. I was initially
worried that we will need to propagate a "reload" argument everywhere in
drivers, but you wrote "The expectation is that driver will take the
devlink instance lock on its probe and remove paths", which avoids that.

Thanks for working on that
