Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D20263895
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgIIVkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:40:14 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:43626 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgIIVkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:40:13 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D27241C0B87; Wed,  9 Sep 2020 23:40:09 +0200 (CEST)
Date:   Wed, 9 Sep 2020 23:40:09 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?iso-8859-2?Q?Ond=F8ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 2/7] leds: add generic API for LEDs
 that can be controlled by hardware
Message-ID: <20200909214009.GA16084@ucw.cz>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-3-marek.behun@nic.cz>
 <20200909204815.GB20388@amd>
 <20200909232016.138bd1db@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200909232016.138bd1db@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

> > > Many an ethernet PHY (and other chips) supports various HW control modes
> > > for LEDs connected directly to them.  
> > 
> > I guess this should be
> > 
> > "Many ethernet PHYs (and other chips) support various HW control modes
> > for LEDs connected directly to them."
> > 
> 
> I guess it is older English, used mainly in poetry, but I read it in
> works of contemporary fiction as well. As far as I could find, it is still
> actually gramatically correct.
> https://idioms.thefreedictionary.com/many+an
> https://en.wiktionary.org/wiki/many_a
> But I will change it if you insist on it.

Okay, you got me.

> > > +Contact:	Marek Behún <marek.behun@nic.cz>
> > > +		linux-leds@vger.kernel.org
> > > +Description:	(W) Set the HW control mode of this LED. The various available HW control modes
> > > +		    are specific per device to which the LED is connected to and per LED itself.
> > > +		(R) Show the available HW control modes and the currently selected one.  
> > 
> > 80 columns :-) (and please fix that globally, at least at places where
> > it is easy, like comments).
> > 
> 
> Linux is at 100 columns now since commit bdc48fa11e46, commited by
> Linus. See
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/scripts/checkpatch.pl?h=v5.9-rc4&id=bdc48fa11e46f867ea4d75fa59ee87a7f48be144
> There was actually an article about this on Phoronix, I think.

It is not. Checkpatch no longer warns about it, but 80 columns is
still preffered, see Documentation/process/coding-style.rst . Plus,
you want me to take the patch, not Linus.

> > > +extern struct led_hw_trigger_type hw_control_led_trig_type;
> > > +extern struct led_trigger hw_control_led_trig;
> > > +
> > > +#else /* !IS_ENABLED(CONFIG_LEDS_HW_CONTROLLED) */  
> > 
> > CONFIG_LEDS_HWC? Or maybe CONFIG_LEDTRIG_HW?
> 
> The second option looks more reasonable to me, if we move to
> drivers/leds/trigger.

Ok :-).

Best regards,
							Pavel
