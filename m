Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCC033B09
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfFCWST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:18:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36272 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbfFCWST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:18:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EDA361009E4EF;
        Mon,  3 Jun 2019 15:18:18 -0700 (PDT)
Date:   Mon, 03 Jun 2019 15:18:18 -0700 (PDT)
Message-Id: <20190603.151818.2213401901831756808.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, pablo@netfilter.org
Subject: Re: [PATCH net-next] net: fix use-after-free in kfree_skb_list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190602182418.117629-1-edumazet@google.com>
References: <20190602182418.117629-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 15:18:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sun,  2 Jun 2019 11:24:18 -0700

> syzbot reported nasty use-after-free [1]
> 
> Lets remove frag_list field from structs ip_fraglist_iter
> and ip6_fraglist_iter. This seens not needed anyway.
 ...
> Fixes: 0feca6190f88 ("net: ipv6: add skbuff fraglist splitter")
> Fixes: c8b17be0b7a4 ("net: ipv4: add skbuff fraglist splitter")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>

Applied, thanks Eric.
