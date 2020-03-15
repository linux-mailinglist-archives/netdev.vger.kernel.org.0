Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55322185B02
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 08:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbgCOHRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 03:17:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36026 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgCOHRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 03:17:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5D41B13E81160;
        Sun, 15 Mar 2020 00:17:08 -0700 (PDT)
Date:   Sun, 15 Mar 2020 00:17:07 -0700 (PDT)
Message-Id: <20200315.001707.1935294799735002115.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com
Subject: Re: [PATCH net-next] net: mscc: ocelot: adjust maxlen on NPI port,
 not CPU
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313134651.5771-1-olteanv@gmail.com>
References: <20200313134651.5771-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Mar 2020 00:17:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 13 Mar 2020 15:46:51 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Being a non-physical port, the CPU port does not have an ocelot_port
> structure, so the ocelot_port_writel call inside the
> ocelot_port_set_maxlen() function would access data behind a NULL
> pointer.
> 
> This is a patch for net-next only, the net tree boots fine, the bug was
> introduced during the net -> net-next merge.
> 
> Fixes: 1d3435793123 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
> Fixes: a8015ded89ad ("net: mscc: ocelot: properly account for VLAN header length when setting MRU")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

I should have been more careful with this merge conflict. :-)

Applied, thank you.
