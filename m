Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4384FDA7
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 20:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfFWSd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 14:33:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43560 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfFWSd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 14:33:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6867D12D8C0E6;
        Sun, 23 Jun 2019 11:33:55 -0700 (PDT)
Date:   Sun, 23 Jun 2019 11:33:54 -0700 (PDT)
Message-Id: <20190623.113354.132846566012344300.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/sched: cbs: Fix error path of cbs_module_init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190621134437.4252-1-yuehaibing@huawei.com>
References: <20190621134437.4252-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Jun 2019 11:33:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 21 Jun 2019 21:44:37 +0800

> If register_qdisc fails, we should unregister
> netdevice notifier.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: e0a7683d30e9 ("net/sched: cbs: fix port_rate miscalculation")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
