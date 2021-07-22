Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC60F3D20E7
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 11:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhGVIti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 04:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231400AbhGVItg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 04:49:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DD7EA61221;
        Thu, 22 Jul 2021 09:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626946205;
        bh=AhFE9wq8tICFXEOqsszLUV9YooTihT5ooV99h8S8hiw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=elNf8ZM9pdWESPtxXcxjZnwGC5l0oDBcMPHknnKUuS8+nhTUD+C6+sDRVCd/499l4
         yNOuI+2MsLx8/PqoJhJdZAI5RTYzYYidMri062oRwTXjr1Bg/k4wxE5xICnbhKJQmR
         bwTrkuIKEN1jOO8wqna7atsz3oc+wsf5cakGbm1ko2zpfu+L3brpvsAmbT/CjzZSxX
         fQW/ZodbGoe20HQKJBdqC9jk4VATJA/BmTpBhePnsPPHjDUixtq9CYGq+sm7axR/qO
         D8UCzfbF5CTxzuk2j3lwCRAl4wEwYfRwUJKPWk+JgYkuFzztfZz0xJrctS0wtm8gEN
         H2gI0K232MQMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D1A4060C09;
        Thu, 22 Jul 2021 09:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] nfp: flower: conntrack offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162694620585.16207.15382665162083590524.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 09:30:05 +0000
References: <20210722075808.10095-1-simon.horman@corigine.com>
In-Reply-To: <20210722075808.10095-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, yinjun.zhang@corigine.com,
        louis.peens@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Jul 2021 09:57:59 +0200 you wrote:
> Louis Peens says:
> 
> This series takes the preparation from previous two series
> and finally creates the structures and control messages
> to offload the conntrack flows to the card. First we
> do a bit of refactoring in the existing functions
> to make them re-usable for the conntrack implementation,
> after which the control messages are compiled and
> transmitted to the card. Lastly we add stats handling
> for the conntrack flows.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] nfp: flower: make the match compilation functions reusable
    https://git.kernel.org/netdev/net-next/c/16416d37f0e7
  - [net-next,2/9] nfp: flower: refactor match functions to take flow_rule as input
    https://git.kernel.org/netdev/net-next/c/4b15fb187688
  - [net-next,3/9] nfp: flower: refactor action offload code slightly
    https://git.kernel.org/netdev/net-next/c/e75dc2650770
  - [net-next,4/9] nfp: flower-ct: calculate required key_layers
    https://git.kernel.org/netdev/net-next/c/71e88cfb9260
  - [net-next,5/9] nfp: flower-ct: compile match sections of flow_payload
    https://git.kernel.org/netdev/net-next/c/5a2b93041646
  - [net-next,6/9] nfp: flower-ct: add actions into flow_pay for offload
    https://git.kernel.org/netdev/net-next/c/d94a63b480c1
  - [net-next,7/9] nfp: flower-ct: add flow_pay to the offload table
    https://git.kernel.org/netdev/net-next/c/453cdc3083a6
  - [net-next,8/9] nfp: flower-ct: add offload calls to the nfp
    https://git.kernel.org/netdev/net-next/c/400a5e5f15a6
  - [net-next,9/9] nfp: flower-tc: add flow stats updates for ct
    https://git.kernel.org/netdev/net-next/c/40c10bd9be3f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


