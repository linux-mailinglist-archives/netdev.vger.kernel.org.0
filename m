Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE3417EDA0
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCJBGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:06:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34400 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgCJBGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:06:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDB9315A043F0;
        Mon,  9 Mar 2020 18:06:53 -0700 (PDT)
Date:   Mon, 09 Mar 2020 18:06:53 -0700 (PDT)
Message-Id: <20200309.180653.1902093153472006658.davem@davemloft.net>
To:     lesliemonis@gmail.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, tahiliani@nitk.edu.in,
        gautamramk@gmail.com, edumazet@google.com
Subject: Re: [PATCH net-next] net: sched: pie: change tc_pie_xstats->prob
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309191033.2975-1-lesliemonis@gmail.com>
References: <20200309191033.2975-1-lesliemonis@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 18:06:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leslie Monis <lesliemonis@gmail.com>
Date: Tue, 10 Mar 2020 00:40:33 +0530

> Commit 105e808c1da2 ("pie: remove pie_vars->accu_prob_overflows")
> changes the scale of probability values in PIE from (2^64 - 1) to
> (2^56 - 1). This affects the precision of tc_pie_xstats->prob in
> user space.
> 
> This patch ensures user space is unaffected.
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Leslie Monis <lesliemonis@gmail.com>

Applied, thanks.
