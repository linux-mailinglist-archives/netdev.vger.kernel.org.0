Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85485438C60
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 00:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhJXWhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 18:37:31 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46611 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229801AbhJXWh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 18:37:29 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 5244A5C0877;
        Sun, 24 Oct 2021 06:48:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 24 Oct 2021 06:48:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RO55Ba
        /oTFdyyoQvL2yZtyKP9gtl/QEKpvDu9LwgTfQ=; b=hm2/ZzcyDYVloZ6TmnPZqp
        efKDQbcTzrwBIEpoVjQV7RLQX6G8+LiGpR2kDx8+B37imUMGeRGiVp0+R07Sr52r
        M8iYoR4amf3UtaS7m4UmCVz0oswF9y/NuZV5isqwpznEeGQ8S3HrgmWQ6u68bATa
        aAaeI3jwqTkmWxO7IqIgceJNRrPeacW57ERjY7V+vPXxaSGXOgPuGK5lKQRsT0yp
        Cw3bVGj3BiZSUToA0zDYWCAH6SdRsKqrGpvZ2r+jdZka66ZB3OL1bV0ihnf+tGct
        6PgcE4I0YNc9q/ykASkCqaOX4RudT9l2Bd7Sx70UOMTUvyiyVPUAF2knWlhPXPYw
        ==
X-ME-Sender: <xms:_Tl1YRCgWQVoa05tqdzH0sYzZ-RAF6u4g0cvFB5PCPFQjFgz5XIjdw>
    <xme:_Tl1YfiirYPRYP7TvK-EF8zGuuga6ZehYP_HSqAqpGxc2gWsTLKUyB9hgmUgAOuIy
    ZXggSa8mALM7Lc>
X-ME-Received: <xmr:_Tl1YcmLWVUs104P8vpAYyUHuWZJTwPfHLkN_NZBLdiiFRZjlND8UnTDHHfiiNnyhA0Bb0R1HL_zUsBj2sqMOZ1nw1Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdeffedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:_Tl1YbyG5jpOIXGd94ZpH45JlSd-v5lBxcvYNSMEVn7vNieu0iL7dQ>
    <xmx:_Tl1YWQKyKqP6Bz6T29103UjnNM-uMAjml1KeAGaix0YyQ9nu4mW8g>
    <xmx:_Tl1YebgmD0zPL3rNLcgkoG_RpqlZLueiFn9z4v_4peKR_-DVct9RQ>
    <xmx:_jl1YTL7TybVDQ147Ma2ciLOZrkKh7B3W8SJpGjy9hPBrz9acv7AKA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 24 Oct 2021 06:48:29 -0400 (EDT)
Date:   Sun, 24 Oct 2021 13:48:25 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <YXU5+XLhQ9zkBGNY@shredder>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
 <YXUtbOpjmmWr71dU@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXUtbOpjmmWr71dU@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 12:54:52PM +0300, Leon Romanovsky wrote:
> On Sun, Oct 24, 2021 at 12:05:12PM +0300, Ido Schimmel wrote:
> > On Sun, Oct 24, 2021 at 11:42:11AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Align netdevsim to be like all other physical devices that register and
> > > unregister devlink traps during their probe and removal respectively.
> > 
> > No, this is incorrect. Out of the three drivers that support both reload
> > and traps, both netdevsim and mlxsw unregister the traps during reload.
> > Here is another report from syzkaller about mlxsw [1].
> 
> Sorry, I overlooked it.
> 
> > 
> > Please revert both 22849b5ea595 ("devlink: Remove not-executed trap
> > policer notifications") and 8bbeed485823 ("devlink: Remove not-executed
> > trap group notifications").
> 
> However, before we rush and revert commit, can you please explain why
> current behavior to reregister traps on reload is correct?
> 
> I think that you are not changing traps during reload, so traps before
> reload will be the same as after reload, am I right?

During reload we tear down the entire driver and load it again. As part
of the reload_down() operation we tear down the various objects from
both devlink and the device (e.g., shared buffer, ports, traps, etc.).
As part of the reload_up() operation we issue a device reset and
register everything back.

While the list of objects doesn't change, their properties (e.g., shared
buffer size, trap action, policer rate) do change back to the default
after reload and we cannot go back on that as it's a user-visible
change.
