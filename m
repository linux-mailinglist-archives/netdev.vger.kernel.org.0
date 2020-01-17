Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD7C1407E7
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 11:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgAQK2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 05:28:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48904 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgAQK2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 05:28:22 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 771A2155CB083;
        Fri, 17 Jan 2020 02:28:19 -0800 (PST)
Date:   Fri, 17 Jan 2020 02:28:17 -0800 (PST)
Message-Id: <20200117.022817.1170708716212895346.davem@davemloft.net>
To:     yaohongbo@huawei.com
Cc:     kuba@kernel.org, chenzhou10@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -next] drivers/net: netdevsim depends on INET
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116131404.169423-1-yaohongbo@huawei.com>
References: <20200116131404.169423-1-yaohongbo@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jan 2020 02:28:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hongbo Yao <yaohongbo@huawei.com>
Date: Thu, 16 Jan 2020 21:14:04 +0800

> If CONFIG_INET is not set and CONFIG_NETDEVSIM=y.
> Building drivers/net/netdevsim/fib.o will get the following error:
> 
> drivers/net/netdevsim/fib.o: In function `nsim_fib4_rt_hw_flags_set':
> fib.c:(.text+0x12b): undefined reference to `fib_alias_hw_flags_set'
> drivers/net/netdevsim/fib.o: In function `nsim_fib4_rt_destroy':
> fib.c:(.text+0xb11): undefined reference to `free_fib_info'
> 
> Correct the Kconfig for netdevsim.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 48bb9eb47b270 ("netdevsim: fib: Add dummy implementation for FIB offload")
> Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>

Applied, thanks.
