Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1ABAF07C
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 19:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437062AbfIJR33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 13:29:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59844 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436845AbfIJR33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 13:29:29 -0400
Received: from localhost (unknown [88.214.187.211])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 015FE154FE274;
        Tue, 10 Sep 2019 10:29:27 -0700 (PDT)
Date:   Tue, 10 Sep 2019 19:29:26 +0200 (CEST)
Message-Id: <20190910.192926.1095926485328225231.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+21b29db13c065852f64b@syzkaller.appspotmail.com,
        jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [Patch net] net_sched: check cops->tcf_block in
 tc_bind_tclass()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190908191123.31059-1-xiyou.wangcong@gmail.com>
References: <20190908191123.31059-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Sep 2019 10:29:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sun,  8 Sep 2019 12:11:23 -0700

> At least sch_red and sch_tbf don't implement ->tcf_block()
> while still have a non-zero tc "class".
> 
> Instead of adding nop implementations to each of such qdisc's,
> we can just relax the check of cops->tcf_block() in
> tc_bind_tclass(). They don't support TC filter anyway.
> 
> Reported-by: syzbot+21b29db13c065852f64b@syzkaller.appspotmail.com
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied.
