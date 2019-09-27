Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393C6C008F
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfI0ICO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:02:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56992 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfI0ICO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 04:02:14 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 50C7014DD7FE5;
        Fri, 27 Sep 2019 01:02:12 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:02:10 +0200 (CEST)
Message-Id: <20190927.100210.239358779936843638.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     yisen.zhuang@huawei.com, zhangfei.gao@linaro.org,
        salil.mehta@huawei.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: hisilicon: Fix signedness bug in
 hix5hd2_dev_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925105532.GC3264@mwanda>
References: <20190925105532.GC3264@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 01:02:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 25 Sep 2019 13:55:32 +0300

> The "priv->phy_mode" variable is an enum and in this context GCC will
> treat it as unsigned to the error handling will never trigger.
> 
> Fixes: 57c5bc9ad7d7 ("net: hisilicon: add hix5hd2 mac driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
