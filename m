Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01C1C143B58
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 11:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgAUKql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 05:46:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36174 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728831AbgAUKql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 05:46:41 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5226715C0CFC6;
        Tue, 21 Jan 2020 02:46:39 -0800 (PST)
Date:   Tue, 21 Jan 2020 11:46:37 +0100 (CET)
Message-Id: <20200121.114637.1232865870207165672.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH net-next 0/9] net: hns3: misc updates for -net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
References: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 02:46:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Tue, 21 Jan 2020 16:42:04 +0800

> This series includes some misc updates for the HNS3 ethernet driver.
> 
> [patch 1] adds a limitation for the error log in the
> hns3_clean_tx_ring().
> [patch 2] adds a check for pfmemalloc flag before reusing pages
> since these pages may be used some special case.
> [patch 3] assigns a default reset type 'HNAE3_NONE_RESET' to
> VF's reset_type after initializing or reset.
> [patch 4] unifies macro HCLGE_DFX_REG_TYPE_CNT's definition into
> header file.
> [patch 5] refines the parameter 'size' of snprintf() in the
> hns3_init_module().
> [patch 6] rewrites a debug message in hclge_put_vector().
> [patch 7~9] adds some cleanups related to coding style.

Series applied, thanks.
