Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2264C16538B
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgBTA0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:26:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49494 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgBTA0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 19:26:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5FD5C15BD7A5A;
        Wed, 19 Feb 2020 16:26:23 -0800 (PST)
Date:   Wed, 19 Feb 2020 16:26:22 -0800 (PST)
Message-Id: <20200219.162622.388743779284465493.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     linux-net-drivers@solarflare.com, ecree@solarflare.com,
        mhabets@solarflare.com, amaftei@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] sfc: remove unused variable
 'efx_default_channel_type'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200219013458.47620-1-yuehaibing@huawei.com>
References: <20200211141606.47180-1-yuehaibing@huawei.com>
        <20200219013458.47620-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 16:26:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 19 Feb 2020 09:34:58 +0800

> drivers/net/ethernet/sfc/efx.c:116:38: warning:
>  efx_default_channel_type defined but not used [-Wunused-const-variable=]
> 
> commit 83975485077d ("sfc: move channel alloc/removal code")
> left behind this, remove it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 83975485077d ("sfc: move channel alloc/removal code")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: Add Fixes tag

Applied, thanks.
