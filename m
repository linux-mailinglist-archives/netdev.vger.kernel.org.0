Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B347130A96
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 23:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgAEW4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 17:56:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42076 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgAEW4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 17:56:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E8B4156A2632;
        Sun,  5 Jan 2020 14:56:21 -0800 (PST)
Date:   Sun, 05 Jan 2020 14:56:20 -0800 (PST)
Message-Id: <20200105.145620.1374612953471751229.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     jakub.kicinski@netronome.com, linux@armlinux.org.uk,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH v4 net-next 0/9] Convert Felix DSA switch to PHYLINK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200103200127.6331-1-olteanv@gmail.com>
References: <20200103200127.6331-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 14:56:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri,  3 Jan 2020 22:01:18 +0200

> Unlike most other conversions, this one is not by far a trivial one, and should
> be seen as "Layerscape PCS meets PHYLINK". Actually, the PCS doesn't
> need a lot of hand-holding and most of our other devices 'just work'
> (this one included) without any sort of operating system awareness, just
> an initialization procedure done typically in the bootloader.
> Our issues start when the PCS stops from "just working", and that is
> where PHYLINK comes in handy.
> 
> The PCS is not specific to the Vitesse / Microsemi / Microchip switching core
> at all. Variations of this SerDes/PCS design can also be found on DPAA1 and
> DPAA2 hardware.
> 
> The main idea of the abstraction provided is that the PCS looks so much like a
> PHY device, that we model it as an actual PHY device and run the generic PHY
> functions on it, where appropriate.
 ...

Series applied, please address any follow-up feedback you receive.

Thank you.
