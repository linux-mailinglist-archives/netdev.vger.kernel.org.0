Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7C7190407
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgCXEA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:00:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55878 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgCXEA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:00:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F380E15433174;
        Mon, 23 Mar 2020 21:00:27 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:00:26 -0700 (PDT)
Message-Id: <20200323.210026.2188935498095960390.davem@davemloft.net>
To:     cai@lca.pw
Cc:     alexander.h.duyck@linux.intel.com, kuznet@ms2.inr.ac.ru,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ipv4: fix a RCU-list lock in inet_dump_fib()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320025421.9216-1-cai@lca.pw>
References: <20200320025421.9216-1-cai@lca.pw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:00:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Date: Thu, 19 Mar 2020 22:54:21 -0400

> There is a place,
> 
> inet_dump_fib()
>   fib_table_dump
>     fn_trie_dump_leaf()
>       hlist_for_each_entry_rcu()
> 
> without rcu_read_lock() will trigger a warning,
> 
>  WARNING: suspicious RCU usage
 ...
> Fixes: 18a8021a7be3 ("net/ipv4: Plumb support for filtering route dumps")
> Signed-off-by: Qian Cai <cai@lca.pw>

Applied and queued up for -stable, thank you.
