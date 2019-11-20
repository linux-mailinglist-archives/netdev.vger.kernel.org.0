Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA37A1031CA
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 03:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfKTCxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 21:53:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48948 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbfKTCxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 21:53:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F804146D043A;
        Tue, 19 Nov 2019 18:53:23 -0800 (PST)
Date:   Tue, 19 Nov 2019 18:53:23 -0800 (PST)
Message-Id: <20191119.185323.1049045586606004090.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net v2] net: dsa: ocelot: add dependency for
 NET_DSA_MSCC_FELIX
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120014722.8075-1-maowenan@huawei.com>
References: <20191119.154125.1492881397881625788.davem@davemloft.net>
        <20191120014722.8075-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 18:53:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Wed, 20 Nov 2019 09:47:22 +0800

> If CONFIG_NET_DSA_MSCC_FELIX=y, and CONFIG_NET_VENDOR_MICROSEMI=n,
> below errors can be found:
> drivers/net/dsa/ocelot/felix.o: In function `felix_vlan_del':
> felix.c:(.text+0x26e): undefined reference to `ocelot_vlan_del'
> drivers/net/dsa/ocelot/felix.o: In function `felix_vlan_add':
> felix.c:(.text+0x352): undefined reference to `ocelot_vlan_add'
> 
> and warning as below:
> WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
> Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] &&
> NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
> Selected by [y]:
> NET_DSA_MSCC_FELIX [=y] && NETDEVICES [=y] && HAVE_NET_DSA [=y]
> && NET_DSA [=y] && PCI [=y]
> 
> This patch is to select NET_VENDOR_MICROSEMI for NET_DSA_MSCC_FELIX.
> 
> Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

You did not read my feedback, read it again please.
