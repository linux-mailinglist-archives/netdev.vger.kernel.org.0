Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E043F5A7D
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfKHWA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:00:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39144 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfKHWA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:00:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 071021433DE02;
        Fri,  8 Nov 2019 14:00:27 -0800 (PST)
Date:   Fri, 08 Nov 2019 14:00:27 -0800 (PST)
Message-Id: <20191108.140027.642572694965920256.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net: fix data-race in neigh_event_send()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108040819.85664-1-edumazet@google.com>
References: <20191108040819.85664-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 14:00:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  7 Nov 2019 20:08:19 -0800

> KCSAN reported the following data-race [1]
> 
> The fix will also prevent the compiler from optimizing out
> the condition.
> 
> [1]
> 
> BUG: KCSAN: data-race in neigh_resolve_output / neigh_resolve_output
 ...
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
