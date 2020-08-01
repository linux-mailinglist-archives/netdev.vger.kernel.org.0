Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA69323540D
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 20:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgHASq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 14:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbgHASq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 14:46:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6596BC06174A
        for <netdev@vger.kernel.org>; Sat,  1 Aug 2020 11:46:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0371C1284DAE5;
        Sat,  1 Aug 2020 11:30:09 -0700 (PDT)
Date:   Sat, 01 Aug 2020 11:46:52 -0700 (PDT)
Message-Id: <20200801.114652.393710470964339138.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, fw@strlen.de
Subject: Re: [PATCH net-next] tcp: fix build fong CONFIG_MPTCP=n
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200801020929.3000802-1-edumazet@google.com>
References: <20200801020929.3000802-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 01 Aug 2020 11:30:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 31 Jul 2020 19:09:29 -0700

> Fixes these errors:
> 
> net/ipv4/syncookies.c: In function 'tcp_get_cookie_sock':
> net/ipv4/syncookies.c:216:19: error: 'struct tcp_request_sock' has no
> member named 'drop_req'
>   216 |   if (tcp_rsk(req)->drop_req) {
>       |                   ^~
> net/ipv4/syncookies.c: In function 'cookie_tcp_reqsk_alloc':
> net/ipv4/syncookies.c:289:27: warning: unused variable 'treq'
> [-Wunused-variable]
>   289 |  struct tcp_request_sock *treq;
>       |                           ^~~~
> make[3]: *** [scripts/Makefile.build:280: net/ipv4/syncookies.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> 
> Fixes: 9466a1ccebbe ("mptcp: enable JOIN requests even if cookies are in use")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Florian Westphal <fw@strlen.de>

Applied, thank you.
