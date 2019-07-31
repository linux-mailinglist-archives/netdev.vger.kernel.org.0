Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A537C6E1
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfGaPgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:36:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbfGaPgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:36:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ABDAB12B8A10D;
        Wed, 31 Jul 2019 08:36:52 -0700 (PDT)
Date:   Wed, 31 Jul 2019 08:36:52 -0700 (PDT)
Message-Id: <20190731.083652.764868636947922667.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     mark.einon@gmail.com, willy@infradead.org, f.fainelli@gmail.com,
        andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: et131x: Use GFP_KERNEL instead of
 GFP_ATOMIC when allocating tx_ring->tcb_ring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190731073842.16948-1-christophe.jaillet@wanadoo.fr>
References: <20190731073842.16948-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 08:36:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Wed, 31 Jul 2019 09:38:42 +0200

> There is no good reason to use GFP_ATOMIC here. Other memory allocations
> are performed with GFP_KERNEL (see other 'dma_alloc_coherent()' below and
> 'kzalloc()' in 'et131x_rx_dma_memory_alloc()')
> 
> Use GFP_KERNEL which should be enough.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied, thanks.
