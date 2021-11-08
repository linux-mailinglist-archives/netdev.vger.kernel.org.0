Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DA7448085
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 14:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240088AbhKHNvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 08:51:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238013AbhKHNvV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 08:51:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=wJ+KFiLWXSd9Yn9CEeNsZPzYPyPhxqpWIbv+1zHqmxk=; b=rj
        G4BV9DFGE0jD9Fw+5Lc4bnd7zyJ2u1yBCjc7borAofsYd7g31Dv3BYCOw5MVBPQYf7UhQxnl5II06
        ZFEKA8imfILSvCXPiLTS+U00pUlqDxkh/l9dSStH2iEEXLLOtRDgq4rCb7jeSsPpL0nyViV2kxAyQ
        E+JgYaeHSpAJENc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mk50f-00Ctqr-DH; Mon, 08 Nov 2021 14:48:29 +0100
Date:   Mon, 8 Nov 2021 14:48:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH 2/6] leds: permit to declare supported offload
 triggers
Message-ID: <YYkqrbenDPpck2yO@lunn.ch>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
 <20211107175718.9151-3-ansuelsmth@gmail.com>
 <20211107230624.5251eccb@thinkpad>
 <YYhUGNs1I0RWriln@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YYhUGNs1I0RWriln@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 07, 2021 at 11:32:56PM +0100, Ansuel Smith wrote:
> On Sun, Nov 07, 2021 at 11:06:24PM +0100, Marek Behún wrote:
> > On Sun,  7 Nov 2021 18:57:14 +0100
> > Ansuel Smith <ansuelsmth@gmail.com> wrote:
> > 
> > > With LEDs that can be offload driven, permit to declare supported triggers
> > > in the dts and add them to the cled struct to be used by the related
> > > offload trigger. This is particurally useful for phy that have support
> > > for HW blinking on tx/rx traffic or based on the speed link.
> > > 
> > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > 
> > NAK. The device-tree shouldn't define this, only the LED's function as
> > designated by the manufacturer of the device.
> > 
> > Marek
> 
> Sure I will add a way to ask the led driver if the trigger is supported
> and report it.

Yes, you need some way for the PHY/MAC driver to enumerate what it can
do.

I've not looked at v2 yet...

	Andrew
