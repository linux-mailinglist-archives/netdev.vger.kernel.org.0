Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B413E1960C4
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 22:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgC0V5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 17:57:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39778 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgC0V5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 17:57:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC7CA15B66739;
        Fri, 27 Mar 2020 14:57:20 -0700 (PDT)
Date:   Fri, 27 Mar 2020 14:57:17 -0700 (PDT)
Message-Id: <20200327.145717.1553239214900655068.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net): ipsec 2020-03-27
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327081007.1185-1-steffen.klassert@secunet.com>
References: <20200327081007.1185-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Mar 2020 14:57:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Fri, 27 Mar 2020 09:09:59 +0100

> 1) Handle NETDEV_UNREGISTER for xfrm device to handle asynchronous
>    unregister events cleanly. From Raed Salem.
> 
> 2) Fix vti6 tunnel inter address family TX through bpf_redirect().
>    From Nicolas Dichtel.
> 
> 3) Fix lenght check in verify_sec_ctx_len() to avoid a
>    slab-out-of-bounds. From Xin Long.
> 
> 4) Add a missing verify_sec_ctx_len check in xfrm_add_acquire
>    to avoid a possible out-of-bounds to access. From Xin Long.
> 
> 5) Use built-in RCU list checking of hlist_for_each_entry_rcu
>    to silence false lockdep warning in __xfrm6_tunnel_spi_lookup
>    when CONFIG_PROVE_RCU_LIST is enabled. From Madhuparna Bhowmik.
> 
> 6) Fix a panic on esp offload when crypto is done asynchronously.
>    From Xin Long.
> 
> 7) Fix a skb memory leak in an error path of vti6_rcv.
>    From Torsten Hilbrich.
> 
> 8) Fix a race that can lead to a doulbe free in xfrm_policy_timer.
>    From Xin Long.
> 
> Please pull or let me know if there are problems.

Pulled, thanks Steffen.
