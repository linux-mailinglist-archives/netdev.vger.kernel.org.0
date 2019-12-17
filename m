Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09BD121F50
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfLQAMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:12:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57606 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfLQAMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:12:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6AE771556D676;
        Mon, 16 Dec 2019 16:12:41 -0800 (PST)
Date:   Mon, 16 Dec 2019 16:12:40 -0800 (PST)
Message-Id: <20191216.161240.604174661311569521.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 0/5] net: hns3: some optimizaions related to
 work task
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576289201-57017-1-git-send-email-tanhuazhong@huawei.com>
References: <1576289201-57017-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 16:12:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Sat, 14 Dec 2019 10:06:36 +0800

> This series refactors the work task of the HNS3 ethernet driver.
> 
> [patch 1/5] uses delayed workqueue to replace the timer for
> hclgevf_service task, make the code simpler.
> 
> [patch 2/5] & [patch 3/5] unifies current mailbox, reset and
> service work into one.
> 
> [patch 4/5] allocates a private work queue with WQ_MEM_RECLAIM
> for the HNS3 driver.
> 
> [patch 5/5] adds a new flag to indicate whether reset fails,
> and prevent scheduling service task to handle periodic task
> when this flag has been set.

Series applied, thank you.
