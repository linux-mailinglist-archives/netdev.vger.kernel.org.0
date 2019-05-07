Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B480216B92
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 21:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfEGTmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 15:42:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33574 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGTmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 15:42:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9090114B8C968;
        Tue,  7 May 2019 12:42:14 -0700 (PDT)
Date:   Tue, 07 May 2019 12:42:14 -0700 (PDT)
Message-Id: <20190507.124214.2082306667746233276.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     vishal@chelsio.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] cxgb4: Fix error path in cxgb4_init_module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190506155754.42464-1-yuehaibing@huawei.com>
References: <20190506155754.42464-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 12:42:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Mon, 6 May 2019 23:57:54 +0800

> BUG: unable to handle kernel paging request at ffffffffa016a270
 ...
> If pci_register_driver fails, register inet6addr_notifier is
> pointless. This patch fix the error path in cxgb4_init_module.
> 
> Fixes: b5a02f503caa ("cxgb4 : Update ipv6 address handling api")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks.
