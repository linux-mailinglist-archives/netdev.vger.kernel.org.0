Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12514F26DC
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfKGFWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:22:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33754 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfKGFWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:22:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 89F8015110062;
        Wed,  6 Nov 2019 21:22:22 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:22:22 -0800 (PST)
Message-Id: <20191106.212222.483687585896701702.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     epomozov@marvell.com, igor.russkikh@aquantia.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: aquantia: fix return value check in
 aq_ptp_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191106145921.124814-1-weiyongjun1@huawei.com>
References: <20191106145921.124814-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:22:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Wed, 6 Nov 2019 14:59:21 +0000

> Function ptp_clock_register() returns ERR_PTR() and never returns
> NULL. The NULL test should be removed.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied.
