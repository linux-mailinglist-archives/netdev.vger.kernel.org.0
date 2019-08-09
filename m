Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C23F8842E
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 22:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfHIUli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 16:41:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37864 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfHIUli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 16:41:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 791D4145DD3AA;
        Fri,  9 Aug 2019 13:41:37 -0700 (PDT)
Date:   Fri, 09 Aug 2019 13:41:36 -0700 (PDT)
Message-Id: <20190809.134136.289159189804759707.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vinicius.gomes@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] taprio: remove unused variable
 'entry_list_policy'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190809014923.69328-1-yuehaibing@huawei.com>
References: <20190808142623.69188-1-yuehaibing@huawei.com>
        <20190809014923.69328-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 13:41:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 9 Aug 2019 09:49:23 +0800

> net/sched/sch_taprio.c:680:32: warning:
>  entry_list_policy defined but not used [-Wunused-const-variable=]
> 
> One of the points of commit a3d43c0d56f1 ("taprio: Add support adding
> an admin schedule") is that it removes support (it now returns "not
> supported") for schedules using the TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY
> attribute (which were never used), the parsing of those types of schedules
> was the only user of this policy. So removing this policy should be fine.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: respin commit log using Vinicius's explanation.

Applied.
