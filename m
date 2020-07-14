Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E654522007D
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 00:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgGNWN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 18:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbgGNWNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 18:13:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8274C061755;
        Tue, 14 Jul 2020 15:13:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 921AE15E54D20;
        Tue, 14 Jul 2020 15:13:24 -0700 (PDT)
Date:   Tue, 14 Jul 2020 15:13:23 -0700 (PDT)
Message-Id: <20200714.151323.2054538067730186094.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     sumit.semwal@linaro.org, kuba@kernel.org, christian.koenig@amd.com,
        mhabets@solarflare.com, jwi@linux.ibm.com, zhongjiang@huawei.com,
        weiyongjun1@huawei.com, vaibhavgupta40@gmail.com,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksz884x: switch from 'pci_' to 'dma_' API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200714183501.310949-1-christophe.jaillet@wanadoo.fr>
References: <20200714183501.310949-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 15:13:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Tue, 14 Jul 2020 20:35:01 +0200

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'ksz_alloc_desc()', GFP_KERNEL can be used
> because a few lines below, GFP_KERNEL is also used in the
> 'ksz_alloc_soft_desc()' calls.
 ...
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied, thank you.
