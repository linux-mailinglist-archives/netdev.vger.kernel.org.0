Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACE82495CC
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbfFQXXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:23:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39962 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfFQXXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 19:23:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 313E6151BE52F;
        Mon, 17 Jun 2019 16:23:09 -0700 (PDT)
Date:   Mon, 17 Jun 2019 16:23:08 -0700 (PDT)
Message-Id: <20190617.162308.2157008404980622764.davem@davemloft.net>
To:     vedang.patel@intel.com
Cc:     netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org
Subject: Re: [PATCH net-next v3 5/6] taprio: make clock reference
 conversions easier
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560799870-18956-6-git-send-email-vedang.patel@intel.com>
References: <1560799870-18956-1-git-send-email-vedang.patel@intel.com>
        <1560799870-18956-6-git-send-email-vedang.patel@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 16:23:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vedang Patel <vedang.patel@intel.com>
Date: Mon, 17 Jun 2019 12:31:09 -0700

> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index ab6080013666..f63cc3a9e69a 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
 ...
>  	return ns_to_ktime(sched->base_time);
>  }
>  
> +static inline ktime_t taprio_get_time(struct taprio_sched *q)
> +{

Please don't use inline here.
