Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684842316DD
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730778AbgG2Al4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730507AbgG2Al4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:41:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A72FC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:41:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 43F9A128D4784;
        Tue, 28 Jul 2020 17:25:10 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:41:54 -0700 (PDT)
Message-Id: <20200728.174154.77325504094188897.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+6e95a4fabf88dc217145@syzkaller.appspotmail.com,
        petrm@mellanox.com, jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [Patch net-next] net_sched: initialize timer earlier in
 red_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200725201707.16909-1-xiyou.wangcong@gmail.com>
References: <20200725201707.16909-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 17:25:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat, 25 Jul 2020 13:17:07 -0700

> When red_init() fails, red_destroy() is called to clean up.
> If the timer is not initialized yet, del_timer_sync() will
> complain. So we have to move timer_setup() before any failure.
> 
> Reported-and-tested-by: syzbot+6e95a4fabf88dc217145@syzkaller.appspotmail.com
> Fixes: aee9caa03fc3 ("net: sched: sch_red: Add qevents "early_drop" and "mark"")
> Cc: Petr Machata <petrm@mellanox.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, thank you.
