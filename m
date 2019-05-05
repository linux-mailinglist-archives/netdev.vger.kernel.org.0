Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D47651419D
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfEERrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:47:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53204 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfEERrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:47:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4CA4214D3B5AD;
        Sun,  5 May 2019 10:47:34 -0700 (PDT)
Date:   Sun, 05 May 2019 10:47:33 -0700 (PDT)
Message-Id: <20190505.104733.1706247040193919651.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     maxime.chevallier@bootlin.com, antoine.tenart@bootlin.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: mvpp2: cls: Remove set but not used
 variable 'act'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190504040405.13004-1-yuehaibing@huawei.com>
References: <20190504040405.13004-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:47:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Sat, 4 May 2019 04:04:05 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c: In function 'mvpp2_cls_c2_build_match':
> drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c:1159:28: warning:
>  variable 'act' set but not used [-Wunused-but-set-variable]
> 
> It is never used since introduction in
> commit 90b509b39ac9 ("net: mvpp2: cls: Add Classification offload support")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
