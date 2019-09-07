Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF7DEAC773
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 18:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394786AbfIGQBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 12:01:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46528 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388922AbfIGQBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 12:01:40 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1DC7B13EB2C91;
        Sat,  7 Sep 2019 09:01:38 -0700 (PDT)
Date:   Sat, 07 Sep 2019 18:01:37 +0200 (CEST)
Message-Id: <20190907.180137.1412353242412904149.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     snelson@pensando.io, drivers@pensando.io, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] ionic: Remove unused including
 <linux/version.h>
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190906095410.107596-1-yuehaibing@huawei.com>
References: <20190906095410.107596-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 09:01:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 6 Sep 2019 09:54:09 +0000

> Remove including <linux/version.h> that don't need it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
