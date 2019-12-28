Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86C6C12BBF2
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 01:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfL1Acy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 19:32:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53746 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfL1Acx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 19:32:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A9AD154D1154;
        Fri, 27 Dec 2019 16:32:53 -0800 (PST)
Date:   Fri, 27 Dec 2019 16:32:52 -0800 (PST)
Message-Id: <20191227.163252.604875420289998673.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     sameehj@amazon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ena: remove set but not used variable
 'rx_ring'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191224125128.36680-1-yuehaibing@huawei.com>
References: <20191224125128.36680-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Dec 2019 16:32:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 24 Dec 2019 20:51:28 +0800

> drivers/net/ethernet/amazon/ena/ena_netdev.c: In function ena_xdp_xmit_buff:
> drivers/net/ethernet/amazon/ena/ena_netdev.c:316:19: warning:
>  variable rx_ring set but not used [-Wunused-but-set-variable]
> 
> commit 548c4940b9f1 ("net: ena: Implement XDP_TX action")
> left behind this unused variable.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks.
