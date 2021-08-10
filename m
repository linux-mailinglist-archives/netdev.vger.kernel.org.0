Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E383E8533
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 23:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhHJVW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 17:22:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43622 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229582AbhHJVW1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 17:22:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=W6o+a88KX8S17yLaD9qwMRTThGtlPc7M3bg2X4oO3Cg=; b=qfuMHkn2fMD7Bk7Lqa3qlfzaxe
        rLfnzvo12k/fiARMtydRsyilNEcYrlofgKQYlVOxDDSfjT2ewZpQv9V2n8g/iRWYYjU29jR/3NN9g
        c3JjasFXfmvclz6mpKwfT7db008Mdo0kmKSYqUyfMwXeTFuYhNrvA2ojg0x8piqBSw9g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDZC6-00GygC-9A; Tue, 10 Aug 2021 23:21:54 +0200
Date:   Tue, 10 Aug 2021 23:21:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Michael Walle <michael@walle.cc>, anthony.l.nguyen@intel.com,
        bigeasy@linutronix.de, davem@davemloft.net,
        dvorax.fuxbrumer@linux.intel.com, f.fainelli@gmail.com,
        jacek.anaszewski@gmail.com, kuba@kernel.org, kurt@linutronix.de,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vinicius.gomes@intel.com,
        vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <YRLt8p3UI5IC0Nm5@lunn.ch>
References: <YP9n+VKcRDIvypes@lunn.ch>
 <20210727081528.9816-1-michael@walle.cc>
 <20210727165605.5c8ddb68@thinkpad>
 <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
 <20210727172828.1529c764@thinkpad>
 <8edcc387025a6212d58fe01865725734@walle.cc>
 <20210727183213.73f34141@thinkpad>
 <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com>
 <20210810172927.GB3302@amd>
 <25800302-9c02-ffb2-2887-f0cb23ad1893@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25800302-9c02-ffb2-2887-f0cb23ad1893@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> A challenge here would be unique numbering if there are multiple
> network interfaces with LED support (especially if the interfaces
> use different drivers). So the numbering service would have to be
> in LED subsystem core or network subsystem core.

Yes, it needs to be somewhere common.

We also need to document that the number is meaningless and
arbitrary. It can change from boot to boot. Also, LEDs from the same
PHY or MAC are not guaranteed to be contiguous, since multiple
PHYs/MACs can be enumerating their LEDs at the same time.

     Andrew

