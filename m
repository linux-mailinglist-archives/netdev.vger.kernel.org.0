Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF6F1D423F
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgEOAoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbgEOAoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:44:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851E5C061A0C;
        Thu, 14 May 2020 17:44:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9ECBF14D69E20;
        Thu, 14 May 2020 17:44:05 -0700 (PDT)
Date:   Thu, 14 May 2020 17:44:04 -0700 (PDT)
Message-Id: <20200514.174404.371938387358739530.davem@davemloft.net>
To:     madhuparnabhowmik10@gmail.com
Cc:     allison@lohutok.net, tglx@linutronix.de, ap420073@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        cai@lca.pw, joel@joelfernandes.org, frextrite@gmail.com
Subject: Re: [PATCH net] drivers: net: hamradio: Fix suspicious RCU usage
 warning in bpqether.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514141115.16074-1-madhuparnabhowmik10@gmail.com>
References: <20200514141115.16074-1-madhuparnabhowmik10@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 17:44:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: madhuparnabhowmik10@gmail.com
Date: Thu, 14 May 2020 19:41:15 +0530

> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> This patch fixes the following warning:
> =============================
> WARNING: suspicious RCU usage
> 5.7.0-rc5-next-20200514-syzkaller #0 Not tainted
> -----------------------------
> drivers/net/hamradio/bpqether.c:149 RCU-list traversed in non-reader section!!
> 
> Since rtnl lock is held, pass this cond in list_for_each_entry_rcu().
> 
> Reported-by: syzbot+bb82cafc737c002d11ca@syzkaller.appspotmail.com
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

Applied, thanks.
