Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE3222B8DB
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgGWVqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:46:18 -0400
Received: from lists.nic.cz ([217.31.204.67]:54856 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbgGWVqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 17:46:18 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 11126140954;
        Thu, 23 Jul 2020 23:46:16 +0200 (CEST)
Date:   Thu, 23 Jul 2020 23:46:15 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25k?= =?UTF-8?B?xZllag==?= Jirman 
        <megous@megous.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v2 1/1] net: phy: marvell: add
 support for PHY LEDs via LED class
Message-ID: <20200723234615.1af24bb0@nic.cz>
In-Reply-To: <20200723213531.GK1553578@lunn.ch>
References: <20200723181319.15988-1-marek.behun@nic.cz>
        <20200723181319.15988-2-marek.behun@nic.cz>
        <20200723213531.GK1553578@lunn.ch>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jul 2020 23:35:31 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> I thought the brightness file disappeared when a trigger takes
> over. So is this possible?
> 
>       Andrew

It does not disappear nor should it. When you have a LED with 10 levels
of brightness, you want to be able to configure with which brightness
it blinks when controlled by a trigger. SW triggers use that brightness
which was stored into the brightness file when blinking the LED.

Marek
