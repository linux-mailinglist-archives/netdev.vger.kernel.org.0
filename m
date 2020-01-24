Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B72121487BE
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392488AbgAXOYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:24:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41386 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392483AbgAXOYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 09:24:54 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DAC38158D61A9;
        Fri, 24 Jan 2020 06:24:52 -0800 (PST)
Date:   Fri, 24 Jan 2020 15:24:25 +0100 (CET)
Message-Id: <20200124.152425.1414135523887609628.davem@davemloft.net>
To:     cpaasch@apple.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next v3 00/19] Multipath TCP part 2: Single subflow
 & RFC8684 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200122005633.21229-1-cpaasch@apple.com>
References: <20200122005633.21229-1-cpaasch@apple.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jan 2020 06:24:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Paasch <cpaasch@apple.com>
Date: Tue, 21 Jan 2020 16:56:14 -0800

> v2 -> v3: Added RFC8684-style handshake (see below fore more details) and some minor fixes
> v1 -> v2: Rebased on latest "Multipath TCP: Prerequisites" v3 series
> 
> This set adds MPTCP connection establishment, writing & reading MPTCP
> options on data packets, a sysctl to allow MPTCP per-namespace, and self
> tests. This is sufficient to establish and maintain a connection with a
> MPTCP peer, but will not yet allow or initiate establishment of
> additional MPTCP subflows.
> 
> We also add the necessary code for the RFC8684-style handshake.
> RFC8684 obsoletes the experimental RFC6824 and makes MPTCP move-on to
> version 1.
 ...

Honestly I don't see anything super objectionable here.

And if there is, it can be easily fixed up with follow-on patches.

Series applied, thanks!
