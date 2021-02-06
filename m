Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEFA311A2E
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhBFDd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:33:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231518AbhBFDar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 22:30:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E3C3C64F9C;
        Sat,  6 Feb 2021 03:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612582206;
        bh=TtAn4xPruiKtbJVcD486A+9+pF8OW5/l6ZpvXQrDHXk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tt0geoMhrlm3nNkWHNAvaoeAB5F07R6Z/RLjRlO5cWNW0Ksbv6GEPPgdIw1iymozR
         KIEpApDzBSZkf9uCUpQJ1JHvDyMQOWGS8cWodG2gnP2uK7Mdz7DzsZkzFn3pKYOviA
         7hsi+2blGBerLx5QusjW1ViljmgV2AUXzJsyn73cQ8O8/k9XAXVO0Stkmwaef2L4WD
         A2XBqGj4IkvDT2lnSbmsLj04a+/BKZloE5R3nKw9LdTaojyQ2bjaUhLB6KGTBowVDd
         A6AO47/SPbI9ctWc6lSTjutWJUWCwQ/PkIxRmEF7l/9Jk3cxMamcxh2svPyOe8g3bT
         bg8YBlIyY7mww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CE978609F5;
        Sat,  6 Feb 2021 03:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: gro: do not keep too many GRO packets in
 napi->rx_list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161258220684.32347.1887314550214837298.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 03:30:06 +0000
References: <20210204213146.4192368-1-eric.dumazet@gmail.com>
In-Reply-To: <20210204213146.4192368-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, jsperbeck@google.com, jianyang@google.com,
        maximmi@mellanox.com, alobakin@dlink.ru, saeedm@mellanox.com,
        ecree@solarflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  4 Feb 2021 13:31:46 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Commit c80794323e82 ("net: Fix packet reordering caused by GRO and
> listified RX cooperation") had the unfortunate effect of adding
> latencies in common workloads.
> 
> Before the patch, GRO packets were immediately passed to
> upper stacks.
> 
> [...]

Here is the summary with links:
  - [net] net: gro: do not keep too many GRO packets in napi->rx_list
    https://git.kernel.org/netdev/net/c/8dc1c444df19

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


