Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1FF3EA4B2
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 21:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfJ3U1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 16:27:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45628 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfJ3U1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 16:27:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 10E1014BD1CE3;
        Wed, 30 Oct 2019 13:27:39 -0700 (PDT)
Date:   Wed, 30 Oct 2019 13:27:38 -0700 (PDT)
Message-Id: <20191030.132738.526564730010192127.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net: annotate accesses to sk->sk_incoming_cpu
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191030200004.234357-1-edumazet@google.com>
References: <20191030200004.234357-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 13:27:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 30 Oct 2019 13:00:04 -0700

> This socket field can be read and written by concurrent cpus.
> 
> Use READ_ONCE() and WRITE_ONCE() annotations to document this,
> and avoid some compiler 'optimizations'.
> 
> KCSAN reported :
 ...
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.4.0-rc3+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.
