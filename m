Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9716C1426EB
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgATJRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:17:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55038 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgATJRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:17:54 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A05D3153D2571;
        Mon, 20 Jan 2020 01:17:51 -0800 (PST)
Date:   Mon, 20 Jan 2020 10:17:50 +0100 (CET)
Message-Id: <20200120.101750.1751495414871531195.davem@davemloft.net>
To:     gautamramk@gmail.com
Cc:     netdev@vger.kernel.org, tahiliani@nitk.edu.in, jhs@mojatatu.com,
        dave.taht@gmail.com, toke@redhat.com, kuba@kernel.org,
        stephen@networkplumber.org, lesliemonis@gmail.com,
        sdp.sachin@gmail.com, vsaicharan1998@gmail.com,
        mohitbhasi1998@gmail.com
Subject: Re: [PATCH net-next v4 1/2] net: sched: pie: refactor code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200117100921.31966-2-gautamramk@gmail.com>
References: <20200117100921.31966-1-gautamramk@gmail.com>
        <20200117100921.31966-2-gautamramk@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jan 2020 01:17:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gautamramk@gmail.com
Date: Fri, 17 Jan 2020 15:39:20 +0530

> This patch is a precursor for the addition of the Flow Queue Proportional
> Integral Controller Enhanced (FQ-PIE) qdisc. The patch removes structures
> and small inline functions common to both PIE and FQ-PIE and moves it to
> the header file include/net/pie.h. It also exports symbols from sch_pie.c
> that are to be reused in sch_fq_pie.c.

That's not all this patch is doing.

It's making coding style and indentation changes as well.

I also see it changing how values are tracked in local variables.

All of these things are separate logical commits.
