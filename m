Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3AA2244A6
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgGQTxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgGQTxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:53:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8740C0619D2;
        Fri, 17 Jul 2020 12:53:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E9D4011E45929;
        Fri, 17 Jul 2020 12:53:14 -0700 (PDT)
Date:   Fri, 17 Jul 2020 12:53:14 -0700 (PDT)
Message-Id: <20200717.125314.601518083747025983.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     kuba@kernel.org, hkallweit1@gmail.com, jgg@ziepe.ca,
        chao@kernel.org, wu000273@umn.edu, weiyongjun1@huawei.com,
        yuehaibing@huawei.com, vaibhavgupta40@gmail.com,
        jonathan.lemon@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: sun: cassini: switch from 'pci_' to 'dma_' API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200716190358.318180-1-christophe.jaillet@wanadoo.fr>
References: <20200716190358.318180-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 12:53:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Thu, 16 Jul 2020 21:03:58 +0200

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'cas_tx_tiny_alloc()', GFP_KERNEL can be used
> because a few lines below in its only caller, 'cas_alloc_rxds()', is also
> called. This function makes an explicit use of GFP_KERNEL.
> 
> When memory is allocated in 'cas_init_one()', GFP_KERNEL can be used
> because it is a probe function and no lock is acquired.
 ...
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied, thank you.
