Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3B8C012D
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbfI0IaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:30:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57278 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfI0IaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 04:30:25 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E914A108B9039;
        Fri, 27 Sep 2019 01:30:23 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:30:22 +0200 (CEST)
Message-Id: <20190927.103022.2097498898113497055.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] sch_netem: fix rcu splat in netem_enqueue()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190924201126.77301-1-edumazet@google.com>
References: <20190924201126.77301-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 01:30:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 24 Sep 2019 13:11:26 -0700

> qdisc_root() use from netem_enqueue() triggers a lockdep warning.
> 
> __dev_queue_xmit() uses rcu_read_lock_bh() which is
> not equivalent to rcu_read_lock() + local_bh_disable_bh as far
> as lockdep is concerned.
 ...
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied.
