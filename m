Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB11AC0082
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 09:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfI0H7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 03:59:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56956 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfI0H7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 03:59:45 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 63CE314DB5204;
        Fri, 27 Sep 2019 00:59:44 -0700 (PDT)
Date:   Fri, 27 Sep 2019 09:59:43 +0200 (CEST)
Message-Id: <20190927.095943.808126689307036272.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     igor.russkikh@aquantia.com, vomlehn@texas.net,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: aquantia: Fix aq_vec_isr_legacy() return value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925105430.GA3264@mwanda>
References: <20190925105430.GA3264@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 00:59:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 25 Sep 2019 13:54:30 +0300

> The irqreturn_t type is an enum or an unsigned int in GCC.  That
> creates to problems because it can't detect if the
> self->aq_hw_ops->hw_irq_read() call fails and at the end the function
> always returns IRQ_HANDLED.
> 
> drivers/net/ethernet/aquantia/atlantic/aq_vec.c:316 aq_vec_isr_legacy() warn: unsigned 'err' is never less than zero.
> drivers/net/ethernet/aquantia/atlantic/aq_vec.c:329 aq_vec_isr_legacy() warn: always true condition '(err >= 0) => (0-u32max >= 0)'
> 
> Fixes: 970a2e9864b0 ("net: ethernet: aquantia: Vector operations")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
