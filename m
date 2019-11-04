Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30563ED7F7
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 04:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbfKDDKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 22:10:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41058 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbfKDDKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 22:10:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F7821503943A;
        Sun,  3 Nov 2019 19:10:44 -0800 (PST)
Date:   Sun, 03 Nov 2019 19:10:43 -0800 (PST)
Message-Id: <20191103.191043.59980452666663836.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     isdn@linux-pingi.de, swinslow@gmail.com, tglx@linutronix.de,
        sergey.senozhatsky@gmail.com, wangkefeng.wang@huawei.com,
        elfring@users.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mISDN: remove unused variable 'faxmodulation_s'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101134447.30280-1-yuehaibing@huawei.com>
References: <20191101134447.30280-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 03 Nov 2019 19:10:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 1 Nov 2019 21:44:47 +0800

> drivers/isdn/hardware/mISDN/mISDNisar.c:30:17:
>  warning: faxmodulation_s defined but not used [-Wunused-const-variable=]
> 
> It is never used, so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
