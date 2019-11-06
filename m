Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D981F0BDD
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387479AbfKFCCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:02:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41976 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730571AbfKFCCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:02:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A85715102F8E;
        Tue,  5 Nov 2019 18:02:01 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:02:00 -0800 (PST)
Message-Id: <20191105.180200.375431647174027237.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        tanhuazhong@huawei.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hns3: remove unused macros
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191103131538.25234-1-colin.king@canonical.com>
References: <20191103131538.25234-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:02:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Sun,  3 Nov 2019 13:15:38 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> The macros HCLGE_MPF_ENBALE and HCLGEVF_MPF_ENBALE are defined but never
> used.  I was going to fix the spelling mistake "ENBALE" -> "ENABLE" but
> found these macros are not used, so they can be removed.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next.
