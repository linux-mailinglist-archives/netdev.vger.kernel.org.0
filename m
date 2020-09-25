Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4D0277E54
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgIYDCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 23:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgIYDCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 23:02:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92D3C0613CE;
        Thu, 24 Sep 2020 20:02:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 72D0E135F8F15;
        Thu, 24 Sep 2020 19:45:49 -0700 (PDT)
Date:   Thu, 24 Sep 2020 20:02:35 -0700 (PDT)
Message-Id: <20200924.200235.1283836204141798802.davem@davemloft.net>
To:     xiaoliang.yang_1@nxp.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        fido_max@inbox.ru, alexandru.marginean@nxp.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com, leoyang.li@nxp.com
Subject: Re: [net] net: mscc: ocelot: fix fields offset in SG_CONFIG_REG_3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200924021113.9964-1-xiaoliang.yang_1@nxp.com>
References: <20200924021113.9964-1-xiaoliang.yang_1@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 19:45:50 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Date: Thu, 24 Sep 2020 10:11:13 +0800

> INIT_IPS and GATE_ENABLE fields have a wrong offset in SG_CONFIG_REG_3.
> This register is used by stream gate control of PSFP, and it has not
> been used before, because PSFP is not implemented in ocelot driver.
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

Applied and queued up for -stable.
