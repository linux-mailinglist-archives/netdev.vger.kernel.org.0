Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6813DCAF44
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbfJCTb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:31:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47742 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbfJCTb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:31:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D319146D1AC4;
        Thu,  3 Oct 2019 12:31:26 -0700 (PDT)
Date:   Thu, 03 Oct 2019 12:31:25 -0700 (PDT)
Message-Id: <20191003.123125.1653429259406233251.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, jiri@mellanox.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net-next] net: propagate errors correctly in
 register_netdevice()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191003155924.71666-1-edumazet@google.com>
References: <20191003155924.71666-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Oct 2019 12:31:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  3 Oct 2019 08:59:24 -0700

> If netdev_name_node_head_alloc() fails to allocate
> memory, we absolutely want register_netdevice() to return
> -ENOMEM instead of zero :/
> 
> One of the syzbot report looked like :
> 
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
 ...
> Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jiri Pirko <jiri@mellanox.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied.
