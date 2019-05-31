Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED156316CA
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfEaVxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:53:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51174 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfEaVxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 17:53:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DDBA15015EA2;
        Fri, 31 May 2019 14:53:05 -0700 (PDT)
Date:   Fri, 31 May 2019 14:53:04 -0700 (PDT)
Message-Id: <20190531.145304.1211434996278669737.davem@davemloft.net>
To:     xuechaojing@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoshaokai@huawei.com, cloud.wangxiaoyun@huawei.com,
        chiqijun@huawei.com, wulike1@huawei.com
Subject: Re: [net-next v2] hinic: add LRO support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531054730.2995-1-xuechaojing@huawei.com>
References: <20190531054730.2995-1-xuechaojing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 14:53:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xue Chaojing <xuechaojing@huawei.com>
Date: Fri, 31 May 2019 05:47:30 +0000

> +	if ((err) || (out_param)) {

Too many parenthesis, just "if (err || out_param)" is fine.

> @@ -51,6 +51,22 @@ static unsigned int rx_weight = 64;
>  module_param(rx_weight, uint, 0644);
>  MODULE_PARM_DESC(rx_weight, "Number Rx packets for NAPI budget (default=64)");
>  
> +static unsigned int set_lro_timer = 16;
> +module_param(set_lro_timer, uint, 0444);
> +MODULE_PARM_DESC(set_lro_timer, "Set lro timer in micro second, valid range is 1 - 1024, default is 16");

I also said your changes were a non-starter with all of these module
parameters.

I am not looking at this patch until you find a way to remove them.

Thank you.
