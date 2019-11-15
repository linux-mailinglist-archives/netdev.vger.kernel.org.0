Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C04D2FE66A
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKOUcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:32:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40788 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfKOUcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:32:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32B1D14E13AF8;
        Fri, 15 Nov 2019 12:32:32 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:32:31 -0800 (PST)
Message-Id: <20191115.123231.2135613715202333585.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 00/11] DSA driver for Vitesse Felix switch
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114150330.25856-1-olteanv@gmail.com>
References: <20191114150330.25856-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Nov 2019 12:32:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 14 Nov 2019 17:03:19 +0200

> This series builds upon the previous "Accomodate DSA front-end into
> Ocelot" topic and does the following:
> 
> - Reworks the Ocelot (VSC7514) driver to support one more switching core
>   (VSC9959), used in NPI mode. Some code which was thought to be
>   SoC-specific (ocelot_board.c) wasn't, and vice versa, so it is being
>   accordingly moved.
> - Exports ocelot driver structures and functions to include/soc/mscc.
> - Adds a DSA ocelot front-end for VSC9959, which is a PCI device and
>   uses the exported ocelot functionality for hardware configuration.
> - Adds a tagger driver for the Vitesse injection/extraction DSA headers.
>   This is known to be compatible with at least Ocelot and Felix.

Series applied, thank you.
