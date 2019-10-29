Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9311E93D1
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfJ2XoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:44:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33046 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfJ2XoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 19:44:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B34CB14EBE2F5;
        Tue, 29 Oct 2019 16:44:18 -0700 (PDT)
Date:   Tue, 29 Oct 2019 16:44:18 -0700 (PDT)
Message-Id: <20191029.164418.1957595418522916270.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     snelson@pensando.io, drivers@pensando.io, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] ionic: Remove set but not used variable
 'sg_desc'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191028120121.20743-1-yuehaibing@huawei.com>
References: <20191028120121.20743-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 16:44:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Mon, 28 Oct 2019 12:01:21 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/pensando/ionic/ionic_txrx.c: In function 'ionic_rx_empty':
> drivers/net/ethernet/pensando/ionic/ionic_txrx.c:405:28: warning:
>  variable 'sg_desc' set but not used [-Wunused-but-set-variable]
> 
> It is never used, so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks.
