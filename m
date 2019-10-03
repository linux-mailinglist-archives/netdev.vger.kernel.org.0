Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4809ACAEDA
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731724AbfJCTIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:08:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47400 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729702AbfJCTIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:08:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B9BDE146D0E63;
        Thu,  3 Oct 2019 12:08:44 -0700 (PDT)
Date:   Thu, 03 Oct 2019 12:08:44 -0700 (PDT)
Message-Id: <20191003.120844.699152057191482200.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com,
        willy@infradead.org, syzkaller@googlegroups.com
Subject: Re: [PATCH net] tcp: fix slab-out-of-bounds in
 tcp_zerocopy_receive()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191003031959.165054-1-edumazet@google.com>
References: <20191003031959.165054-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Oct 2019 12:08:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  2 Oct 2019 20:19:59 -0700

> Apparently a refactoring patch brought a bug, that was caught
> by syzbot [1]
> 
> Original code was correct, do not try to be smarter than the
> compiler :/
> 
> [1]
 ...
> Fixes: d8e18a516f8f ("net: Use skb accessors in network core")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
