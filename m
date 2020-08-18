Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96475248F17
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgHRTyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgHRTyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:54:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E76EC061389;
        Tue, 18 Aug 2020 12:54:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5F74B127A25D7;
        Tue, 18 Aug 2020 12:37:16 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:54:01 -0700 (PDT)
Message-Id: <20200818.125401.958204660420531471.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        kuba@kernel.org, mirq-linux@rere.qmqm.pl,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: gemini: Fix missing free_netdev() in error
 path of gemini_ethernet_port_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818134404.63828-1-wanghai38@huawei.com>
References: <20200818134404.63828-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 12:37:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Tue, 18 Aug 2020 21:44:04 +0800

> Fix the missing free_netdev() before return from
> gemini_ethernet_port_probe() in the error handling case.
> 
> Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

You can just convert this function to use 'devm_alloc_etherdev_mqs', which
is a one line fix.
