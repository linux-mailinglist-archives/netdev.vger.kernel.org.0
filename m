Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE71115E51
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 20:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfLGT5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 14:57:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42802 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfLGT5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 14:57:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 63B1015421AE9;
        Sat,  7 Dec 2019 11:57:12 -0800 (PST)
Date:   Sat, 07 Dec 2019 11:57:12 -0800 (PST)
Message-Id: <20191207.115712.355931673337702807.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: ti: cpsw: fix extra rx interrupt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191206122820.24811-1-grygorii.strashko@ti.com>
References: <20191206122820.24811-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 11:57:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Fri, 6 Dec 2019 14:28:20 +0200

> Now RX interrupt is triggered twice every time, because in
> cpsw_rx_interrupt() it is asked first and then disabled. So there will be
> pending interrupt always, when RX interrupt is enabled again in NAPI
> handler.
> 
> Fix it by first disabling IRQ and then do ask.
> 
> Fixes: 870915feabdc ("drivers: net: cpsw: remove disable_irq/enable_irq as irq can be masked from cpsw itself")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied and queued up for -stable.
