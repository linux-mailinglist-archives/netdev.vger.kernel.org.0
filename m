Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA42E11732D
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfLIRxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:53:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33524 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIRxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:53:06 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 182B915437271;
        Mon,  9 Dec 2019 09:53:06 -0800 (PST)
Date:   Mon, 09 Dec 2019 09:53:05 -0800 (PST)
Message-Id: <20191209.095305.52672763318299767.davem@davemloft.net>
To:     kuni1840@gmail.com
Cc:     edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, kuniyu@amazon.co.jp
Subject: Re: [PATCH] net/ipv4/tcp.c: cleanup duplicate initialization of
 sk->sk_state in tcp_init_sock()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191208143127.10972-1-kuni1840+alias@gmail.com>
References: <20191208143127.10972-1-kuni1840+alias@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 09:53:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: kuni1840@gmail.com
Date: Sun,  8 Dec 2019 14:31:27 +0000

> From: Kuniyuki Iwashima <kuni1840@gmail.com>
> 
> When a TCP socket is created, sk->sk_state is initialized twice as
> TCP_CLOSE in sock_init_data() and tcp_init_sock(). The tcp_init_sock() is
> always called after the sock_init_data(), so it is not necessary to update
> sk->sk_state in the tcp_init_sock().
> 
> Before v2.1.8, the code of the two functions was in the inet_create(). In
> the patch of v2.1.8, the tcp_v4/v6_init_sock() were added and the code of
> initialization of sk->state was duplicated.
> 
> Signed-off-by: Kuniyuki Iwashima <kuni1840@gmail.com>

Please format your Subject line correctly, it should be of the form:

	Subject: [PATCH $PATCH_VERSION $TARGET_GIT_TREE] subsystem_prefix: Description.

Using a source file path in the Subject line is not appropriate.

So when you respin this patch you could say:

	Subject: [PATCH v2 net-next] tcp: Cleanup duplicate initialization of sk->sk_state.
