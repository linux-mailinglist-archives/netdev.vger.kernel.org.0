Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4775133ADB
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfFCWLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:11:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36120 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfFCWLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:11:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD5D5136E16B0;
        Mon,  3 Jun 2019 15:11:20 -0700 (PDT)
Date:   Mon, 03 Jun 2019 15:11:20 -0700 (PDT)
Message-Id: <20190603.151120.958835957071709710.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     gregkh@linuxfoundation.org, tglx@linutronix.de,
        ariel.elior@marvell.com, michal.kalderon@marvell.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] qed: Fix build error without CONFIG_DEVLINK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190601080605.13052-1-yuehaibing@huawei.com>
References: <20190601080605.13052-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 15:11:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Sat, 1 Jun 2019 16:06:05 +0800

> Fix gcc build error while CONFIG_DEVLINK is not set
> 
> drivers/net/ethernet/qlogic/qed/qed_main.o: In function `qed_remove':
> qed_main.c:(.text+0x1eb4): undefined reference to `devlink_unregister'
> 
> Select DEVLINK to fix this.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 24e04879abdd ("qed: Add qed devlink parameters table")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
