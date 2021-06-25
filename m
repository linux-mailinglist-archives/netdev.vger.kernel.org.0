Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254B93B4912
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 21:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFYTCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 15:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229764AbhFYTCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 15:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C4F8161962;
        Fri, 25 Jun 2021 19:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624647610;
        bh=f29Zac1eZgbbZ2ew08ooxqpKBjFM7Sg3qK5bgln2Hng=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Op6lZNMd4Ph+KF+UfFn3hOdzpiqf7klVmLcxv1XLQosCEp8q99yCeDoUHyX3puYsD
         v77pKUFCjS56MwusEKKBD5oaSxYK2wUNG92IAU9od9JATFHQQuZudB0hzqgaubr3h+
         RkeXFshERWgzLHz+oQ2IJATOsAyNTEdVb/mqF3GEMHBjzavLjUSU4j2l9Rjn+coH3q
         3GFqaejC3qREyPgUuGKiuTf3flsLvz8kKVyRP+4NBOKXdFwTHxXFYAPvMMwn4kEZ0l
         QHbP2bWS41vu9+ZyPfuizbSe4bzo3ft/dDpgDygkmhbTaDMajE0arZ7y5Il5OWpPZ+
         tAyYv22u3U42w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B3B3860CD6;
        Fri, 25 Jun 2021 19:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/smc: Ensure correct state of the socket in send
 path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162464761073.5473.13624606874255845272.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Jun 2021 19:00:10 +0000
References: <20210625151102.447198-1-kgraul@linux.ibm.com>
In-Reply-To: <20210625151102.447198-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, guvenc@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 25 Jun 2021 17:11:02 +0200 you wrote:
> From: Guvenc Gulce <guvenc@linux.ibm.com>
> 
> When smc_sendmsg() is called before the SMC socket initialization has
> completed, smc_tx_sendmsg() will access un-initialized fields of the
> SMC socket which results in a null-pointer dereference.
> Fix this by checking the socket state first in smc_tx_sendmsg().
> 
> [...]

Here is the summary with links:
  - [net-next] net/smc: Ensure correct state of the socket in send path
    https://git.kernel.org/netdev/net-next/c/17081633e22d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


