Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885293E98E8
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 21:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhHKTiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 15:38:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53023 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229655AbhHKTiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 15:38:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A73F65C00F2;
        Wed, 11 Aug 2021 15:37:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 11 Aug 2021 15:37:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=HRQzzO
        Fs7r9J1w1NwxT52wIx8hf9JImCX2DzNYjWTqA=; b=CZPVEit5oKzJzlUOmi+3Fm
        COLsD5NCn84MPYFTkUfU7VdsDAoGTpxjZxfHRG6B9H+B+PbTeFjFyWC2yWcvPSf1
        pAz6D9yZYzzWm2y2rNOQYpN4ubPztodVXtpCLrY92mipt8Mw8r/r8i7eHh1q0gF+
        2EywtMb6UqXvr1CRZUOKWV+ivpZRZgT9P6q8Z2Ej6QVF+VFmzxyja7oTuRQIC/g0
        kwf1aZTCAyUbPS7P+0PFC9thjezzjpXrILqM4Nl/nir5IGGlHodCLVTQsw6oZA57
        l/GfXE/soOsMZapfOvbEdLZdgh2PSUSSqS0wveAV+6P4nGHsDNdjknw7PeYeA4VQ
        ==
X-ME-Sender: <xms:FScUYadOBK3pQ8j63jSMt-G3XLnqD7Hi9-ydl-6-UnHIW6R_EUe-uA>
    <xme:FScUYUOjaSVCab8_5W9Psa71qxZHJPV7VAVouh3x_Hfo1mnMVoSiHGwroPCRQ3Ur4
    tC7csheiEqRB2I>
X-ME-Received: <xmr:FScUYbgNzWlSzUZd4kjefsI4x46Duob_1aFQ44DHCiXAbnKy_rlGq1-q_ZQ66EUebvaJF3MdnOZI5taG4ZE4bzxqcC-3eg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkedugddufeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:FScUYX-TJcEcniRaiBkkDXzYeQqZ6rndcLBi54yYJ6nt1oWf7m5gDg>
    <xmx:FScUYWur21Zs5aD1y3EYRz-gmP6LB7R3wYwNtTPjCrdsUc1DwSZBpQ>
    <xmx:FScUYeG6FKlJ8drMm3vr7adcD_QDfvcQxpcBHyANpAgg2iWgrIkRxg>
    <xmx:FicUYT-E3l_KEUcdELTa6kL-KoFpuOAW-b_v4qcE3_dTUN10BcQuMA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Aug 2021 15:37:56 -0400 (EDT)
Date:   Wed, 11 Aug 2021 22:37:53 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        pali@kernel.org, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <YRQnEWeQSE22woIr@shredder>
References: <20210809102152.719961-2-idosch@idosch.org>
 <YRE7kNndxlGQr+Hw@lunn.ch>
 <YRIqOZrrjS0HOppg@shredder>
 <YRKElHYChti9EeHo@lunn.ch>
 <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLlpCutXmthqtOg@shredder>
 <20210810150544.3fec5086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRO1ck4HYWTH+74S@shredder>
 <20210811060343.014724e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRPgXWKZ2e88J1sn@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRPgXWKZ2e88J1sn@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 04:36:13PM +0200, Andrew Lunn wrote:
> On Wed, Aug 11, 2021 at 06:03:43AM -0700, Jakub Kicinski wrote:
> > On Wed, 11 Aug 2021 14:33:06 +0300 Ido Schimmel wrote:
> > > # ethtool --set-module swp13 low-power on
> > > 
> > > $ ethtool --show-module swp13
> > > Module parameters for swp13:
> > > low-power true
> > > 
> > > # ip link set dev swp13 up
> > > 
> > > $ ip link show dev swp13
> > > 127: swp13: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN mode DEFAULT group default qlen 1000
> > >     link/ether 1c:34:da:18:55:49 brd ff:ff:ff:ff:ff:ff
> > > 
> > > $ ip link show dev swp14
> > > 128: swp14: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN mode DEFAULT group default qlen 1000
> > >     link/ether 1c:34:da:18:55:4d brd ff:ff:ff:ff:ff:ff
> > 
> > Oh, so if we set low-power true the carrier will never show up?
> > I thought Andrew suggested the setting is only taken into account 
> > when netdev is down.
> 
> Yes, that was my intention. If this low power mode also applies when
> the interface is admin up, it sounds like a foot gun. ip link show
> gives you no idea why the carrier is down, and people will assume the
> cable or peer is broken. We at least need a new flag, LOWER_DISABLED
> or similar to give the poor user some chance to figure out what is
> going on.

The canonical way to report such errors is via LINKSTATE_GET and I will
add an extended sub-state describing the problem.

> 
> To me, this setting should only apply when the link is admin down.

I don't want to bake such an assumption into the kernel, but I have a
suggestion that resolves the issue.

We currently have a single attribute that encodes the desired state on
SET messages and the operational state on GET_REPLY messages
(ETHTOOL_A_MODULE_LOW_POWER_ENABLED):

$ ethtool --show-module swp11
Module parameters for swp11:
low-power true

It is not defined very well when a module is not connected despite being
a very interesting use case. We really need to have two attributes. The
first one describing the power mode policy and the second one describing
the operational power mode which is only reported when a module is
plugged in.

For the policy we can have these values:

1. low: Always transition the module to low power mode
2. high: Always transition the module to high power mode
3. high-on-up: Transition the module to high power mode when a port
using it is administratively up. Otherwise, low

A different policy for up/down seems like an overkill for me.

See example usage below.

No module connected:

$ ethtool --show-module swp11
Module parameters for swp11:
power-mode-policy high

Like I mentioned before, this is the default on Mellanox systems so this
new attribute allows user space to query the default policy.

Change to a different policy:

# ethtool --set-module swp11 power-mode-policy high-on-up

$ ethtool --show-module swp11
Module parameters for swp11:
power-mode-policy high-on-up

After a module was connected:

$ ethtool --show-module swp11
Module parameters for swp11:
power-mode-policy high-on-up
power-mode low

# ip link set dev swp11 up

$ ethtool --show-module swp11
Module parameters for swp11:
power-mode-policy high-on-up
low-power high

# ip link set dev swp11 down

# ethtool --set-module swp11 power-mode-policy low

# ip link set dev swp11 up

$ ethtool swp11
...
Link detected: no (Cable issue, Module is in low power mode)

I'm quite happy with the above. Might change a few things as I implement
it, but you get the gist. WDYT?
