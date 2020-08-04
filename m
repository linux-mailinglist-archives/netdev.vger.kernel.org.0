Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5823123B213
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgHDBCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHDBCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:02:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6757FC06174A;
        Mon,  3 Aug 2020 18:02:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D8631278924B;
        Mon,  3 Aug 2020 17:45:24 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:02:09 -0700 (PDT)
Message-Id: <20200803.180209.1154392405675800375.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     kuba@kernel.org, brianvv@google.com, rdunlap@infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] fib: Fix undef compile warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200803131948.41736-1-yuehaibing@huawei.com>
References: <20200803131948.41736-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 17:45:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Mon, 3 Aug 2020 21:19:48 +0800

> net/core/fib_rules.c:26:7: warning: "CONFIG_IP_MULTIPLE_TABLES" is not defined, evaluates to 0 [-Wundef]
>  #elif CONFIG_IP_MULTIPLE_TABLES
>        ^~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fixes: 8b66a6fd34f5 ("fib: fix another fib_rules_ops indirect call wrapper problem")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thank for fixing this up.
