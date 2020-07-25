Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFAB22D8FD
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 19:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgGYRjz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 25 Jul 2020 13:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgGYRjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 13:39:55 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA00C08C5C0;
        Sat, 25 Jul 2020 10:39:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id B6A361406DA;
        Sat, 25 Jul 2020 19:39:51 +0200 (CEST)
Date:   Sat, 25 Jul 2020 19:39:50 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pavel Machek <pavel@ucw.cz>, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25kxZllag==?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v3 2/2] net: phy: marvell: add
 support for PHY LEDs via LED class
Message-ID: <20200725193950.20cc9732@nic.cz>
In-Reply-To: <20200725150342.GG1472201@lunn.ch>
References: <20200724164603.29148-1-marek.behun@nic.cz>
        <20200724164603.29148-3-marek.behun@nic.cz>
        <20200725092339.GB29492@amd>
        <20200725113450.0d4c936b@nic.cz>
        <20200725150342.GG1472201@lunn.ch>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jul 2020 17:03:42 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> Does hi-z mean off? In the implementation i did, i did not list off
> and on as triggers. I instead used them for untriggered
> brightness. That allowed the software triggers to work, so i had the
> PHY blinking the heartbeat etc. But i had to make it optional, since a
> quick survey of datasheets suggested not all PHYs support simple
> on/off control.

I don't actually know what hi-z means, but enabling it disabled the LED.
But there is another register value for OFF...

> Something beyond the scope of this patchset is implementing etHool -p
> 
>        -p --identify
>               Initiates adapter-specific action intended to enable an operator to
> 	      easily identify the adapter by sight. Typically this involves  blink‐
>               ing one or more LEDs on the specific network port.
> 
> If we have software controlled on/off, then a software trigger seems
> like i good way to do this.

I'll look into this.

Marek
