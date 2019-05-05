Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4A614196
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfEERlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:41:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53112 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfEERlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:41:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C87A14DA76EC;
        Sun,  5 May 2019 10:41:00 -0700 (PDT)
Date:   Sun, 05 May 2019 10:40:59 -0700 (PDT)
Message-Id: <20190505.104059.1897652314199452950.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        stefan.bader@canonical.com, posk@google.com, fw@strlen.de
Subject: Re: [PATCH v2 net] ip6: fix skb leak in ip6frag_expire_frag_queue()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190503152444.122630-1-edumazet@google.com>
References: <20190503152444.122630-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:41:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri,  3 May 2019 08:24:44 -0700

> Since ip6frag_expire_frag_queue() now pulls the head skb
> from frag queue, we should no longer use skb_get(), since
> this leads to an skb leak.
> 
> Stefan Bader initially reported a problem in 4.4.stable [1] caused
> by the skb_get(), so this patch should also fix this issue.
 ...
> Fixes: d4289fcc9b16 ("net: IP6 defrag: use rbtrees for IPv6 defrag")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Stefan Bader <stefan.bader@canonical.com>

Applied, thanks Eric.
