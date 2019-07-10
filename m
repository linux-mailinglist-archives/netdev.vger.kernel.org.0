Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2743461952
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 04:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfGHCfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 22:35:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45464 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbfGHCfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 22:35:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1307F1528C8DD;
        Sun,  7 Jul 2019 19:35:05 -0700 (PDT)
Date:   Sun, 07 Jul 2019 19:35:04 -0700 (PDT)
Message-Id: <20190707.193504.258563830031901437.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     csully@google.com, sagis@google.com, jonolson@google.com,
        colin.king@canonical.com, willemb@google.com, lrizzo@google.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] gve: Fix error return code in gve_alloc_qpls()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190705011642.156707-1-weiyongjun1@huawei.com>
References: <20190705011642.156707-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jul 2019 19:35:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Fri, 5 Jul 2019 01:16:42 +0000

> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied, thank you.
