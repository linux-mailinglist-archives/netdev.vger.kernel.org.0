Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F0D20373C
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 14:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgFVMtf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Jun 2020 08:49:35 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:17655 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbgFVMte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 08:49:34 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id D9A86240011;
        Mon, 22 Jun 2020 12:49:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200620145252.GK304147@lunn.ch>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com> <20200619122300.2510533-4-antoine.tenart@bootlin.com> <20200620145252.GK304147@lunn.ch>
Subject: Re: [PATCH net-next v3 3/8] net: phy: mscc: remove the TR CLK disable magic value
To:     Andrew Lunn <andrew@lunn.ch>
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        richardcochran@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, foss@0leil.net
Message-ID: <159283016880.1456598.15429233660578143664@kwain>
Date:   Mon, 22 Jun 2020 14:49:28 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

Quoting Andrew Lunn (2020-06-20 16:52:52)
> On Fri, Jun 19, 2020 at 02:22:55PM +0200, Antoine Tenart wrote:
> > From: Quentin Schulz <quentin.schulz@bootlin.com>
> > 
> > This patch adds a define for the 0x8000 magic value used to perform
> > enable/disable actions on the "token ring clock". The patch is only
> > cosmetic.
> 
> I assume this is not 802.5 Token Ring?

I have not a lot of details about this; but 802.5 Token Ring would be
very surprising.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
