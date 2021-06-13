Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1653A56DF
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 09:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhFMHgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 03:36:24 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:60121 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229777AbhFMHgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 03:36:23 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6746B5809B2;
        Sun, 13 Jun 2021 03:34:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 13 Jun 2021 03:34:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7vEofM
        Aqg+f6wYxXxRpaft9RyBo6WXP9j/L+Lqm8oNE=; b=ErznCTvCm07KfuGG0pAzTr
        3PMMfqK2nzr9kgdlzirnP4WhrG/ZHL4qiCxe8j4PjzFI3j6e9NU019cZ+kAGUnQG
        5Sdd+V/J0uwDYl5Nor/ITTxU0r2IgZV2E2HU2CNtJMbzjHLR7lwlZO4P02dUKNoe
        XWbrYjJcouyM+HVAC7hdvOSzYLey9bMmR74o1LY3nsqnTgry9Tq5iuJCYhNOcsrH
        Dqt8pROxGjeFOryGmnQxPiN3NzNZ03tBuJy9KSx2Umy8ZPWfm7/UfPIZMaqswEsI
        jOMbVjxzeImsUCXw6urSQkhBdGP42xVAIz4Viy0xpbEInJWDNV1WuVLB12KpY/CQ
        ==
X-ME-Sender: <xms:_bTFYAzIBEI_T9MHN9gDDq8N48J96lL9aN6Pjo8LQniLjpqK-J9guA>
    <xme:_bTFYEQRyoIXbUE1jegwZg6Lot0dRdXXCX9tmDojHsiLE1X6t2Wz9sQpzh6M80jP0
    h1bx1Og_wZjnT0>
X-ME-Received: <xmr:_bTFYCXKnBXMLsK09R66YcE7_O5Ra0pmEjR8DUCL39KIg1x4faUNQBTfBL5J>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvvddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeethfeijeefudehtddvheekteejheetvdekleffveekfeetiedtgeettdfhledv
    ueenucffohhmrghinhepmhgrnhejrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:_bTFYOi7Xsbo9lcodfi_4duQiKmqCy1lrLl4C3Y2t0Idq3SwPRGFIw>
    <xmx:_bTFYCA2TDka-ZJs0ZkEzqzS7xO3OxP3gOv82dU6CfJp-iwk8lX75g>
    <xmx:_bTFYPJnegSu7qlEOH_I_IXCfKUdN_Q_UPVRfrgkVW0glPXvnoYvoA>
    <xmx:_rTFYG6QrDvt7QiFCoEj5WNUIq4Y6tnx60xaJeA6MD9iVfg3jKvyTg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 03:34:20 -0400 (EDT)
Date:   Sun, 13 Jun 2021 10:34:18 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Subject: Re: [PATCH net-next 10/11] net: marvell: prestera: add storm control
 (rate limiter) implementation
Message-ID: <YMW0+vERwH+d8sT1@shredder>
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
 <20210609151602.29004-11-oleksandr.mazur@plvision.eu>
 <YMIIcgKjIH5V+Exf@lunn.ch>
 <AM0P190MB0738E3909FB0EA0031A24F07E4349@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
 <YMOYcHleEOjmnqjt@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMOYcHleEOjmnqjt@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 07:08:00PM +0200, Andrew Lunn wrote:
> On Fri, Jun 11, 2021 at 01:19:13PM +0000, Oleksandr Mazur wrote:
> > >>  On Wed, Jun 09, 2021 at 06:16:00PM +0300, Oleksandr Mazur wrote:
> > > Storm control (BUM) provides a mechanism to limit rate of ingress
> > > > port traffic (matched by type). Devlink port parameter API is used:
> > > > driver registers a set of per-port parameters that can be accessed to both
> > > > get/set per-port per-type rate limit.
> > > > Add new FW command - RATE_LIMIT_MODE_SET.
> > 
> > > Hi Oleksandr
> > 
> > > Just expanding on the two comments you already received about this.
> > 
> > > We often see people miss that switchdev is about. It is not about
> > > writing switch drivers. It is about writing network stack
> > > accelerators. You take a feature of the Linux network stack and you
> > > accelerate it by offloading it to the hardware. So look around the
> > > network stack and see how you configure it to perform rate limiting of
> > > broadcast traffic ingress. Once you have found a suitable mechanism,
> > > accelerate it via offloading.
> > 
> > > If you find Linux has no way to perform a feature the hardware could
> > > accelerate, you first need to add a pure software version of that
> > > feature to the network stack, and then add acceleration support for
> > > it.
> > 
> > 
> > Hello Andrew, Ido, Nikolay,
> > I appreciate your time and comments provided over this patchset, though i have a few questions to ask, if you don't mind:
> > 
> 
> > 1. Does it mean that in order to support storm control in switchdev
> > driver i need to implement software storm control in bridge driver,
> > and then using the switchdev attributes (notifiers) mechanism
> > offload the configuration itself to the HW?
> 
> Hi Oleksandr
> 
> Not necessarily. Is storm control anything more than ingress packet
> matching and rate limiting?
> 
> I'm not TC expert, but look for example at
> https://man7.org/linux/man-pages/man8/tc-police.8.html
> 
> and the example:
> 
> # tc qdisc add dev eth0 handle ffff: ingress
> # tc filter add dev eth0 parent ffff: u32 \
>                    match u32 0 0 \
>                    police rate 1mbit burst 100k
> 
> Replace the "match u32 0 0" with something which matches on broadcast
> frames.  Maybe "flower dst_mac ff:ff:ff:ff:ff:ff"
> 
> So there is a software solution. Now accelerate it.

Storm control also needs the ability to limit other types of flooded
traffic such unknown unicast and unregistered multicast packets. The
entity which classifies packets as such is the bridge, which happens
after the ingress hook.

I see two options to support storm control in Linux:

1. By adding support in the bridge itself as a new bridge slave option.
Something like:

# ip link set dev swp1 type bridge_slave \
	storm_control type { uuc | umc | bc} rate RATE mode { packet | byte }

I suspect this similar to more traditional implementations that users
might be used to and also maps nicely to hardware implementations

2. Teaching tc to call into the bridge to classify a packet. Not sure a
whole new classifier is needed for this. Maybe just extend flower with a
new key: dst_mac_type { uuc | umc }. I personally find this a bit weird,
but it is more flexible and allows to reuse existing actions

> 
> > 2. Is there any chance of keeping devlink solution untill the
> > discussed (storm control implemented in the bridge driver) mechanism
> > will be ready/implemented?
> 
> No. Please do it correctly from the beginning. No hacks.

+1
