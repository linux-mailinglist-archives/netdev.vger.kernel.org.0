Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8460D2638A2
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgIIVnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:43:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53508 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgIIVnP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 17:43:15 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kG7rn-00Dyhc-B3; Wed, 09 Sep 2020 23:42:59 +0200
Date:   Wed, 9 Sep 2020 23:42:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 0/7] PLEASE REVIEW: Add support for
 LEDs on Marvell PHYs
Message-ID: <20200909214259.GL3290129@lunn.ch>
References: <20200909162552.11032-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200909162552.11032-1-marek.behun@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 06:25:45PM +0200, Marek Behún wrote:
> Hello Andrew and Pavel,
> 
> please review these patches adding support for HW controlled LEDs.
> The main difference from previous version is that the API is now generalized
> and lives in drivers/leds, so that part needs to be reviewed (and maybe even
> applied) by Pavel.
> 
> As discussed previously between you two, I made it so that the devicename
> part of the LED is now in the form `ethernet-phy%i` when the LED is probed
> for an ethernet PHY. Userspace utility wanting to control LEDs for a specific
> network interface can access them via /sys/class/net/eth0/phydev/leds:
> 
>   mox ~ # ls /sys/class/net/eth0/phydev/leds

It is nice they are directly in /sys/class/net/eth0/phydev. Do they
also appear in /sys/class/led?

Have you played with network namespaces? What happens with

ip netns add ns1

ip link set eth0 netns ns1

   Andrew
