Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83F221003C
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgF3Wxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgF3Wxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 18:53:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9862C061755;
        Tue, 30 Jun 2020 15:53:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EEF29127BE1BD;
        Tue, 30 Jun 2020 15:53:45 -0700 (PDT)
Date:   Tue, 30 Jun 2020 15:53:45 -0700 (PDT)
Message-Id: <20200630.155345.921284251457806411.davem@davemloft.net>
To:     liheng40@huawei.com
Cc:     vishal@chelsio.com, kuba@kernel.org, hariprasad@chelsio.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: cxgb4: fix return error value in t4_prep_fw
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1593427791-41194-1-git-send-email-liheng40@huawei.com>
References: <1593427791-41194-1-git-send-email-liheng40@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 15:53:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li Heng <liheng40@huawei.com>
Date: Mon, 29 Jun 2020 18:49:51 +0800

> t4_prep_fw goto bye tag with positive return value when something
> bad happened and which can not free resource in adap_init0.
> so fix it to return negative value.
> 
> Fixes: 16e47624e76b ("cxgb4: Add new scheme to update T4/T5 firmware")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Li Heng <liheng40@huawei.com>

Applied, thank you.
