Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3211B5258
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgDWCVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgDWCVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:21:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CD6C03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 19:21:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58083127A44E0;
        Wed, 22 Apr 2020 19:21:20 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:21:19 -0700 (PDT)
Message-Id: <20200422.192119.1748431129111675424.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, vinicius.gomes@intel.com
Subject: Re: [PATCH net] sched: etf: do not assume all sockets are full
 blown
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200421170028.153025-1-edumazet@google.com>
References: <20200421170028.153025-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:21:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 21 Apr 2020 10:00:28 -0700

> skb->sk does not always point to a full blown socket,
> we need to use sk_fullsock() before accessing fields which
> only make sense on full socket.
 ...
> Fixes: 4b15c7075352 ("net/sched: Make etf report drops on error_queue")
> Fixes: 25db26a91364 ("net/sched: Introduce the ETF Qdisc")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks.
