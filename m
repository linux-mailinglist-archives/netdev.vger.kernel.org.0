Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258512650F5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgIJUhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:37:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56336 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgIJUb1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 16:31:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kGTDy-00E8NT-2k; Thu, 10 Sep 2020 22:31:18 +0200
Date:   Thu, 10 Sep 2020 22:31:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support
 for LEDs controlled by Marvell PHYs
Message-ID: <20200910203118.GI3354160@lunn.ch>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-7-marek.behun@nic.cz>
 <20200910122341.GC7907@duo.ucw.cz>
 <20200910131541.GD3316362@lunn.ch>
 <20200910161522.3cf3ad63@dellmb.labs.office.nic.cz>
 <20200910202345.GA18431@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910202345.GA18431@ucw.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We already have different support for blinking in LED subsystem. Lets use that.

You are assuming we have full software control of the LED, we can turn
it on and off. That is not always the case. But there is sometimes a
mode which the hardware blinks the LED.

Being able to blink the LED is useful:

ethtool(1):

       -p --identify

       Initiates adapter-specific action intended to enable an
       operator to easily identify the adapter by sight.  Typically
       this involves blinking one or more LEDs on the specific network
       port.

Once we get LED support in, i expect we will make use of this blink
mode for this ethtool option.

      Andrew
