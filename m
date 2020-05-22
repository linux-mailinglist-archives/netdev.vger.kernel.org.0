Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F281DF1F1
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 00:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731150AbgEVWkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 18:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731029AbgEVWj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 18:39:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A54C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 15:39:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0EC3F1274229C;
        Fri, 22 May 2020 15:39:59 -0700 (PDT)
Date:   Fri, 22 May 2020 15:39:58 -0700 (PDT)
Message-Id: <20200522.153958.1756967784732800385.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        lucien.xin@gmail.com, jon.maloy@ericsson.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] tipc: block BH before using dst_cache
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200521182958.163436-1-edumazet@google.com>
References: <20200521182958.163436-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 15:39:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 21 May 2020 11:29:58 -0700

> dst_cache_get() documents it must be used with BH disabled.
> 
> sysbot reported :
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: /21697
> caller is dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
 ...
> Fixes: e9c1a793210f ("tipc: add dst_cache support for udp media")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks.
