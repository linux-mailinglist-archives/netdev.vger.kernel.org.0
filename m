Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64BCC193037
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgCYSUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:20:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46116 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727547AbgCYSUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 14:20:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B9F0E159FFC28;
        Wed, 25 Mar 2020 11:20:08 -0700 (PDT)
Date:   Wed, 25 Mar 2020 11:20:05 -0700 (PDT)
Message-Id: <20200325.112005.1488571669011858526.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     vishal@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rahul.lakkireddy@chelsio.com
Subject: Re: [PATCH v2 net-next] cxgb4: remove set but not used variable
 'tab'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325011750.53008-1-yuehaibing@huawei.com>
References: <20200324062614.29644-1-yuehaibing@huawei.com>
        <20200325011750.53008-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Mar 2020 11:20:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 25 Mar 2020 09:17:50 +0800

> drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c: In function cxgb4_get_free_ftid:
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c:547:23:
>  warning: variable tab set but not used [-Wunused-but-set-variable]
> 
> commit 8d174351f285 ("cxgb4: rework TC filter rule insertion across regions")
> involved this, remove it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: keep christmas tree ordering

Applied, thank you.
