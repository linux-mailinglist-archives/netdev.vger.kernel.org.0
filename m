Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702351D1E6A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390200AbgEMTAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:00:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD62AC061A0C;
        Wed, 13 May 2020 12:00:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D4F412739E04;
        Wed, 13 May 2020 12:00:11 -0700 (PDT)
Date:   Wed, 13 May 2020 12:00:10 -0700 (PDT)
Message-Id: <20200513.120010.124458176293400943.davem@davemloft.net>
To:     madhuparnabhowmik10@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, frextrite@gmail.com, joel@joelfernandes.org,
        paulmck@kernel.org, cai@lca.pw
Subject: Re: [PATCH] Fix suspicious RCU usage warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513061610.22313-1-madhuparnabhowmik10@gmail.com>
References: <20200513061610.22313-1-madhuparnabhowmik10@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 12:00:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: madhuparnabhowmik10@gmail.com
Date: Wed, 13 May 2020 11:46:10 +0530

> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> This patch fixes the following warning:
> 
> =============================
> WARNING: suspicious RCU usage
> 5.7.0-rc4-next-20200507-syzkaller #0 Not tainted
> -----------------------------
> net/ipv6/ip6mr.c:124 RCU-list traversed in non-reader section!!
> 
> ipmr_new_table() returns an existing table, but there is no table at
> init. Therefore the condition: either holding rtnl or the list is empty
> is used.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

Please only provide one signoff line.

Please provide a proper Fixes: tag for this bug fix.

And finally, please make your Subject line more appropriate.  It must
first state the target tree inside of the "[PATCH]" area, the two choices
are "[PATCH net]" and "[PATCH net-next]" and it depends upon which tree
this patch is targetting.

Then your Subject line should also be more descriptive about exactly the
subsystem and area the change is being made to, for this change for
example you could use something like:

	ipv6: Fix suspicious RCU usage warning in ip6mr.

Also, obviously, there are also syzkaller tags you can add to the
commit message as well.
