Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928CF14073C
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 11:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgAQKB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 05:01:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48710 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbgAQKB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 05:01:29 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A17FE155566FC;
        Fri, 17 Jan 2020 02:01:27 -0800 (PST)
Date:   Fri, 17 Jan 2020 02:01:25 -0800 (PST)
Message-Id: <20200117.020125.2203129124445754865.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, idosch@mellanox.com
Subject: Re: [PATCH net-next] netdevsim: fix nsim_fib6_rt_create() error
 path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200115195741.86879-1-edumazet@google.com>
References: <20200115195741.86879-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jan 2020 02:01:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 15 Jan 2020 11:57:41 -0800

> It seems nsim_fib6_rt_create() intent was to return
> either a valid pointer or an embedded error code.
 ...
> Fixes: 48bb9eb47b27 ("netdevsim: fib: Add dummy implementation for FIB offload")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied, thanks Eric.
