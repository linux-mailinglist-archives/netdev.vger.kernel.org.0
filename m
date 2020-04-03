Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5356019E13B
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 01:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgDCXBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 19:01:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36298 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgDCXBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 19:01:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1C88121938E5;
        Fri,  3 Apr 2020 16:01:08 -0700 (PDT)
Date:   Fri, 03 Apr 2020 16:01:08 -0700 (PDT)
Message-Id: <20200403.160108.1666760058187558170.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+8325e509a1bf83ec741d@syzkaller.appspotmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, paulmck@kernel.org
Subject: Re: [Patch net] net_sched: fix a missing refcnt in tcindex_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200403035851.31647-1-xiyou.wangcong@gmail.com>
References: <20200403035851.31647-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Apr 2020 16:01:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu,  2 Apr 2020 20:58:51 -0700

> The initial refcnt of struct tcindex_data should be 1,
> it is clear that I forgot to set it to 1 in tcindex_init().
> This leads to a dec-after-zero warning.
> 
> Reported-by: syzbot+8325e509a1bf83ec741d@syzkaller.appspotmail.com
> Fixes: 304e024216a8 ("net_sched: add a temporary refcnt for struct tcindex_data")
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, thanks Cong.
