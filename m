Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E7E3CC7C
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 15:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388606AbfFKNGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 09:06:11 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33111 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387593AbfFKNGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 09:06:11 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CABA022089;
        Tue, 11 Jun 2019 09:06:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 09:06:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eWVRm2
        DCGCAkVJrafdfnWAE4Jrp20SOKhEjBLW8EfiE=; b=RMphBZEHwS4DylWA03fNHk
        rEDFDz2toOO+gb8rACPSGFT2PfhKyIdwv5Av0r/OhL1gz/4Xsqh3bqcWAhtN7yWN
        +gzp+h9f3xsb2Xa1ODEraHbYbpVMEzsZDLxE2krVPXULAKvPdHvwieaM3tqaZhY7
        IiEoMQv5ovFrIZpxugUi49IbfTCBfVjqT77BeOyEpKT4mQTA3qWMNS/hF15fm8Nf
        54DpH8KeNYN0cSmMPYqq+7f90aix9Q3gTrmV+DMntR0hNMOS2zYk9f0kgKPHHfZy
        RI5UKRYz0mXdr1Ke+QGZvyfEK5tuFAlA53t3+pUIv/OI+ZmJFKvGCauENmvkKUJw
        ==
X-ME-Sender: <xms:P6f_XJsaAJJyfs6_CKKrMQ8jY3N86J8IPip51iOAIxbuJfyLY0c1Ow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehhedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:P6f_XGuL-9PgnayHGQeZYa08NOga2YSYrYrKPN2vdllSwJq0WoHBvg>
    <xmx:P6f_XHxrq1NFVEuS6EZoeJABhaa8bRvuhKKCJXkGaOL_Eij2KLY6Ww>
    <xmx:P6f_XEg13U-NDr5VsF6BlUebjBmHcFoMMj6OKMdOuHJ8Ex_j9bxEJA>
    <xmx:Qaf_XEeQgHgRP7kY9ZGPjmtu-ZL1ORs4KElG-fNasUIlOJaBLAezSQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 63B95380073;
        Tue, 11 Jun 2019 09:06:07 -0400 (EDT)
Date:   Tue, 11 Jun 2019 16:06:05 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/3] selftests: mlxsw: Add speed and
 auto-negotiation test
Message-ID: <20190611130605.GA3940@splinter>
References: <20190610084045.6029-1-idosch@idosch.org>
 <20190610084045.6029-4-idosch@idosch.org>
 <20190610134820.GG8247@lunn.ch>
 <20190610135848.GB19495@splinter>
 <20190610140633.GI8247@lunn.ch>
 <20190611063526.GA6167@splinter>
 <20190611122255.GB20904@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611122255.GB20904@lunn.ch>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 02:22:55PM +0200, Andrew Lunn wrote:
> On Tue, Jun 11, 2019 at 09:35:26AM +0300, Ido Schimmel wrote:
> > On Mon, Jun 10, 2019 at 04:06:33PM +0200, Andrew Lunn wrote:
> > > On Mon, Jun 10, 2019 at 04:58:48PM +0300, Ido Schimmel wrote:
> > > > On Mon, Jun 10, 2019 at 03:48:20PM +0200, Andrew Lunn wrote:
> > > > > > +		# Skip 56G because this speed isn't supported with autoneg off.
> > > > > > +		if [[ $speed == 56000 ]]; then
> > > > > > +			continue
> > > > > > +		fi
> > > > > 
> > > > > Interesting. How is 56000 represented in ethtool? Listed in both
> > > > > "Supported link modes" and "Advertised link modes"?
> > > > 
> > > > Hi Andrew,
> > > > 
> > > > Yes. We recently sent a patch to error out if autoneg is off: Commit
> > > > 275e928f1911 ("mlxsw: spectrum: Prevent force of 56G").
> > > 
> > > I never get access to high speed links like this. Do you have a
> > > reference to why 56G needs auto-neg? What makes it different to every
> > > other link mode?
> > 
> > Hi Andrew,
> > 
> > I verified with PHY engineers and this limitation is specific to our
> > hardware, so no external reference I can provide.
> 
> Hi Ido
> 
> Could you detect your own hardware and only enable this exception when
> needed?

The test currently resides under
tools/testing/selftests/drivers/net/mlxsw/, so it's specific to mlxsw.

I believe the 56G quirk is the only thing in the test that is specific
to mlxsw. Should be possible to move it to
tools/testing/selftests/net/forwarding/ and skip 56G for mlxsw.
