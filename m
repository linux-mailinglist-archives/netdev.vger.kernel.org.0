Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C211E95B4
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387422AbgEaEtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 00:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387410AbgEaEtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:49:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC26DC05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:49:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FC86128FCC95;
        Sat, 30 May 2020 21:49:06 -0700 (PDT)
Date:   Sat, 30 May 2020 21:49:05 -0700 (PDT)
Message-Id: <20200530.214905.594964732844168436.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next 0/2] selftests: forwarding: Two small changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1590749356.git.petrm@mellanox.com>
References: <cover.1590749356.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 21:49:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Fri, 29 May 2020 14:16:52 +0300

> Two unrelated changes in this patchset:
> 
> - In patch #1, convert mirror tests from using ping directly to generating
>   ICMP packets by mausezahn. Using ping in tests is error-prone, because
>   ping is too smart. On a flaky system (notably in a simulator), when
>   packets don't come quickly enough, more pings are sent, and that throws
>   off counters. This was worked around in the past by just pinging more
>   slowly, but using mausezahn avoids the issue as well without making the
>   tests unnecessary slow.
> 
> - A missing stats_update callback was recently added to act_pedit. Now that
>   iproute2 supports JSON dumping for pedit, extend in patch #2 the
>   pedit_dsfield selftest with a check that would have caught the fact that
>   the callback was missing.

Series applied, thanks.
