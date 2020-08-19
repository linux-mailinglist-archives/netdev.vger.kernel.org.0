Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C117C24A9FB
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 01:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgHSXhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 19:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgHSXhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 19:37:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A793C061757;
        Wed, 19 Aug 2020 16:37:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 45B7711D69C3B;
        Wed, 19 Aug 2020 16:20:53 -0700 (PDT)
Date:   Wed, 19 Aug 2020 16:37:38 -0700 (PDT)
Message-Id: <20200819.163738.702703310778769531.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        kuba@kernel.org, mirq-linux@rere.qmqm.pl,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: gemini: Fix missing free_netdev() in error
 path of gemini_ethernet_port_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819023309.31331-1-wanghai38@huawei.com>
References: <20200819023309.31331-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 16:20:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Wed, 19 Aug 2020 10:33:09 +0800

> Replace alloc_etherdev_mq with devm_alloc_etherdev_mqs. In this way,
> when probe fails, netdev can be freed automatically.
> 
> Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
> v1->v2: Make use of devm_alloc_etherdev_mqs() to simplify the code

Applied, thank you.
