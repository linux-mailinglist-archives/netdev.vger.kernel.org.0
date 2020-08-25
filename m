Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848EA2513E7
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 10:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgHYIOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 04:14:05 -0400
Received: from mx1.tq-group.com ([62.157.118.193]:9509 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgHYIOE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 04:14:04 -0400
IronPort-SDR: 3TZ+pFKs7+99wzg5P+7OVUGj7Aleqy2XQ6PeHy9Jnh00a6aA9nbnDlKSBSL2mFvX7X4Z1APj+O
 H/1SEYCHDR59cgkjjmIbjyxvTPPAg1ZQZlSdadW2F4TEPAFBLpTJzi7I4ovJLrReUXgzns7BEl
 G3vNt/5vlQl4/hkR6iilwOwuR4lHLjjEAYPLf6KUuZM2yUO9OhsbXZQLhttE6hH5KVmcy22A28
 bbz5rUHJJKh7wX7gCOlULeFjnR5M3INJrT7684mp1edsC0TXyY0ho5ghzPXh3ncspF7KC8DuOa
 Aog=
X-IronPort-AV: E=Sophos;i="5.76,351,1592863200"; 
   d="scan'208";a="13585174"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 25 Aug 2020 10:14:02 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Tue, 25 Aug 2020 10:14:02 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Tue, 25 Aug 2020 10:14:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1598343242; x=1629879242;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SbnisccfhTeUVsH1MoGKsVpn0dy/gnGJsTIGiG2lQNA=;
  b=ZEvN7jDPW+J0vAHgxc7i1JxAolwjIFAKHqIPg3UwgIssSfehdis8FMP1
   9he1AQWVt276Wn01MfhAhUWOLBZNd/TzD4UghrYomPrDe7MQ3A7/L6C1t
   IGvaskdjgvkkN+ye9JK5xfqgwHFdlzKe/zAoov8l/pgrk87OccD0mkUKJ
   vTLCBIXhZm8QVQCYcZP1WbGshMbmcw6/WwD3O6MEgM4FfSNl/vIRFFInl
   DMllpQCIzdOKBLgxWWszTQhY3c84As4cTCMQen3XIZOX9LyT7ay+VoDQ3
   +BYfdhJiOLEwk19xoYVXlpHGos/euvLTE/WY1QGTAtFWt8MPQiRjnBipv
   Q==;
IronPort-SDR: /Hr8llNwaok/l5wxLk2a7W2+jptFZ1II6U8aUetTCCD4/EaBVgu0mLd6C6TcErxFDxM/8GMwtv
 rULJHQ6MMsCdDajiUT3EHpOMD53+xc7a/Fmugyfuk52a94oGist6EaelEXP2z7XBWlUkgKWKSm
 GlaTkRampryusq326ZbOQ3UjkzrZGc6efxixx8QTWZT81oKgyNDip9G7xwQOPhHBS/gUcnRSZR
 1UzLq5ZA748gJfg8wWMTb67NbSsir+5m/3x8pA3cbzKFmpakuCDLOQewSytyppBLwOy/Nx7gGL
 bzg=
X-IronPort-AV: E=Sophos;i="5.76,351,1592863200"; 
   d="scan'208";a="13585173"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 25 Aug 2020 10:14:02 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.117.49.26])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 0F10A280065;
        Tue, 25 Aug 2020 10:14:02 +0200 (CEST)
Message-ID: <2b3604bf88082f8d8f6d21707907eff757b49362.camel@ew.tq-group.com>
Subject: Re: [PATCH RFC leds + net-next v4 0/2] Add support for LEDs on
 Marvell PHYs
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Tue, 25 Aug 2020 10:13:59 +0200
In-Reply-To: <20200728150530.28827-1-marek.behun@nic.cz>
References: <20200728150530.28827-1-marek.behun@nic.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-07-28 at 17:05 +0200, Marek Behún wrote:
> Hi,
> 
> this is v4 of my RFC adding support for LEDs connected to Marvell
> PHYs.
> 
> Please note that if you want to test this, you still need to first
> apply
> the patch adding the LED private triggers support from Pavel's tree.
> 
https://git.kernel.org/pub/scm/linux/kernel/git/pavel/linux-leds.git/commit/?h=for-next&id=93690cdf3060c61dfce813121d0bfc055e7fa30d
> 
> What I still don't like about this is that the LEDs created by the
> code
> don't properly support device names. LEDs should have name in format
> "device:color:function", for example "eth0:green:activity".
> 
> The code currently looks for attached netdev for a given PHY, but
> at the time this happens there is no netdev attached, so the LEDs
> gets
> names without the device part (ie ":green:activity").
> 
> This can be addressed in next version by renaming the LED when a
> netdev
> is attached to the PHY, but first a API for LED device renaming needs
> to
> be proposed. I am going to try to do that. This would also solve the
> same problem when userspace renames an interface.
> 
> And no, I don't want phydev name there.


Hello Marek,

thanks for your patches - Andrew suggested me to have a look at them as
I'm currently trying to add LED trigger support to the TI DP83867 PHY.

Is there already a plan to add support for polarity and similiar
settings, at least to the generic part of your changes?

In the TI DP83867, there are 2 separate settings for each LED:

- Trigger event
- Polarity or override (active-high/active-low/force-high/force-low -
the latter two would be used for led_brightness_set)
- (There is also a 3rd register that defines the blink frequency, but
as it allows only a single setting for all LEDs, I would ignore it for
now)

At least the per-LED polarity setting would be essential to have for
this feature to be useful for our TQ-Systems mainboards with TI PHYs.


Kind regards,
Matthias



> 
> Changes since v3:
> - addressed some of Andrew's suggestions
> - phy_hw_led_mode.c renamed to phy_led.c
> - the DT reading code is now also generic, moved to phy_led.c and
> called
>   from phy_probe
> - the function registering the phydev-hw-mode trigger is now called
> from
>   phy_device.c function phy_init before registering genphy drivers
> - PHY LED functionality now depends on CONFIG_LEDS_TRIGGERS
> 
> Changes since v2:
> - to share code with other drivers which may want to also offer PHY
> HW
>   control of LEDs some of the code was refactored and now resides in
>   phy_hw_led_mode.c. This code is compiled in when config option
>   LED_TRIGGER_PHY_HW is enabled. Drivers wanting to offer PHY HW
> control
>   of LEDs should depend on this option.
> - the "hw-control" trigger is renamed to "phydev-hw-mode" and is
>   registered by the code in phy_hw_led_mode.c
> - the "hw_control" sysfs file is renamed to "hw_mode"
> - struct phy_driver is extended by three methods to support PHY HW
> LED
>   control
> - I renamed the various HW control modes offeret by Marvell PHYs to
>   conform to other Linux mode names, for example the
> "1000/100/10/else"
>   mode was renamed to "1Gbps/100Mbps/10Mbps", or "recv/else" was
> renamed
>   to "rx" (this is the name of the mode in netdev trigger).
> 
> Marek
> 
> 
> Marek Behún (2):
>   net: phy: add API for LEDs controlled by PHY HW
>   net: phy: marvell: add support for PHY LEDs via LED class
> 
>  drivers/net/phy/Kconfig      |   4 +
>  drivers/net/phy/Makefile     |   1 +
>  drivers/net/phy/marvell.c    | 287
> +++++++++++++++++++++++++++++++++++
>  drivers/net/phy/phy_device.c |  25 ++-
>  drivers/net/phy/phy_led.c    | 176 +++++++++++++++++++++
>  include/linux/phy.h          |  51 +++++++
>  6 files changed, 537 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/net/phy/phy_led.c
> 

