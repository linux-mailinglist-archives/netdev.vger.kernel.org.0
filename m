Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B69F2710A3
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 23:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgISVYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 17:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgISVYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 17:24:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DF5C0613CE
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 14:24:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 965C311E3E4D0;
        Sat, 19 Sep 2020 14:08:02 -0700 (PDT)
Date:   Sat, 19 Sep 2020 14:24:49 -0700 (PDT)
Message-Id: <20200919.142449.1056924026182449502.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        kuba@kernel.org, ybason@marvell.com, alobakin@pm.me,
        netdev@vger.kernel.org, hulkci@huawei.com
Subject: Re: [PATCH net-next] net: qed: use true,false for bool variables
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200919074543.3460008-1-yanaijie@huawei.com>
References: <20200919074543.3460008-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 19 Sep 2020 14:08:02 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Sat, 19 Sep 2020 15:45:43 +0800

> This addresses the following coccinelle warning:
> 
> drivers/net/ethernet/qlogic/qed/qed_rdma.c:1465:2-13: WARNING:
> Assignment of 0/1 to bool variable
> drivers/net/ethernet/qlogic/qed/qed_rdma.c:1468:2-14: WARNING:
> Assignment of 0/1 to bool variable
> drivers/net/ethernet/qlogic/qed/qed_rdma.c:1471:2-13: WARNING:
> Assignment of 0/1 to bool variable
> drivers/net/ethernet/qlogic/qed/qed_rdma.c:1472:2-14: WARNING:
> Assignment of 0/1 to bool variable
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied.
