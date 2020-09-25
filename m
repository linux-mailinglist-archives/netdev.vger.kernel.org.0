Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65038277E52
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgIYDC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 23:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgIYDC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 23:02:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A6FC0613CE;
        Thu, 24 Sep 2020 20:02:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 643E7135F8F17;
        Thu, 24 Sep 2020 19:45:40 -0700 (PDT)
Date:   Thu, 24 Sep 2020 20:02:26 -0700 (PDT)
Message-Id: <20200924.200226.18307161355531225.davem@davemloft.net>
To:     xiaoliang.yang_1@nxp.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        po.liu@nxp.com, claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com
Subject: Re: [net] net: dsa: felix: convert TAS link speed based on phylink
 speed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200924015746.7994-1-xiaoliang.yang_1@nxp.com>
References: <20200924015746.7994-1-xiaoliang.yang_1@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 19:45:40 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Date: Thu, 24 Sep 2020 09:57:46 +0800

> state->speed holds a value of 10, 100, 1000 or 2500, but
> QSYS_TAG_CONFIG_LINK_SPEED expects a value of 0, 1, 2, 3. So convert the
> speed to a proper value.
> 
> Fixes: de143c0e274b ("net: dsa: felix: Configure Time-Aware Scheduler via taprio offload")
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied and queued up for -stable.
