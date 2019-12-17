Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE601222A1
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 04:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbfLQDY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 22:24:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59322 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfLQDY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 22:24:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6D76142612B2;
        Mon, 16 Dec 2019 19:24:54 -0800 (PST)
Date:   Mon, 16 Dec 2019 19:24:54 -0800 (PST)
Message-Id: <20191216.192454.1323239340678494438.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     arnd@arndb.de, maowenan@huawei.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH net v2] net: dsa: ocelot: add NET_VENDOR_MICROSEMI
 dependency
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191215221214.15337-1-olteanv@gmail.com>
References: <20191215221214.15337-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 19:24:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon, 16 Dec 2019 00:12:14 +0200

> From: Arnd Bergmann <arnd@arndb.de>
> 
> Selecting MSCC_OCELOT_SWITCH is not possible when NET_VENDOR_MICROSEMI
> is disabled:
> 
> WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
>   Depends on [n]: NETDEVICES [=y] && ETHERNET [=n] && NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
>   Selected by [m]:
>   - NET_DSA_MSCC_FELIX [=m] && NETDEVICES [=y] && HAVE_NET_DSA [=y] && NET_DSA [=y] && PCI [=y]
> 
> Add a Kconfig dependency on NET_VENDOR_MICROSEMI, which also implies
> CONFIG_NETDEVICES.
> 
> Depending on a vendor config violates menuconfig locality for the DSA
> driver, but is the smallest compromise since all other solutions are
> much more complicated (see [0]).
> 
> https://www.spinics.net/lists/netdev/msg618808.html
> 
> Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied.
