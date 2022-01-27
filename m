Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DE449E0E2
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240333AbiA0L3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235802AbiA0L27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:28:59 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9B5C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 03:28:59 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2xP-00061U-Mf; Thu, 27 Jan 2022 12:28:51 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2xP-0008N3-4t; Thu, 27 Jan 2022 12:28:51 +0100
Date:   Thu, 27 Jan 2022 12:28:51 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/4] dt-bindings: net: add schema for
 Microchip/SMSC LAN95xx USB Ethernet controllers
Message-ID: <20220127112851.GD9150@pengutronix.de>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-3-o.rempel@pengutronix.de>
 <YfJ6/xdacR59Jvq+@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfJ6/xdacR59Jvq+@kroah.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:24:39 up 47 days, 20:10, 83 users,  load average: 0.01, 0.08,
 0.14
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:59:11AM +0100, Greg KH wrote:
> On Thu, Jan 27, 2022 at 11:49:03AM +0100, Oleksij Rempel wrote:
> > Create initial schema for Microchip/SMSC LAN95xx USB Ethernet controllers and
> > import all currently supported USB IDs form drivers/net/usb/smsc95xx.c
> 
> That is a loosing game to play.  There is a reason that kernel drivers
> only require a device id in 1 place, instead of multiple places like
> other operating systems.  Please do not go back and make the same
> mistakes others have.
> 
> Not to mention that I think overall this is a bad idea anyway.  USB
> devices are self-describing, don't add them to DT.

This patch set is the pre-step before making it even more complicated
with description of external PHYs and DSA switches. I assume, it is
preferable to have schema to be able to automatically validate it.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
