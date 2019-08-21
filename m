Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA33A985C9
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbfHUUmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:42:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfHUUmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 16:42:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6DCC314D04887;
        Wed, 21 Aug 2019 13:42:37 -0700 (PDT)
Date:   Wed, 21 Aug 2019 13:42:37 -0700 (PDT)
Message-Id: <20190821.134237.1144802507635095173.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     grygorii.strashko@ti.com, ivan.khoronzhuk@linaro.org,
        andrew@lunn.ch, ynezz@true.cz, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethernet: ti: use
 devm_platform_ioremap_resource() to simplify code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190821124850.9592-1-yuehaibing@huawei.com>
References: <20190821124850.9592-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 13:42:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 21 Aug 2019 20:48:50 +0800

> Use devm_platform_ioremap_resource() to simplify the code a bit.
> This is detected by coccinelle.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
