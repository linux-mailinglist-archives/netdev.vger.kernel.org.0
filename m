Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2524A270986
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 02:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgISAu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 20:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgISAu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 20:50:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28753C0613CE;
        Fri, 18 Sep 2020 17:50:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9ACB415B42F17;
        Fri, 18 Sep 2020 17:34:10 -0700 (PDT)
Date:   Fri, 18 Sep 2020 17:50:57 -0700 (PDT)
Message-Id: <20200918.175057.435251687372962343.davem@davemloft.net>
To:     yanxiaoyong5@gmail.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/sched: cbs: fix calculation error of idleslope
 credits
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918084252.4200-1-yanxiaoyong5@gmail.com>
References: <20200918084252.4200-1-yanxiaoyong5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 17:34:10 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoyong Yan <yanxiaoyong5@gmail.com>
Date: Fri, 18 Sep 2020 01:42:52 -0700

> +		delay = delay_from_credits(q->credits, q->idleslope);
> +	    cbs_timer_schedule(q, now+ delay);
> +		q->last = now;

This indentation cannot be correct.

Please fix this.
