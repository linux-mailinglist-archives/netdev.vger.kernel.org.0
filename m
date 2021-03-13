Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D2233A1B8
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 23:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbhCMWkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 17:40:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233728AbhCMWkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Mar 2021 17:40:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7068664ED6;
        Sat, 13 Mar 2021 22:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615675209;
        bh=KOjdqEridVJsrO9NOj9znay+1g9zcvM0sm24EU/0hY4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j9mRvVeWfCfhPNi900SF2FLjcWhC65luKQIRtVqpANwRoxvx2TqsPiWjAqCypovbr
         sS0CEIRAf6ejRyFYjQkMltVah1YJiwTHYqe+hQdaTr8tByKU5FcGjzYGJYF2Cmr+IB
         rI0PRstbYxfoDka6Y+kChAoJ6rtKJDo8UfUa68wIBbqOOP3B0CPjpUZBvWKFJguy5l
         M++aalX6Q3P7vEmi+WcJBnhAUf9WSqya7oDel6OZFomveGFxdTCFm6csX4RaBzo+uu
         WaqlLzQzVeMERpRFABqQHJD54drE33fodm3pX0weFp4pqnk6r+Cd1BJg6maTdoEWg4
         nio44d81KypBA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6147460A6C;
        Sat, 13 Mar 2021 22:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] batman-adv: Use netif_rx_any_context().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161567520939.31370.1035945046701206897.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Mar 2021 22:40:09 +0000
References: <20210312154724.14980-2-sw@simonwunderlich.de>
In-Reply-To: <20210312154724.14980-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, bigeasy@linutronix.de,
        sven@narfation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Mar 2021 16:47:24 +0100 you wrote:
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> The usage of in_interrupt() in non-core code is phased out. Ideally the
> information of the calling context should be passed by the callers or the
> functions be split as appropriate.
> 
> The attempt to consolidate the code by passing an arguemnt or by
> distangling it failed due lack of knowledge about this driver and because
> the call chains are hard to follow.
> 
> [...]

Here is the summary with links:
  - [1/1] batman-adv: Use netif_rx_any_context().
    https://git.kernel.org/netdev/net-next/c/b1de0f01b011

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


