Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E698740B2
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387903AbfGXVMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:12:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51964 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfGXVM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:12:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1BF0B1543A188;
        Wed, 24 Jul 2019 14:12:29 -0700 (PDT)
Date:   Wed, 24 Jul 2019 14:12:28 -0700 (PDT)
Message-Id: <20190724.141228.454330962921320879.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, bpoirier@suse.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] qlge: Fix build error without CONFIG_ETHERNET
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724.141202.10100086363454182.davem@davemloft.net>
References: <20190724130126.53532-1-yuehaibing@huawei.com>
        <20190724.141202.10100086363454182.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 14:12:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 24 Jul 2019 14:12:02 -0700 (PDT)

> From: YueHaibing <yuehaibing@huawei.com>
> Date: Wed, 24 Jul 2019 21:01:26 +0800
> 
>> Now if CONFIG_ETHERNET is not set, QLGE driver
>> building fails:
>> 
>> drivers/staging/qlge/qlge_main.o: In function `qlge_remove':
>> drivers/staging/qlge/qlge_main.c:4831: undefined reference to `unregister_netdev'
>> 
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Fixes: 955315b0dc8c ("qlge: Move drivers/net/ethernet/qlogic/qlge/ to drivers/staging/qlge/")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> I'll let Greg take this.

Actually, I take that back.

Since the move to staging happened in my tree I will take this ;-)
