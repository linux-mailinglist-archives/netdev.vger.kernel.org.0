Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF59214CEBA
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 17:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgA2Q6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 11:58:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34532 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgA2Q6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 11:58:50 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D924814F0D684;
        Wed, 29 Jan 2020 08:58:48 -0800 (PST)
Date:   Wed, 29 Jan 2020 17:47:21 +0100 (CET)
Message-Id: <20200129.174721.1016754115618900369.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, matthieu.baerts@tessares.net,
        mathew.j.martineau@linux.intel.com
Subject: Re: [PATCH net 0/4] mptcp: fix sockopt crash and lockdep splats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200129145446.26425-1-fw@strlen.de>
References: <20200129145446.26425-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jan 2020 08:58:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Wed, 29 Jan 2020 15:54:42 +0100

> Christoph Paasch reported a few bugs and lockdep splats triggered by
> syzkaller.
> 
> One patch fixes a crash in set/getsockopt.
> Two patches fix lockdep splats related to the order in which RTNL
> and socket lock are taken.
> 
> Last patch fixes out-of-bounds access when TCP syncookies are used.
> 
> Change since last iteration on mptcp-list:
>  - add needed refcount in patch 2
>  - call tcp_get/setsockopt directly in patch 2
> 
>  Other patches unchanged except minor amends to commit messages.

Series applied, thanks Florian.
