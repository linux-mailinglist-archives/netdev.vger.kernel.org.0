Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9745EA9F3B
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732215AbfIEKGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:06:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44062 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfIEKGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 06:06:23 -0400
Received: from localhost (unknown [89.248.140.11])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 25BE61538755E;
        Thu,  5 Sep 2019 03:06:21 -0700 (PDT)
Date:   Thu, 05 Sep 2019 12:06:20 +0200 (CEST)
Message-Id: <20190905.120620.474534663543605977.davem@davemloft.net>
To:     zhongjiang@huawei.com
Cc:     anna.schumaker@netapp.com, trond.myklebust@hammerspace.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] net: Use kzfree() directly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567564752-6430-1-git-send-email-zhongjiang@huawei.com>
References: <1567564752-6430-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 03:06:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>
Date: Wed, 4 Sep 2019 10:39:09 +0800

> With the help of Coccinelle. We find some place to replace.
> 
> @@
> expression M, S;
> @@
> 
> - memset(M, 0, S);
> - kfree(M);
> + kzfree(M); 

Series applied to net-next.
