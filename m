Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393C015171A
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 09:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgBDId6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 03:33:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40984 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgBDId5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 03:33:57 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB144155604AB;
        Tue,  4 Feb 2020 00:33:55 -0800 (PST)
Date:   Tue, 04 Feb 2020 09:33:54 +0100 (CET)
Message-Id: <20200204.093354.137606525383512342.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     aelior@marvell.com, michal.kalderon@marvell.com,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Subject: Re: [PATCH net-next] qed: Remove set but not used variable 'p_link'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200204022442.109809-1-yuehaibing@huawei.com>
References: <20200204022442.109809-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Feb 2020 00:33:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 4 Feb 2020 02:24:41 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/qlogic/qed/qed_cxt.c: In function 'qed_qm_init_pf':
> drivers/net/ethernet/qlogic/qed/qed_cxt.c:1401:29: warning:
>  variable 'p_link' set but not used [-Wunused-but-set-variable]
> 
> commit 92fae6fb231f ("qed: FW 8.42.2.0 Queue Manager changes")
> leave behind this unused variable.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thank you.
