Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8FA9C0F7
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfHXXYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:24:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48506 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbfHXXYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 19:24:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 40D0A1525F732;
        Sat, 24 Aug 2019 16:24:22 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:24:21 -0700 (PDT)
Message-Id: <20190824.162421.1494143522595019726.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        lipeng321@huawei.com, tanhuazhong@huawei.com,
        shenjian15@huawei.com, linyunsheng@huawei.com,
        liuzhongzhu@huawei.com, huangguangbin2@huawei.com,
        liweihang@hisilicon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: hns3: Fix -Wunused-const-variable warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190822144937.75884-1-yuehaibing@huawei.com>
References: <20190822144937.75884-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 16:24:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 22 Aug 2019 22:49:37 +0800

> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h:542:30:
>  warning: meta_data_key_info defined but not used [-Wunused-const-variable=]
> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h:553:30:
>  warning: tuple_key_info defined but not used [-Wunused-const-variable=]
> 
> The two variable is only used in hclge_main.c,
> so just move the definition over there.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks.
