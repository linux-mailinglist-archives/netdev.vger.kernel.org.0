Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8BD0149B15
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 15:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgAZO3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 09:29:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57642 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728977AbgAZO3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 09:29:08 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B80C915BFFC07;
        Sun, 26 Jan 2020 06:29:06 -0800 (PST)
Date:   Sun, 26 Jan 2020 15:29:04 +0100 (CET)
Message-Id: <20200126.152904.2177940112759062154.davem@davemloft.net>
To:     yyd@google.com
Cc:     netdev@vger.kernel.org, akabbani@google.com, ncardwell@google.com,
        ycheng@google.com, edumazet@google.com
Subject: Re: [PATCH net-next] tcp: export count for rehash attempts
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200124213402.83353-1-yyd@google.com>
References: <20200124213402.83353-1-yyd@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 Jan 2020 06:29:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Kevin(Yudong) Yang" <yyd@google.com>
Date: Fri, 24 Jan 2020 16:34:02 -0500

> From: Abdul Kabbani <akabbani@google.com>
> 
> Using IPv6 flow-label to swiftly route around avoid congested or
> disconnected network path can greatly improve TCP reliability.
> 
> This patch adds SNMP counters and a OPT_STATS counter to track both
> host-level and connection-level statistics. Network administrators
> can use these counters to evaluate the impact of this new ability better.
> 
> Export count for rehash attempts to
> 1) two SNMP counters: TcpTimeoutRehash (rehash due to timeouts),
>    and TcpDuplicateDataRehash (rehash due to receiving duplicate
>    packets)
> 2) Timestamping API SOF_TIMESTAMPING_OPT_STATS.
> 
> Signed-off-by: Abdul Kabbani <akabbani@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Kevin(Yudong) Yang <yyd@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied to net-next, thank you.
