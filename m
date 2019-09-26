Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E35BEC43
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 08:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfIZG7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 02:59:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44508 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbfIZG7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 02:59:40 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6DD331264DFC9;
        Wed, 25 Sep 2019 23:59:38 -0700 (PDT)
Date:   Thu, 26 Sep 2019 08:59:36 +0200 (CEST)
Message-Id: <20190926.085936.1117617922335141238.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, xiyou.wangcong@gmail.com,
        vladbu@mellanox.com, jiri@mellanox.com
Subject: Re: [PATCH v2 net] net: sched: fix possible crash in
 tcf_action_destroy()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190923221857.103908-1-edumazet@google.com>
References: <20190923221857.103908-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 23:59:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 23 Sep 2019 15:18:57 -0700

> If the allocation done in tcf_exts_init() failed,
> we end up with a NULL pointer in exts->actions.
 ...
> Fixes: 90b73b77d08e ("net: sched: change action API to use array of pointers to actions")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Eric, I applied v1 yesterday that guards at the call site.

Please send a relative patch if you want to do it this way instead.

Sorry.
