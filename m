Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D53E21876B7
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 01:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733116AbgCQATg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 20:19:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50002 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732903AbgCQATg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 20:19:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 59BB71577F536;
        Mon, 16 Mar 2020 17:19:35 -0700 (PDT)
Date:   Mon, 16 Mar 2020 17:19:32 -0700 (PDT)
Message-Id: <20200316.171932.1747324396278110181.davem@davemloft.net>
To:     madhuparnabhowmik10@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        frextrite@gmail.com, paulmck@kernel.org, joel@joelfernandes.org
Subject: Re: [PATCH] net: kcm: kcmproc.c: Fix RCU list suspicious usage
 warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200316171352.3298-1-madhuparnabhowmik10@gmail.com>
References: <20200316171352.3298-1-madhuparnabhowmik10@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 17:19:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: madhuparnabhowmik10@gmail.com
Date: Mon, 16 Mar 2020 22:43:52 +0530

> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> This path fixes the suspicious RCU usage warning reported by
> kernel test robot.
> 
> net/kcm/kcmproc.c:#RCU-list_traversed_in_non-reader_section
> 
> There is no need to use list_for_each_entry_rcu() in
> kcm_stats_seq_show() as the list is always traversed under
> knet->mutex held.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

Applied to net-next, thanks.
