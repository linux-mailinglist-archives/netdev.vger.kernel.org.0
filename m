Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB038919B7
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 23:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfHRVWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 17:22:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49428 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfHRVWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 17:22:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9CE37145F5251;
        Sun, 18 Aug 2019 14:22:22 -0700 (PDT)
Date:   Sun, 18 Aug 2019 14:22:22 -0700 (PDT)
Message-Id: <20190818.142222.460294403900992585.davem@davemloft.net>
To:     liuyonglong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, shiju.jose@huawei.com
Subject: Re: [PATCH net-next] net: hns: add phy_attached_info() to the hns
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566008477-16554-1-git-send-email-liuyonglong@huawei.com>
References: <1566008477-16554-1-git-send-email-liuyonglong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 Aug 2019 14:22:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>
Date: Sat, 17 Aug 2019 10:21:17 +0800

> This patch adds the call to phy_attached_info() to the hns driver
> to identify which exact PHY drivers is in use.
> 
> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>

Applied.
