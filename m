Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF7E9C064
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 23:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbfHXVWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 17:22:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47738 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbfHXVWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 17:22:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2940215252E0A;
        Sat, 24 Aug 2019 14:22:32 -0700 (PDT)
Date:   Sat, 24 Aug 2019 14:22:31 -0700 (PDT)
Message-Id: <20190824.142231.372281128687703445.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Subject: Re: [PATCH net-next] cirrus: cs89x0: remove set but not used
 variable 'lp'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190822063517.71231-1-yuehaibing@huawei.com>
References: <20190822063517.71231-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 14:22:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 22 Aug 2019 06:35:17 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/cirrus/cs89x0.c: In function 'cs89x0_platform_probe':
> drivers/net/ethernet/cirrus/cs89x0.c:1847:20: warning:
>  variable 'lp' set but not used [-Wunused-but-set-variable]
> 
> It is not used since commit 6751edeb8700 ("cirrus: cs89x0: Use
> managed interfaces")

Please use a proper Fixes: tag.
