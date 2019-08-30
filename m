Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11571A3F8A
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfH3VPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:15:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42046 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbfH3VPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:15:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 531DA154FE294;
        Fri, 30 Aug 2019 14:15:51 -0700 (PDT)
Date:   Fri, 30 Aug 2019 14:15:50 -0700 (PDT)
Message-Id: <20190830.141550.302970621444143276.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     thomas.lendacky@amd.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd-xgbe: Fix error path in xgbe_mod_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190829024600.16052-1-yuehaibing@huawei.com>
References: <20190829024600.16052-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 14:15:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 29 Aug 2019 10:46:00 +0800

> In xgbe_mod_init(), we should do cleanup if some error occurs
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: efbaa828330a ("amd-xgbe: Add support to handle device renaming")
> Fixes: 47f164deab22 ("amd-xgbe: Add PCI device support")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
