Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED756615D
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 23:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbfGKVoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 17:44:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728434AbfGKVoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 17:44:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8D7114DB02C7;
        Thu, 11 Jul 2019 14:43:59 -0700 (PDT)
Date:   Thu, 11 Jul 2019 14:43:59 -0700 (PDT)
Message-Id: <20190711.144359.970504759650446186.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, willemb@google.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] ipv6: fix potential crash in
 ip6_datagram_dst_update()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190710134011.221210-2-edumazet@google.com>
References: <20190710134011.221210-1-edumazet@google.com>
        <20190710134011.221210-2-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jul 2019 14:44:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 Jul 2019 06:40:10 -0700

> Willem forgot to change one of the calls to fl6_sock_lookup(),
> which can now return an error or NULL.
> 
> syzbot reported :
 ...
> Fixes: 59c820b2317f ("ipv6: elide flowlabel check if no exclusive leases exist")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Willem de Bruijn <willemb@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied.
