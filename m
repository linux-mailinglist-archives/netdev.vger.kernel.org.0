Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4666183871
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgCLST4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:19:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33410 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgCLST4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:19:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 38D6D15740A67;
        Thu, 12 Mar 2020 11:19:55 -0700 (PDT)
Date:   Thu, 12 Mar 2020 11:19:52 -0700 (PDT)
Message-Id: <20200312.111952.2245144514177634841.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, edumazet@google.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next] Revert "net: sched: make newly activated
 qdiscs visible"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200312175754.41339-1-jwi@linux.ibm.com>
References: <20200312175754.41339-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 11:19:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Thu, 12 Mar 2020 18:57:54 +0100

> This reverts commit 4cda75275f9f89f9485b0ca4d6950c95258a9bce
> from net-next.
> 
> Brown bag time.
> 
> Michal noticed that this change doesn't work at all when
> netif_set_real_num_tx_queues() gets called prior to an initial
> dev_activate(), as for instance igb does.
> 
> Doing so dies with:
 ...
> Fixes: 4cda75275f9f ("net: sched: make newly activated qdiscs visible")
> Reported-by: Michal Kubecek <mkubecek@suse.cz>
> CC: Michal Kubecek <mkubecek@suse.cz>
> CC: Eric Dumazet <edumazet@google.com>
> CC: Jamal Hadi Salim <jhs@mojatatu.com>
> CC: Cong Wang <xiyou.wangcong@gmail.com>
> CC: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

Applied, thanks for dealing with this so quickly.
