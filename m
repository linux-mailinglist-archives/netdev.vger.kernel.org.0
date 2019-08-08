Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6672D868DE
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 20:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733248AbfHHSiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 14:38:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49586 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfHHSiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 14:38:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F1AE154FA021;
        Thu,  8 Aug 2019 11:38:13 -0700 (PDT)
Date:   Thu, 08 Aug 2019 11:38:13 -0700 (PDT)
Message-Id: <20190808.113813.478689798535715440.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vinicius.gomes@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] taprio: remove unused variable
 'entry_list_policy'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190808142623.69188-1-yuehaibing@huawei.com>
References: <20190808142623.69188-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 11:38:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 8 Aug 2019 22:26:23 +0800

> net/sched/sch_taprio.c:680:32: warning:
>  entry_list_policy defined but not used [-Wunused-const-variable=]
> 
> It is not used since commit a3d43c0d56f1 ("taprio: Add
> support adding an admin schedule")
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

This is probably unintentional and a bug, we should be using that
policy value to validate that the sched list is indeed a nested
attribute.

I'm not applying this without at least a better and clear commit
message explaining why we shouldn't be using this policy any more.
