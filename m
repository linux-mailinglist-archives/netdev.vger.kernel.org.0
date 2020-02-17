Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8F71608F9
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgBQDc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:32:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48310 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727668AbgBQDc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:32:27 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 754891574C445;
        Sun, 16 Feb 2020 19:32:26 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:32:25 -0800 (PST)
Message-Id: <20200216.193225.1152754892500799378.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, eric.dumazet@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 0/3] bonding: fix bonding interface bugs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200215104949.21355-1-ap420073@gmail.com>
References: <20200215104949.21355-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:32:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Sat, 15 Feb 2020 10:49:49 +0000

> This patchset fixes lockdep problem in bonding interface
> 
> 1. The first patch is to add missing netdev_update_lockdep_key().
> After bond_release(), netdev_update_lockdep_key() should be called.
> But both ioctl path and attribute path don't call
> netdev_update_lockdep_key().
> This patch adds missing netdev_update_lockdep_key().
> 
> 2. The second patch is to export netdev_next_lower_dev_rcu symbol.
> netdev_next_lower_dev_rcu() is useful to implement the function,
> which is to walk their all lower interfaces.
> This patch is actually a preparing patch for the third patch.
> 
> 3. The last patch is to fix lockdep waring in bond_get_stats().
> The stats_lock uses a dynamic lockdep key.
> So, after "nomaster" operation, updating the dynamic lockdep key
> routine is needed. but it doesn't
> So, lockdep warning occurs.
> 
> Change log:
> v1 -> v2:
>  - Update headline from "fix bonding interface bugs"
>    to "bonding: fix bonding interface bugs"
>  - Drop a patch("bonding: do not collect slave's stats")
>  - Add new patches
>    - ("net: export netdev_next_lower_dev_rcu()")
>    - ("bonding: fix lockdep warning in bond_get_stats()")

Series applied, thank you.
