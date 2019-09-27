Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCE2C0124
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfI0I2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:28:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57244 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbfI0I2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 04:28:36 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D645B14DECD54;
        Fri, 27 Sep 2019 01:28:34 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:28:33 +0200 (CEST)
Message-Id: <20190927.102833.1060603614092107867.davem@davemloft.net>
To:     edumazet@google.com
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, bpf@vger.kernel.org,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] kcm: disable preemption in
 kcm_parse_func_strparser()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190924192934.212317-1-edumazet@google.com>
References: <20190924192934.212317-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 01:28:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 24 Sep 2019 12:29:34 -0700

> After commit a2c11b034142 ("kcm: use BPF_PROG_RUN")
> syzbot easily triggers the warning in cant_sleep().
> 
> As explained in commit 6cab5e90ab2b ("bpf: run bpf programs
> with preemption disabled") we need to disable preemption before
> running bpf programs.
 ...
> Fixes: a2c11b034142 ("kcm: use BPF_PROG_RUN")
> Fixes: 6cab5e90ab2b ("bpf: run bpf programs with preemption disabled")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied.
