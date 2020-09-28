Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4507F27B7BE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgI1XPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgI1XNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBF1C0610D1;
        Mon, 28 Sep 2020 15:57:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4F5CC12747808;
        Mon, 28 Sep 2020 15:40:20 -0700 (PDT)
Date:   Mon, 28 Sep 2020 15:56:03 -0700 (PDT)
Message-Id: <20200928.155603.134441435973191115.davem@davemloft.net>
To:     manivannan.sadhasivam@linaro.org
Cc:     kuba@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sboyd@kernel.org
Subject: Re: [PATCH] net: qrtr: ns: Protect radix_tree_deref_slot() using
 rcu read locks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200926165625.11660-1-manivannan.sadhasivam@linaro.org>
References: <20200926165625.11660-1-manivannan.sadhasivam@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 15:40:20 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date: Sat, 26 Sep 2020 22:26:25 +0530

> The rcu read locks are needed to avoid potential race condition while
> dereferencing radix tree from multiple threads. The issue was identified
> by syzbot. Below is the crash report:
 ...
> Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> Reported-and-tested-by: syzbot+0f84f6eed90503da72fc@syzkaller.appspotmail.com
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Applied and queued up for -stable, thank you.
