Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07D22629D1
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404217AbfGHTna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:43:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57300 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729234AbfGHTna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:43:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B05B4133E9BDB;
        Mon,  8 Jul 2019 12:43:29 -0700 (PDT)
Date:   Mon, 08 Jul 2019 12:43:29 -0700 (PDT)
Message-Id: <20190708.124329.1064143533263537490.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     nicolas.ferre@microchip.com, palmer@sifive.com,
        paul.walmsley@sifive.com, yash.shah@sifive.com,
        harini.katakam@xilinx.com, claudiu.beznea@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH] [net-next] macb: fix build warning for !CONFIG_OF
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190708124840.3616530-1-arnd@arndb.de>
References: <20190708124840.3616530-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 12:43:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon,  8 Jul 2019 14:48:23 +0200

> When CONFIG_OF is disabled, we get a harmless warning about the
> newly added variable:
> 
> drivers/net/ethernet/cadence/macb_main.c:48:39: error: 'mgmt' defined but not used [-Werror=unused-variable]
>  static struct sifive_fu540_macb_mgmt *mgmt;
> 
> Move the variable closer to its use inside of the #ifdef.
> 
> Fixes: c218ad559020 ("macb: Add support for SiFive FU540-C000")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks Arnd.
