Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A7B1DF2CF
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731303AbgEVXQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731175AbgEVXQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:16:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F489C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 16:16:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C50B127517B5;
        Fri, 22 May 2020 16:16:02 -0700 (PDT)
Date:   Fri, 22 May 2020 16:16:01 -0700 (PDT)
Message-Id: <20200522.161601.1692050662918253992.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        claudiu.manoil@nxp.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com
Subject: Re: [PATCH net] net: mscc: ocelot: fix address ageing time (again)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200521213123.672163-1-olteanv@gmail.com>
References: <20200521213123.672163-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 16:16:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 22 May 2020 00:31:23 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> ocelot_set_ageing_time has 2 callers:
>  - felix_set_ageing_time: from drivers/net/dsa/ocelot/felix.c
>  - ocelot_port_attr_ageing_set: from drivers/net/ethernet/mscc/ocelot.c
> 
> The issue described in the fixed commit below actually happened for the
> felix_set_ageing_time code path only, since ocelot_port_attr_ageing_set
> was already dividing by 1000. So to make both paths symmetrical (and to
> fix addresses getting aged way too fast on Ocelot), stop dividing by
> 1000 at caller side altogether.
> 
> Fixes: c0d7eccbc761 ("net: mscc: ocelot: ANA_AUTOAGE_AGE_PERIOD holds a value in seconds, not ms")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied.
