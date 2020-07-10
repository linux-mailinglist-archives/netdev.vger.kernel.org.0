Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E21421BF53
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgGJViw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgGJViw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 17:38:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E14C08C5DC
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 14:38:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5A18D1286AB81;
        Fri, 10 Jul 2020 14:38:51 -0700 (PDT)
Date:   Fri, 10 Jul 2020 14:38:50 -0700 (PDT)
Message-Id: <20200710.143850.1365535614159124305.davem@davemloft.net>
To:     kuniyu@amazon.co.jp
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        edumazet@google.com, netdev@vger.kernel.org, kuni1840@gmail.com,
        benh@amazon.com, osa-contribution-log@amazon.com, ja@ssi.bg
Subject: Re: [PATCH v4 net-next] inet: Remove an unnecessary argument of
 syn_ack_recalc().
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200710155759.87178-1-kuniyu@amazon.co.jp>
References: <20200710155759.87178-1-kuniyu@amazon.co.jp>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jul 2020 14:38:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date: Sat, 11 Jul 2020 00:57:59 +0900

> Commit 0c3d79bce48034018e840468ac5a642894a521a3 ("tcp: reduce SYN-ACK
> retrans for TCP_DEFER_ACCEPT") introduces syn_ack_recalc() which decides
> if a minisock is held and a SYN+ACK is retransmitted or not.
> 
> If rskq_defer_accept is not zero in syn_ack_recalc(), max_retries always
> has the same value because max_retries is overwritten by rskq_defer_accept
> in reqsk_timer_handler().
> 
> This commit adds three changes:
> - remove redundant non-zero check for rskq_defer_accept in
>    reqsk_timer_handler().
> - remove max_retries from the arguments of syn_ack_recalc() and use
>    rskq_defer_accept instead.
> - rename thresh to max_syn_ack_retries for readability.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>

Applied, thanks.
