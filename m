Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCEDA1E53F
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 00:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfENWla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 18:41:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59772 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfENWla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 18:41:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C0F4D14C048B2;
        Tue, 14 May 2019 15:41:29 -0700 (PDT)
Date:   Tue, 14 May 2019 15:41:29 -0700 (PDT)
Message-Id: <20190514.154129.1092466491484366074.davem@davemloft.net>
To:     luca@lucaceresoli.net
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        soren.brinkmann@xilinx.com, cyrille.pitchen@atmel.com,
        shubhrajyoti.datta@xilinx.com, harini.katakam@xilinx.com
Subject: Re: [PATCH net RESEND] net: macb: fix error format in dev_err()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190514132307.15311-1-luca@lucaceresoli.net>
References: <20190514132307.15311-1-luca@lucaceresoli.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 May 2019 15:41:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Ceresoli <luca@lucaceresoli.net>
Date: Tue, 14 May 2019 15:23:07 +0200

> Errors are negative numbers. Using %u shows them as very large positive
> numbers such as 4294967277 that don't make sense. Use the %d format
> instead, and get a much nicer -19.
> 
> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> Fixes: b48e0bab142f ("net: macb: Migrate to devm clock interface")
> Fixes: 93b31f48b3ba ("net/macb: unify clock management")
> Fixes: 421d9df0628b ("net/macb: merge at91_ether driver into macb driver")
> Fixes: aead88bd0e99 ("net: ethernet: macb: Add support for rx_clk")
> Fixes: f5473d1d44e4 ("net: macb: Support clock management for tsu_clk")
> Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied.
