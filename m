Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A621417EE08
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgCJBdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:33:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34574 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgCJBdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:33:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E5AE15A07526;
        Mon,  9 Mar 2020 18:33:11 -0700 (PDT)
Date:   Mon, 09 Mar 2020 18:33:10 -0700 (PDT)
Message-Id: <20200309.183310.64095245470909485.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, maheshb@google.com
Subject: Re: [PATCH net] ipvlan: do not use cond_resched_rcu() in
 ipvlan_process_multicast()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310012258.196797-1-edumazet@google.com>
References: <20200310012258.196797-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 18:33:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon,  9 Mar 2020 18:22:58 -0700

> Commit e18b353f102e ("ipvlan: add cond_resched_rcu() while
> processing muticast backlog") added a cond_resched_rcu() in a loop
> using rcu protection to iterate over slaves.
> 
> This is breaking rcu rules, so lets instead use cond_resched()
> at a point we can reschedule
> 
> Fixes: e18b353f102e ("ipvlan: add cond_resched_rcu() while processing muticast backlog")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Mahesh Bandewar <maheshb@google.com>

Applied, thanks for the quick fix Eric.
