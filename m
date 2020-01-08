Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60687134DD2
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgAHUnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:43:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47622 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgAHUnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:43:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 93DBC1584BD32;
        Wed,  8 Jan 2020 12:43:46 -0800 (PST)
Date:   Wed, 08 Jan 2020 12:43:46 -0800 (PST)
Message-Id: <20200108.124346.1336129295878108445.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, ap420073@gmail.com
Subject: Re: [PATCH net] gtp: fix bad unlock balance in
 gtp_encap_enable_socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200106144537.230912-1-edumazet@google.com>
References: <20200106144537.230912-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 12:43:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon,  6 Jan 2020 06:45:37 -0800

> WARNING: bad unlock balance detected!
> 5.5.0-rc5-syzkaller #0 Not tainted
> -------------------------------------
> syz-executor921/9688 is trying to release lock (sk_lock-AF_INET6) at:
> [<ffffffff84bf8506>] gtp_encap_enable_socket+0x146/0x400 drivers/net/gtp.c:830
> but there are no more locks to release!
  ...
> Fixes: e198987e7dd7 ("gtp: fix suspicious RCU usage")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable, thanks Eric.
