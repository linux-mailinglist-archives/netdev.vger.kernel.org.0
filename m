Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92739164E2F
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 19:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgBSS4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 13:56:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46324 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgBSS4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 13:56:00 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5FE7A15ADF43E;
        Wed, 19 Feb 2020 10:55:59 -0800 (PST)
Date:   Wed, 19 Feb 2020 10:55:58 -0800 (PST)
Message-Id: <20200219.105558.92909916426467093.davem@davemloft.net>
To:     frextrite@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        joel@joelfernandes.org, madhuparnabhowmik10@gmail.com,
        paulmck@kernel.org
Subject: Re: [PATCH RESEND] net: hsr: Pass lockdep expression to RCU lists
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200219100010.23264-1-frextrite@gmail.com>
References: <20200219100010.23264-1-frextrite@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 10:55:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amol Grover <frextrite@gmail.com>
Date: Wed, 19 Feb 2020 15:30:11 +0530

> node_db is traversed using list_for_each_entry_rcu
> outside an RCU read-side critical section but under the protection
> of hsr->list_lock.
> 
> Hence, add corresponding lockdep expression to silence false-positive
> warnings, and harden RCU lists.
> 
> Signed-off-by: Amol Grover <frextrite@gmail.com>
> ---
> Resend:
> - Remove failed delivery recipients

Applied.
