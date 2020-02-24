Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 533A516B166
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgBXVCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:02:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38290 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgBXVCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:02:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 721A012199AC5;
        Mon, 24 Feb 2020 13:02:35 -0800 (PST)
Date:   Mon, 24 Feb 2020 13:02:32 -0800 (PST)
Message-Id: <20200224.130232.525260099054528171.davem@davemloft.net>
To:     frextrite@gmail.com
Cc:     edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        joel@joelfernandes.org, madhuparnabhowmik10@gmail.com,
        paulmck@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] tcp, ulp: Pass lockdep expression to RCU lists
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200221151537.12334-1-frextrite@gmail.com>
References: <20200221151537.12334-1-frextrite@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 13:02:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amol Grover <frextrite@gmail.com>
Date: Fri, 21 Feb 2020 20:45:38 +0530

> tcp_ulp_list is traversed using list_for_each_entry_rcu
> outside an RCU read-side critical section but under the protection
> of tcp_ulp_list_lock.
> 
> Hence, add corresponding lockdep expression to silence false-positive
> warnings, and harden RCU lists.t
> 
> Signed-off-by: Amol Grover <frextrite@gmail.com>

Applied.
