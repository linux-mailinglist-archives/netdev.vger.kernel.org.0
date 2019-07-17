Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870EA6C145
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 21:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfGQTC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 15:02:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40878 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfGQTC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 15:02:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 40AD0147440D9;
        Wed, 17 Jul 2019 12:02:58 -0700 (PDT)
Date:   Wed, 17 Jul 2019 12:02:57 -0700 (PDT)
Message-Id: <20190717.120257.1677787264154994587.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/sched: Make NET_ACT_CT depends on NF_NAT
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190716071602.27276-1-yuehaibing@huawei.com>
References: <20190716071602.27276-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jul 2019 12:02:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 16 Jul 2019 15:16:02 +0800

> If NF_NAT is m and NET_ACT_CT is y, build fails:
> 
> net/sched/act_ct.o: In function `tcf_ct_act':
> act_ct.c:(.text+0x21ac): undefined reference to `nf_ct_nat_ext_add'
> act_ct.c:(.text+0x229a): undefined reference to `nf_nat_icmp_reply_translation'
> act_ct.c:(.text+0x233a): undefined reference to `nf_nat_setup_info'
> act_ct.c:(.text+0x234a): undefined reference to `nf_nat_alloc_null_binding'
> act_ct.c:(.text+0x237c): undefined reference to `nf_nat_packet'
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
