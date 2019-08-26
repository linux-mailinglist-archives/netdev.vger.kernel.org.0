Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 903DA9C764
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 04:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfHZCuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 22:50:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57954 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfHZCuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 22:50:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32A2D14DDE4EB;
        Sun, 25 Aug 2019 19:50:13 -0700 (PDT)
Date:   Sun, 25 Aug 2019 19:50:12 -0700 (PDT)
Message-Id: <20190825.195012.2266154298465148200.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Subject: Re: [PATCH v2 net-next] cirrus: cs89x0: remove set but not used
 variable 'lp'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190826024915.67642-1-yuehaibing@huawei.com>
References: <20190822063517.71231-1-yuehaibing@huawei.com>
        <20190826024915.67642-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 25 Aug 2019 19:50:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Mon, 26 Aug 2019 02:49:15 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/cirrus/cs89x0.c: In function 'cs89x0_platform_probe':
> drivers/net/ethernet/cirrus/cs89x0.c:1847:20: warning:
>  variable 'lp' set but not used [-Wunused-but-set-variable]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 6751edeb8700 ("cirrus: cs89x0: Use managed interfaces")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks.
