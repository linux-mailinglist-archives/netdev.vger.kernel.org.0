Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C51E187545
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 23:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732754AbgCPWBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 18:01:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48476 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732709AbgCPWBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 18:01:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F6F8156D3FD2;
        Mon, 16 Mar 2020 15:01:37 -0700 (PDT)
Date:   Mon, 16 Mar 2020 15:01:36 -0700 (PDT)
Message-Id: <20200316.150136.1540930644264923.davem@davemloft.net>
To:     zhengzengkai@huawei.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] qede: remove some unused code in function
 qede_selftest_receive_traffic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200316130524.140421-1-zhengzengkai@huawei.com>
References: <20200316130524.140421-1-zhengzengkai@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 15:01:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Zengkai <zhengzengkai@huawei.com>
Date: Mon, 16 Mar 2020 21:05:24 +0800

> Remove set but not used variables 'sw_comp_cons' and 'hw_comp_cons'
> to fix gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/qlogic/qede/qede_ethtool.c: In function qede_selftest_receive_traffic:
> drivers/net/ethernet/qlogic/qede/qede_ethtool.c:1569:20:
>  warning: variable sw_comp_cons set but not used [-Wunused-but-set-variable]
> drivers/net/ethernet/qlogic/qede/qede_ethtool.c: In function qede_selftest_receive_traffic:
> drivers/net/ethernet/qlogic/qede/qede_ethtool.c:1569:6:
>  warning: variable hw_comp_cons set but not used [-Wunused-but-set-variable]
> 
> After removing 'hw_comp_cons',the memory barrier 'rmb()' and its comments become useless,
> so remove them as well.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>

Applied, thank you.
