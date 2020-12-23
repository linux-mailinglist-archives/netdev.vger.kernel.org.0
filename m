Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02082E21CB
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 22:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgLWU7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:59:38 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59393 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgLWU7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 15:59:37 -0500
X-Originating-IP: 176.167.17.253
Received: from localhost (unknown [176.167.17.253])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 4C22760005;
        Wed, 23 Dec 2020 20:58:53 +0000 (UTC)
Date:   Wed, 23 Dec 2020 21:58:52 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 3/8] net: sparx5: add hostmode with phylink support
Message-ID: <20201223205852.GA4138276@piout.net>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-4-steen.hegelund@microchip.com>
 <20201219195133.GD3026679@lunn.ch>
 <fabe6df8e8d1fab86860164ced4142afae3bd70d.camel@microchip.com>
 <20201222144141.GK3107610@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222144141.GK3107610@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/12/2020 15:41:41+0100, Andrew Lunn wrote:
> > Yes the register based injection/extration is not going to be fast, but
> > the FDMA and its driver is being sent later as separate series to keep
> > the size of this review down.
> 
> FDMA?
> 
> I need a bit more background here, just to make use this should be a
> pure switchdev driver and not a DSA driver.
> 

I don't think this should be a DSA driver. As for Ocelot, the CPU
port is not a MAC and in that use case, this would be like a top of the
rack switch with traffic going to the CPU port being mostly used for
managmement (dhcp, stp, etc...) as opposed to being used to forward
traffic to another interface, like WAN or wifi.

However, I would think there will be cases where the internal CPU is not
use and instead use ths switch in a DSA setting, very much like what is
done for Felix with regards to Ocelot.


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
