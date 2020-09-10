Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2885C265105
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgIJUkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:40:04 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:37382 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgIJUj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:39:26 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 605991C0B76; Thu, 10 Sep 2020 22:39:23 +0200 (CEST)
Date:   Thu, 10 Sep 2020 22:39:23 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?iso-8859-2?Q?Beh=FAn?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?iso-8859-2?Q?Ond=F8ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support
 for LEDs controlled by Marvell PHYs
Message-ID: <20200910203923.GA19655@ucw.cz>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-7-marek.behun@nic.cz>
 <20200910122341.GC7907@duo.ucw.cz>
 <20200910131541.GD3316362@lunn.ch>
 <20200910161522.3cf3ad63@dellmb.labs.office.nic.cz>
 <20200910202345.GA18431@ucw.cz>
 <20200910203118.GI3354160@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910203118.GI3354160@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

> > We already have different support for blinking in LED subsystem. Lets use that.
> 
> You are assuming we have full software control of the LED, we can turn
> it on and off. That is not always the case. But there is sometimes a
> mode which the hardware blinks the LED.

Please see "timer" trigger support in the LED subsystem. We already
have hardware-accelerated blinking for the LEDs, and phy LEDs should
use same mechanism.

> Being able to blink the LED is useful: ethtool(1): -p --identify

...and yes, it should work for ethtool, too.

See leds-ss4200.c: nasgpio_led_set_blink() for an example. (But it may
not be good example).

Best regards,
								Pavel
