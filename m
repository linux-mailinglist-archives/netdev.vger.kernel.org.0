Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D257BE936B
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfJ2XSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:18:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60946 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfJ2XSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 19:18:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5789414EBBF9A;
        Tue, 29 Oct 2019 16:18:23 -0700 (PDT)
Date:   Tue, 29 Oct 2019 16:18:22 -0700 (PDT)
Message-Id: <20191029.161822.1063139909523659432.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        jbe@pengutronix.de, robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] net: dsa: LAN9303: select REGMAP when LAN9303
 enable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191026022139.179166-1-maowenan@huawei.com>
References: <20191026022139.179166-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 16:18:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Sat, 26 Oct 2019 10:21:39 +0800

> When NET_DSA_SMSC_LAN9303=y and NET_DSA_SMSC_LAN9303_MDIO=y,
> below errors can be seen:
> drivers/net/dsa/lan9303_mdio.c:87:23: error: REGMAP_ENDIAN_LITTLE
> undeclared here (not in a function)
>   .reg_format_endian = REGMAP_ENDIAN_LITTLE,
> drivers/net/dsa/lan9303_mdio.c:93:3: error: const struct regmap_config
> has no member named reg_read
>   .reg_read = lan9303_mdio_read,
> 
> It should select REGMAP in config NET_DSA_SMSC_LAN9303.
> 
> Fixes: dc7005831523 ("net: dsa: LAN9303: add MDIO managed mode support")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Applied.
