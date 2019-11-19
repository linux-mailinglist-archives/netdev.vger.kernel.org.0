Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FFE102FBB
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 00:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfKSXLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 18:11:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46360 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfKSXLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 18:11:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 36DF51426D11D;
        Tue, 19 Nov 2019 15:11:30 -0800 (PST)
Date:   Tue, 19 Nov 2019 15:11:29 -0800 (PST)
Message-Id: <20191119.151129.1342655675638983358.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     linux@armlinux.org.uk, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Convert Ocelot and Felix switches to
 PHYLINK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191118181030.23921-1-olteanv@gmail.com>
References: <20191118181030.23921-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 15:11:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon, 18 Nov 2019 20:10:28 +0200

> This series is needed on NXP LS1028A to support the CPU port which runs
> at 2500Mbps fixed-link, a setting which PHYLIB can't hold in its swphy
> design.
> 
> In DSA, PHYLINK comes "for free". I added the PHYLINK ops to the Ocelot
> driver, integrated them to the VSC7514 ocelot_board module, then tested
> them via the Felix front-end. The VSC7514 integration is only
> compile-tested.

Please sort out the crash that was reported and resubmit, thank you.
