Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCFD6615E
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 23:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbfGKVoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 17:44:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728434AbfGKVoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 17:44:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A49314DB02C0;
        Thu, 11 Jul 2019 14:44:12 -0700 (PDT)
Date:   Thu, 11 Jul 2019 14:44:11 -0700 (PDT)
Message-Id: <20190711.144411.1458652506187647731.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, willemb@google.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] ipv6: fix static key imbalance in fl_create()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190710134011.221210-3-edumazet@google.com>
References: <20190710134011.221210-1-edumazet@google.com>
        <20190710134011.221210-3-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jul 2019 14:44:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 Jul 2019 06:40:11 -0700

> fl_create() should call static_branch_deferred_inc() only in
> case of success.
> 
> Also we should not call fl_free() in error path, as this could
> cause a static key imbalance.
 ...
> Fixes: 59c820b2317f ("ipv6: elide flowlabel check if no exclusive leases exist")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Willem de Bruijn <willemb@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied.
