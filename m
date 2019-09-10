Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4197AF081
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 19:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437042AbfIJRbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 13:31:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59878 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436712AbfIJRbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 13:31:47 -0400
Received: from localhost (unknown [88.214.187.211])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D195154FE28C;
        Tue, 10 Sep 2019 10:31:45 -0700 (PDT)
Date:   Tue, 10 Sep 2019 19:31:43 +0200 (CEST)
Message-Id: <20190910.193143.1163269111251640073.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+bc6297c11f19ee807dc2@syzkaller.appspotmail.com,
        syzbot+041483004a7f45f1f20a@syzkaller.appspotmail.com,
        syzbot+55be5f513bed37fc4367@syzkaller.appspotmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, vtlam@google.com
Subject: Re: [Patch net] sch_hhf: ensure quantum and hhf_non_hh_weight are
 non-zero
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190908204051.760-1-xiyou.wangcong@gmail.com>
References: <20190908204051.760-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Sep 2019 10:31:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sun,  8 Sep 2019 13:40:51 -0700

> In case of TCA_HHF_NON_HH_WEIGHT or TCA_HHF_QUANTUM is zero,
> it would make no progress inside the loop in hhf_dequeue() thus
> kernel would get stuck.
> 
> Fix this by checking this corner case in hhf_change().
> 
> Fixes: 10239edf86f1 ("net-qdisc-hhf: Heavy-Hitter Filter (HHF) qdisc")
> Reported-by: syzbot+bc6297c11f19ee807dc2@syzkaller.appspotmail.com
> Reported-by: syzbot+041483004a7f45f1f20a@syzkaller.appspotmail.com
> Reported-by: syzbot+55be5f513bed37fc4367@syzkaller.appspotmail.com
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: Terry Lam <vtlam@google.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable.
