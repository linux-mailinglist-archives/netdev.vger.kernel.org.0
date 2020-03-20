Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9289818C632
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgCTEAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:00:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46598 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgCTEAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:00:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E2440158F78E4;
        Thu, 19 Mar 2020 21:00:29 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:00:26 -0700 (PDT)
Message-Id: <20200319.210026.1097328564068541611.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     dchickles@marvell.com, leonro@mellanox.com, sburla@marvell.com,
        fmanlunas@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Subject: Re: [PATCH net-next] liquidio: remove set but not used variable 's'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319120743.28056-1-yuehaibing@huawei.com>
References: <20200306023254.61731-1-yuehaibing@huawei.com>
        <20200319120743.28056-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 21:00:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 19 Mar 2020 12:07:43 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/cavium/liquidio/lio_main.c: In function 'octeon_chip_specific_setup':
> drivers/net/ethernet/cavium/liquidio/lio_main.c:1378:8: warning:
>  variable 's' set but not used [-Wunused-but-set-variable]
> 
> It's not used since commit b6334be64d6f ("net/liquidio: Delete driver version assignment")
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
