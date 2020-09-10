Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDD12650FD
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgIJUiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgIJUbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:31:20 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79508C061573;
        Thu, 10 Sep 2020 13:31:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id B671E13FD86;
        Thu, 10 Sep 2020 22:31:12 +0200 (CEST)
Date:   Thu, 10 Sep 2020 22:31:12 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, Pavel Machek <pavel@ucw.cz>,
        netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25kxZllag==?= Jirman <megous@megous.com>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support
 for LEDs controlled by Marvell PHYs
Message-ID: <20200910223112.26b57dd6@nic.cz>
In-Reply-To: <20200910183435.GC1551@shell.armlinux.org.uk>
References: <20200909162552.11032-1-marek.behun@nic.cz>
        <20200909162552.11032-7-marek.behun@nic.cz>
        <20200910122341.GC7907@duo.ucw.cz>
        <20200910131541.GD3316362@lunn.ch>
        <20200910182434.GA22845@duo.ucw.cz>
        <20200910183154.GF3354160@lunn.ch>
        <20200910183435.GC1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 19:34:35 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Thu, Sep 10, 2020 at 08:31:54PM +0200, Andrew Lunn wrote:
> > Generally the driver will default to the hardware reset blink
> > pattern. There are a few PHY drivers which change this at probe, but
> > not many. The silicon defaults are pretty good.  
> 
> The "right" blink pattern can be a matter of how the hardware is
> wired.  For example, if you have bi-colour LEDs and the PHY supports
> special bi-colour mixing modes.
> 

Have you seen such, Russell? This could be achieved via the multicolor
LED framework, but I don't have a device which uses such LEDs, so I
did not write support for this in the Marvell PHY driver.

(I guess I could test it though, since on my device LED0 and LED1
are used, and this to can be put into bi-colour LED mode.)
