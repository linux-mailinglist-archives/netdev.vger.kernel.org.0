Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2C4F3EB9
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 05:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbfKHEIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 23:08:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52982 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729641AbfKHEIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 23:08:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C072114F4FDD8;
        Thu,  7 Nov 2019 20:08:37 -0800 (PST)
Date:   Thu, 07 Nov 2019 20:08:37 -0800 (PST)
Message-Id: <20191107.200837.35212301710315857.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net-next] net: add a READ_ONCE() in skb_peek_tail()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108024943.225900-1-edumazet@google.com>
References: <20191108024943.225900-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 20:08:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  7 Nov 2019 18:49:43 -0800

> skb_peek_tail() can be used without protection of a lock,
> as spotted by KCSAN [1]
> 
> In order to avoid load-stearing, add a READ_ONCE()
> 
> Note that the corresponding WRITE_ONCE() are already there.
> 
> [1]
> BUG: KCSAN: data-race in sk_wait_data / skb_queue_tail
 ...
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Also applied.
