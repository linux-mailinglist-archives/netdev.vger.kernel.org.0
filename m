Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3045FF5A2
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 21:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbfKPUxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 15:53:19 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53638 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbfKPUxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 15:53:19 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E8941518AA6D;
        Sat, 16 Nov 2019 12:53:17 -0800 (PST)
Date:   Sat, 16 Nov 2019 12:53:16 -0800 (PST)
Message-Id: <20191116.125316.1859622454319892445.davem@davemloft.net>
To:     wangxiaogang3@huawei.com
Cc:     dsahern@kernel.org, shrijeet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hujunwei4@huawei.com,
        xuhanbing@huawei.com, ap420073@gmail.com
Subject: Re: [PATCH] vrf: Fix possible NULL pointer oops when delete nic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <60e827cb-2bba-2b7e-55dc-651103e9905f@huawei.com>
References: <60e827cb-2bba-2b7e-55dc-651103e9905f@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 12:53:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "wangxiaogang (F)" <wangxiaogang3@huawei.com>
Date: Fri, 15 Nov 2019 14:22:56 +0800

> From: XiaoGang Wang <wangxiaogang3@huawei.com>
> 
> Recently we get a crash when access illegal address (0xc0),
> which will occasionally appear when deleting a physical NIC with vrf.
> 
> [166603.826737]hinic 0000:43:00.4 eth-s3: Failed to cycle device eth-s3;
> route tables might be wrong!
> .....
> [166603.828018]WARNING: CPU: 135 PID: 15382at net/core/dev.c:6875
> __netdev_adjacent_dev_remove.constprop.40+0x1e0/0x1e8
> ......

Taehee-ssi, please take a look at this.

It is believed that this may be caused by the adjacency fixes you made
recently.

Thank you.
