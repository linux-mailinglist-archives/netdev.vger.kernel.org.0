Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD1704FD88
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 20:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfFWSZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 14:25:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43488 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfFWSZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 14:25:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B333126A1253;
        Sun, 23 Jun 2019 11:25:28 -0700 (PDT)
Date:   Sun, 23 Jun 2019 11:25:27 -0700 (PDT)
Message-Id: <20190623.112527.356335784552993919.davem@davemloft.net>
To:     cai@lca.pw
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] inet: fix compilation warnings in
 fqdir_pre_exit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561042360-20480-1-git-send-email-cai@lca.pw>
References: <1561042360-20480-1-git-send-email-cai@lca.pw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Jun 2019 11:25:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Date: Thu, 20 Jun 2019 10:52:40 -0400

> The linux-next commit "inet: fix various use-after-free in defrags
> units" [1] introduced compilation warnings,
> 
> ./include/net/inet_frag.h:117:1: warning: 'inline' is not at beginning
> of declaration [-Wold-style-declaration]
>  static void inline fqdir_pre_exit(struct fqdir *fqdir)
>  ^~~~~~
> In file included from ./include/net/netns/ipv4.h:10,
>                  from ./include/net/net_namespace.h:20,
>                  from ./include/linux/netdevice.h:38,
>                  from ./include/linux/icmpv6.h:13,
>                  from ./include/linux/ipv6.h:86,
>                  from ./include/net/ipv6.h:12,
>                  from ./include/rdma/ib_verbs.h:51,
>                  from ./include/linux/mlx5/device.h:37,
>                  from ./include/linux/mlx5/driver.h:51,
>                  from
> drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:37:
> 
> [1] https://lore.kernel.org/netdev/20190618180900.88939-3-edumazet@google.com/
> 
> Signed-off-by: Qian Cai <cai@lca.pw>

Applied.
