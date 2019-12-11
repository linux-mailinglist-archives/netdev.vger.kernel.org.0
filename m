Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAA211A089
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 02:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfLKBdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 20:33:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51136 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfLKBdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 20:33:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F07661503943A;
        Tue, 10 Dec 2019 17:33:49 -0800 (PST)
Date:   Tue, 10 Dec 2019 17:33:49 -0800 (PST)
Message-Id: <20191210.173349.1613186496495560018.davem@davemloft.net>
To:     kuni1840@gmail.com
Cc:     edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, kuniyu@amazon.co.jp
Subject: Re: [PATCH v2 net-next] tcp: Cleanup duplicate initialization of
 sk->sk_state.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191210024148.24830-1-kuni1840@gmail.com>
References: <20191210024148.24830-1-kuni1840@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Dec 2019 17:33:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: kuni1840@gmail.com
Date: Tue, 10 Dec 2019 02:41:48 +0000

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

Applied, thanks.
