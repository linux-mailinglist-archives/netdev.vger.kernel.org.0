Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E65D3D3E6A
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhGWQkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhGWQkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:40:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6C1C061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 10:21:05 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m6yr1-00050d-N2; Fri, 23 Jul 2021 19:20:55 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1m6yr0-0000IS-5s; Fri, 23 Jul 2021 19:20:54 +0200
Date:   Fri, 23 Jul 2021 19:20:54 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     alexandru.tachici@analog.com
Cc:     andrew@lunn.ch, alexandru.ardelean@analog.com, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org
Subject: Re: ADIN1100
Message-ID: <20210723172054.nfq3shvfhidfnjyn@pengutronix.de>
References: <YO3GNqqUbyxId+Mn@lunn.ch>
 <20210716212427.55302-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210716212427.55302-1-alexandru.tachici@analog.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:19:14 up 233 days,  7:25, 27 users,  load average: 0.16, 0.13,
 0.09
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 17, 2021 at 12:24:27AM +0300, alexandru.tachici@analog.com wrote:
> No, ADIN1100 supports only full duplex mode. Added this one just to
> report through ethtool if lp supports it or not.

Same about TI T1L phy, there is not half duplex support. I'm courios if
this is actually required by the 802.3cg standard. 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
