Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24BA1137C02
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 08:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgAKHP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 02:15:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44224 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728501AbgAKHP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 02:15:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02D191599DBB0;
        Fri, 10 Jan 2020 23:15:55 -0800 (PST)
Date:   Fri, 10 Jan 2020 23:15:55 -0800 (PST)
Message-Id: <20200110.231555.1390807442365734004.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     amaftei@solarflare.com, ecree@solarflare.com,
        mhabets@solarflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Subject: Re: [PATCH net-next] sfc: remove set but not used variable
 'nic_data'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200110060908.124241-1-yuehaibing@huawei.com>
References: <20200110060908.124241-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 23:15:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 10 Jan 2020 06:09:08 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/sfc/mcdi_functions.c: In function 'efx_mcdi_ev_init':
> drivers/net/ethernet/sfc/mcdi_functions.c:79:28: warning:
>  variable 'nic_data' set but not used [-Wunused-but-set-variable]
> 
> commit 4438b587fe4b ("sfc: move MCDI event queue management code")
> introduces this unused variable.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
