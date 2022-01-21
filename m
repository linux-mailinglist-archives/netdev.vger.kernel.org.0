Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373584959A6
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378594AbiAUGAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:00:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50988 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378591AbiAUGAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:00:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BC7D6165F;
        Fri, 21 Jan 2022 06:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A853FC340EB;
        Fri, 21 Jan 2022 06:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642744813;
        bh=OkxqSMomD+eZSwlh0Qt8ft62eBo5XMh8yi1DQLm7R4A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QhjN3CI5wF5D7/9Rbh5m/a/0EeK2n6XGSXINhpcUbK1lnavq1ecZRWCVSMVknIgKI
         Wf38Rv2369+3YcbEyW3Q2HKIS7JZ8wraLw9w6mG5IAdWUO/QXKSki5bK+tOgiDayrD
         FEDwASpstSLygiIVsd8oQEKfpoR/4aImdUB4myRXfY7hyQdcUJoGcHXRmPWOK9tgOZ
         Nx7FyhRTVuVtNs1Kv7xewFVkgQL1ORN2Y67tMmkuK56QXlYL3+rBzAtHWidztWfEOY
         UIngWIL9UPLD0KHI3EniIJZ69XIpwlxXiavE68GX6sOsNMAXlyunaGyzXEMWGv5pKn
         Bx6Jp1jIjSztQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 857A3F6079E;
        Fri, 21 Jan 2022 06:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] netfilter: nf_conntrack_netbios_ns: fix helper module
 alias
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164274481354.1814.13819247077372009518.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Jan 2022 06:00:13 +0000
References: <20220120125212.991271-2-pablo@netfilter.org>
In-Reply-To: <20220120125212.991271-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 20 Jan 2022 13:52:08 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> The helper gets registered as 'netbios-ns', not netbios_ns.
> Intentionally not adding a fixes-tag because i don't want this to go to
> stable. This wasn't noticed for a very long time so no so no need to risk
> regressions.
> 
> [...]

Here is the summary with links:
  - [net,1/5] netfilter: nf_conntrack_netbios_ns: fix helper module alias
    https://git.kernel.org/netdev/net/c/0e906607b9c5
  - [net,2/5] netfilter: nf_tables: remove unused variable
    https://git.kernel.org/netdev/net/c/cf46eacbc156
  - [net,3/5] netfilter: nf_tables: set last expression in register tracking area
    https://git.kernel.org/netdev/net/c/fe75e84a8fe1
  - [net,4/5] netfilter: nft_connlimit: memleak if nf_ct_netns_get() fails
    https://git.kernel.org/netdev/net/c/7d70984a1ad4
  - [net,5/5] netfilter: conntrack: don't increment invalid counter on NF_REPEAT
    https://git.kernel.org/netdev/net/c/830af2eba403

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


