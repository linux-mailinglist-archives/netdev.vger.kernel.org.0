Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2AE86B0CF
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 23:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388804AbfGPVM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 17:12:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58042 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbfGPVM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 17:12:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6EE941264F01A;
        Tue, 16 Jul 2019 14:12:27 -0700 (PDT)
Date:   Tue, 16 Jul 2019 14:12:24 -0700 (PDT)
Message-Id: <20190716.141224.1393775814190631111.davem@davemloft.net>
To:     cai@lca.pw
Cc:     willemb@google.com, joe@perches.com,
        clang-built-linux@googlegroups.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] skbuff: fix compilation warnings in skb_dump()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563291785-6545-1-git-send-email-cai@lca.pw>
References: <1563291785-6545-1-git-send-email-cai@lca.pw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Jul 2019 14:12:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Date: Tue, 16 Jul 2019 11:43:05 -0400

> The commit 6413139dfc64 ("skbuff: increase verbosity when dumping skb
> data") introduced a few compilation warnings.
> 
> net/core/skbuff.c:766:32: warning: format specifies type 'unsigned
> short' but the argument has type 'unsigned int' [-Wformat]
>                        level, sk->sk_family, sk->sk_type,
> sk->sk_protocol);
>                                              ^~~~~~~~~~~
> net/core/skbuff.c:766:45: warning: format specifies type 'unsigned
> short' but the argument has type 'unsigned int' [-Wformat]
>                        level, sk->sk_family, sk->sk_type,
> sk->sk_protocol);
> ^~~~~~~~~~~~~~~
> 
> Fix them by using the proper types.
> 
> Fixes: 6413139dfc64 ("skbuff: increase verbosity when dumping skb data")
> Signed-off-by: Qian Cai <cai@lca.pw>

Applied, thank you.
