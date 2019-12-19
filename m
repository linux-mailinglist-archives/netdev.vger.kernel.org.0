Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1322126874
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfLSRwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:52:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39928 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbfLSRwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 12:52:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC3A515307A73;
        Thu, 19 Dec 2019 09:52:10 -0800 (PST)
Date:   Thu, 19 Dec 2019 09:52:08 -0800 (PST)
Message-Id: <20191219.095208.349922153806345978.davem@davemloft.net>
To:     lorenzo@google.com
Cc:     nhorman@tuxdriver.com, zenczykowski@gmail.com, maze@google.com,
        netdev@vger.kernel.org, stranche@codeaurora.org,
        subashab@codeaurora.org, edumazet@google.com,
        linux-sctp@vger.kernel.org
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAKD1Yr2wyWbwCGP=BNqAfsGu9cjgjD12-ePjs648Or-FjqHyBw@mail.gmail.com>
References: <CAKD1Yr1m-bqpeZxMRVs84WvvjRE3zp8kJVx57OXf342r2gzVyw@mail.gmail.com>
        <20191219131700.GA1159@hmswarspite.think-freely.org>
        <CAKD1Yr2wyWbwCGP=BNqAfsGu9cjgjD12-ePjs648Or-FjqHyBw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Dec 2019 09:52:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Colitti <lorenzo@google.com>
Date: Thu, 19 Dec 2019 23:02:32 +0900

> But in any case, the result would be more complicated to use and
> maintain, and it would likely also be less realistic, such that a
> sophisticated conformance test might still find that the port was
> actually bound. Other users of the kernel wouldn't get to use this
> sysctl, and the userspace code can't be easily reused in other
> open-source projects, so the community gets nothing useful. That
> doesn't seem great.

The same argument can be made about kernel changes that are only
needed by Android because they refuse to use a userspace solution that
frankly can do the job.

Can you see why these Android special case discussions are so
frustrating for kernel devs?

And using the "we'll just have a local kernel change in the Android
kernel" threat as leverage in the discussion... yeah very unpleasant
indeed.
