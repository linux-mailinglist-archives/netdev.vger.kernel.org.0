Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81FF3C36B0
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 22:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhGJUEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 16:04:34 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:45065 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhGJUEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 16:04:33 -0400
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id A34AD20005;
        Sat, 10 Jul 2021 20:01:45 +0000 (UTC)
Date:   Sat, 10 Jul 2021 22:01:45 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, claudiu.manoil@nxp.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 0/8] Add support for VSC7511-7514 chips
 over SPI
Message-ID: <YOn8qSYqEufgfuJa@piout.net>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710192602.2186370-1-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/07/2021 12:25:54-0700, Colin Foster wrote:
> Add support for configuration and control of the VSC7511, VSC7512, VSC7513, and
> VSC7514 chips over a SPI interface. The intent is to control these chips from an
> external CPU. The expectation is to have most of the features of the
> net/ethernet/mscc/ocelot_vsc7514 driver.
> 
> I have tried to heed all the advice from my first patch RFC. Thanks to everyone
> for all the feedback.
> 
> The current status is that there are two functional "bugs" that need
> investigation:
> 1. The first probe of the internal MDIO bus fails. I suspect this is related to
> power supplies / grounding issues that would not appear on standard hardware.

Did you properly reset the internal phys? mdio-mscc-miim.c does that.

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
