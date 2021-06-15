Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344B93A8898
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhFOScL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231176AbhFOScI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 14:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F086F61350;
        Tue, 15 Jun 2021 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623781804;
        bh=D31G+pcYch/hYghXe9+nV66U7HQvnbAM+KC0HFoyOcU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RcyD2jyK5fSkqmRumQLt5Wz2zQaRckcb02LX8sBziCqm891Lux9MNaU476/8vDW1g
         W0hoSbyUaL/c2H9T8OEjD1COvJlh5e1uBOZfC3DNYe0WwKrNttQ1L0NkO+zlHis8uB
         j8ZY2UKBJuKsEJxxSUxVlftlSvuWVl9LHP9LtRSsa4vf7vyl24ZGOE9lunyojEnWqO
         Nkc0sGTUwL3sJ9sqStwdLDc7QpaZ2up9fM7UuOguZZnQccuztCtOjEmJLhXL56C199
         TUM1c0oibZyLpsRtto5kZWK1kmkomdBVAKOE24FPkee4IIdisr2K56QmxlwR0kyuky
         /t1kz1miMWobA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EBE1460A0A;
        Tue, 15 Jun 2021 18:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bonding: Use per-cpu rr_tx_counter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162378180396.31286.17862920262609101179.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Jun 2021 18:30:03 +0000
References: <20210615085415.1696103-1-joamaki@gmail.com>
In-Reply-To: <20210615085415.1696103-1-joamaki@gmail.com>
To:     Jussi Maki <joamaki@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Jun 2021 08:54:15 +0000 you wrote:
> The round-robin rr_tx_counter was shared across CPUs leading to
> significant cache thrashing at high packet rates. This patch switches
> the round-robin packet counter to use a per-cpu variable to decide
> the destination slave.
> 
> On a test with 2x100Gbit ICE nic with pktgen_sample_04_many_flows.sh
> (-s 64 -t 32) the tx rate was 19.6Mpps before and 22.3Mpps after
> this patch.
> 
> [...]

Here is the summary with links:
  - [net-next] net: bonding: Use per-cpu rr_tx_counter
    https://git.kernel.org/netdev/net-next/c/848ca9182a7d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


