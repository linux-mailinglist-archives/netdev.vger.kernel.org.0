Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD90162090
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 06:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgBRFxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 00:53:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58512 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgBRFxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 00:53:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2225115B47886;
        Mon, 17 Feb 2020 21:53:09 -0800 (PST)
Date:   Mon, 17 Feb 2020 21:53:08 -0800 (PST)
Message-Id: <20200217.215308.783108603461354408.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        saeedb@amazon.com, zorik@amazon.com, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, sameehj@amazon.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ena: remove set but not used variable
 'rx_ring'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200218015951.7224-1-yuehaibing@huawei.com>
References: <20200218015951.7224-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 21:53:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 18 Feb 2020 09:59:51 +0800

> drivers/net/ethernet/amazon/ena/ena_netdev.c: In function ena_xdp_xmit_buff:
> drivers/net/ethernet/amazon/ena/ena_netdev.c:316:19: warning:
>  variable rx_ring set but not used [-Wunused-but-set-variable]
> 
> commit 548c4940b9f1 ("net: ena: Implement XDP_TX action")
> left behind this unused variable.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

This does not apply cleanly to net-next, please respin.
