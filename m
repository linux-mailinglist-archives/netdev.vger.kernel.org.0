Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F31316332F
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgBRUig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:38:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36942 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgBRUig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:38:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 03BB612357EA6;
        Tue, 18 Feb 2020 12:38:35 -0800 (PST)
Date:   Tue, 18 Feb 2020 12:38:35 -0800 (PST)
Message-Id: <20200218.123835.1572321406516816915.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, a.fatoum@pengutronix.de
Subject: Re: [PATCH net] Revert "net: dev: introduce support for sch BYPASS
 for lockless qdisc"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <26b6bdd93aadb81d643da8279e2e340637f3a07e.1582019010.git.pabeni@redhat.com>
References: <26b6bdd93aadb81d643da8279e2e340637f3a07e.1582019010.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2020 12:38:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 18 Feb 2020 18:15:44 +0100

> This reverts commit ba27b4cdaaa66561aaedb2101876e563738d36fe
> 
> Ahmed reported ouf-of-order issues bisected to commit ba27b4cdaaa6
> ("net: dev: introduce support for sch BYPASS for lockless qdisc").
> I can't find any working solution other than a plain revert.
> 
> This will introduce some minor performance regressions for
> pfifo_fast qdisc. I plan to address them in net-next with more
> indirect call wrapper boilerplate for qdiscs.
> 
> Reported-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Fixes: ba27b4cdaaa6 ("net: dev: introduce support for sch BYPASS for lockless qdisc")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied and queued up for -stable, thanks.
