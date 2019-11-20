Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4B21031E2
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 04:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfKTDLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 22:11:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49124 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfKTDLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 22:11:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D940F146D3303;
        Tue, 19 Nov 2019 19:11:02 -0800 (PST)
Date:   Tue, 19 Nov 2019 19:11:02 -0800 (PST)
Message-Id: <20191119.191102.582170155760201896.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH V2 net] net: hns3: fix a wrong reset interrupt status
 mask
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1574215635-43836-1-git-send-email-tanhuazhong@huawei.com>
References: <1574215635-43836-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 19:11:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Wed, 20 Nov 2019 10:07:15 +0800

> According to hardware user manual, bits5~7 in register
> HCLGE_MISC_VECTOR_INT_STS means reset interrupts status,
> but HCLGE_RESET_INT_M is defined as bits0~2 now. So it
> will make hclge_reset_err_handle() read the wrong reset
> interrupt status.
> 
> This patch fixes this wrong bit mask.
> 
> Fixes: 2336f19d7892 ("net: hns3: check reset interrupt status when reset fails")
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> ---
> Change log:
> V1->V2: fixes comment from David Miller.

Applied.
