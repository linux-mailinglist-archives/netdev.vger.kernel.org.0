Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC85C3DF9
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732475AbfJARDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:03:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50032 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731999AbfJARDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 13:03:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0B1D8154F05ED;
        Tue,  1 Oct 2019 10:03:42 -0700 (PDT)
Date:   Tue, 01 Oct 2019 10:03:41 -0700 (PDT)
Message-Id: <20191001.100341.1797056721948216269.davem@davemloft.net>
To:     wenyang@linux.alibaba.com
Cc:     linus.walleij@linaro.org, xlpang@linux.alibaba.com,
        zhiche.yy@alibaba-inc.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: rtl8366rb: add missing of_node_put after
 calling of_get_child_by_name
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190929070047.2515-1-wenyang@linux.alibaba.com>
References: <20190929070047.2515-1-wenyang@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 10:03:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>
Date: Sun, 29 Sep 2019 15:00:47 +0800

> of_node_put needs to be called when the device node which is got
> from of_get_child_by_name finished using.
> irq_domain_add_linear() also calls of_node_get() to increase refcount,
> so irq_domain will not be affected when it is released.
> 
> fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>

Please capitalize Fixes:, seriously I am very curious where did you
learned to specify the fixes tag non-capitalized?

Patch applied, t hanks.
