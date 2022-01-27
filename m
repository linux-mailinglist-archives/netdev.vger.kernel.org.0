Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2657E49E268
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 13:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241156AbiA0McB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 07:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241150AbiA0McB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 07:32:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4A5C06173B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 04:32:01 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nD3wP-00067W-Q3; Thu, 27 Jan 2022 13:31:53 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nD3wO-0003q2-VX; Thu, 27 Jan 2022 13:31:52 +0100
Date:   Thu, 27 Jan 2022 13:31:52 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] usbnet: add devlink support
Message-ID: <20220127123152.GF9150@pengutronix.de>
References: <20220127110742.922752-1-o.rempel@pengutronix.de>
 <YfJ+ceEzvzMM1JsW@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfJ+ceEzvzMM1JsW@kroah.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:29:24 up 47 days, 21:14, 90 users,  load average: 0.07, 0.29,
 0.30
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 12:13:53PM +0100, Greg KH wrote:
> On Thu, Jan 27, 2022 at 12:07:42PM +0100, Oleksij Rempel wrote:
> > The weakest link of usbnet devices is the USB cable.
> 
> The weakest link of any USB device is the cable, why is this somehow
> special to usbnet devices?
> 
> > Currently there is
> > no way to automatically detect cable related issues except of analyzing
> > kernel log, which would differ depending on the USB host controller.
> > 
> > The Ethernet packet counter could potentially show evidence of some USB
> > related issues, but can be Ethernet related problem as well.
> > 
> > To provide generic way to detect USB issues or HW issues on different
> > levels we need to make use of devlink.
> 
> Please make this generic to all USB devices, usbnet is not special here
> at all.

Ok. I'll need some help. What is the best place to attach devlink
registration in the USB subsystem and the places to attach health
reporters?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
