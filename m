Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3FB33B8E2
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391413AbfFJQEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:04:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57632 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389498AbfFJQEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:04:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 47B24150503E5;
        Mon, 10 Jun 2019 09:04:05 -0700 (PDT)
Date:   Mon, 10 Jun 2019 09:04:02 -0700 (PDT)
Message-Id: <20190610.090402.1076127429444175164.davem@davemloft.net>
To:     xuechaojing@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoshaokai@huawei.com, cloud.wangxiaoyun@huawei.com,
        chiqijun@huawei.com, wulike1@huawei.com
Subject: Re: [PATCH net-next 1/2] hinic: add rss support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190610033455.9405-1-xuechaojing@huawei.com>
References: <20190610033455.9405-1-xuechaojing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Jun 2019 09:04:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xue Chaojing <xuechaojing@huawei.com>
Date: Mon, 10 Jun 2019 03:34:54 +0000

> This patch adds rss support for the HINIC driver.
> 
> Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>
> ---
>  drivers/net/ethernet/huawei/hinic/hinic_dev.h |  26 ++
>  .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  10 +-
>  .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  26 ++
>  .../net/ethernet/huawei/hinic/hinic_hw_wqe.h  |  16 ++
>  .../net/ethernet/huawei/hinic/hinic_main.c    | 131 ++++++++-
>  .../net/ethernet/huawei/hinic/hinic_port.c    | 253 ++++++++++++++++++
>  .../net/ethernet/huawei/hinic/hinic_port.h    |  82 ++++++
>  7 files changed, 536 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
> index 5186cc9023aa..8065180344d2 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
> @@ -31,6 +31,7 @@
>  enum hinic_flags {
>  	HINIC_LINK_UP = BIT(0),
>  	HINIC_INTF_UP = BIT(1),
> +	HINIC_RSS_ENABLE = BIT(3),
>  };

Why not "BIT(2)"?

Also, please always provide an appropriate cover letter for a patch series.
