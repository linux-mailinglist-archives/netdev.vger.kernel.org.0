Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11E71F3CA1
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbfKHAQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:16:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50566 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfKHAQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:16:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A48591538517A;
        Thu,  7 Nov 2019 16:16:17 -0800 (PST)
Date:   Thu, 07 Nov 2019 16:16:17 -0800 (PST)
Message-Id: <20191107.161617.487096520289194233.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net-next] inetpeer: fix data-race in inet_putpeer /
 inet_putpeer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107183042.6286-1-edumazet@google.com>
References: <20191107183042.6286-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 16:16:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  7 Nov 2019 10:30:42 -0800

> We need to explicitely forbid read/store tearing in inet_peer_gc()
> and inet_putpeer().
> 
> The following syzbot report reminds us about inet_putpeer()
> running without a lock held.
> 
> BUG: KCSAN: data-race in inet_putpeer / inet_putpeer
 ...
> Fixes: 4b9d9be839fd ("inetpeer: remove unused list")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied.
