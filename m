Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1AE587174
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405437AbfHIF3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:29:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56112 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfHIF3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:29:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E2A53142D945E;
        Thu,  8 Aug 2019 22:29:18 -0700 (PDT)
Date:   Thu, 08 Aug 2019 22:29:18 -0700 (PDT)
Message-Id: <20190808.222918.392250791879252329.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: remove set but not used
 variables 'tx_vid' and 'rx_vid'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190807130856.60792-1-yuehaibing@huawei.com>
References: <20190807130856.60792-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 22:29:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 7 Aug 2019 21:08:56 +0800

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/dsa/sja1105/sja1105_main.c: In function sja1105_fdb_dump:
> drivers/net/dsa/sja1105/sja1105_main.c:1226:14: warning:
>  variable tx_vid set but not used [-Wunused-but-set-variable]
> drivers/net/dsa/sja1105/sja1105_main.c:1226:6: warning:
>  variable rx_vid set but not used [-Wunused-but-set-variable]
> 
> They are not used since commit 6d7c7d948a2e ("net: dsa:
> sja1105: Fix broken learning with vlan_filtering disabled")
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied to 'net'.
