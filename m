Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6291456E05
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbhKSLN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:13:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235009AbhKSLNZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 06:13:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D4B6A61547;
        Fri, 19 Nov 2021 11:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637320223;
        bh=pPFYim4UOfeJciW4C3LfDndYjhsOkGHBJkPBwEdqjcA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=srb1dGULReqP+xFEevIAa1ogEcR/ALiNfb2Mhrwag4OcYBc73M+gZw1meZqiCFuj/
         0IqmcBGPUYUGn+CLKBjCRP0PrivdF2KkIHXSKxSt0871+TJpP+Hrcipq5zoK4U2oN6
         ucyEWHvFxeUFx6XbCJuIz8wyIE+5GJZjODmYN+XbVGA6zzzLh/QJAgzQXfCzU4wkUw
         qxLvTiRdJcajH75YsgQ6UqAGo4F5zvo6ElCcZZzYpsWpMdna2VRjZdzFd4809+dVeZ
         0F2yYgySidUwbg5gZaix3QraeBUa36Q6wE8i5kVXS5lu8D09NoraZFD4b3HtV3+VPB
         UG2GAJn+pIT1Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CF3D760977;
        Fri, 19 Nov 2021 11:10:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/11] selftests: netfilter: add a vrf+conntrack testcase
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732022384.23424.5821789807519736618.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 11:10:23 +0000
References: <20211118222618.433273-2-pablo@netfilter.org>
In-Reply-To: <20211118222618.433273-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 18 Nov 2021 23:26:08 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Rework the reproducer for the vrf+conntrack regression reported
> by Eugene into a selftest and also add a test for ip masquerading
> that Lahav fixed recently.
> 
> With net or net-next tree, the first test fails and the latter
> two pass.
> 
> [...]

Here is the summary with links:
  - [net,01/11] selftests: netfilter: add a vrf+conntrack testcase
    https://git.kernel.org/netdev/net/c/33b8aad21ac1
  - [net,02/11] selftests: netfilter: extend nfqueue tests to cover vrf device
    https://git.kernel.org/netdev/net/c/228c3fa054ad
  - [net,03/11] netfilter: nft_payload: Remove duplicated include in nft_payload.c
    https://git.kernel.org/netdev/net/c/00d8b83725e9
  - [net,04/11] selftests: nft_nat: Improve port shadow test stability
    https://git.kernel.org/netdev/net/c/e1f8bc06e497
  - [net,05/11] selftests: nft_nat: Simplify port shadow notrack test
    https://git.kernel.org/netdev/net/c/85c0c8b342e8
  - [net,06/11] netfilter: ctnetlink: fix filtering with CTA_TUPLE_REPLY
    https://git.kernel.org/netdev/net/c/ad81d4daf6a3
  - [net,07/11] netfilter: ctnetlink: do not erase error code with EINVAL
    https://git.kernel.org/netdev/net/c/77522ff02f33
  - [net,08/11] netfilter: ipvs: Fix reuse connection if RS weight is 0
    https://git.kernel.org/netdev/net/c/c95c07836fa4
  - [net,09/11] netfilter: xt_IDLETIMER: replace snprintf in show functions with sysfs_emit
    https://git.kernel.org/netdev/net/c/c08d3286caf1
  - [net,10/11] netfilter: flowtable: fix IPv6 tunnel addr match
    https://git.kernel.org/netdev/net/c/39f6eed4cb20
  - [net,11/11] selftests: nft_nat: switch port shadow test cases to socat
    https://git.kernel.org/netdev/net/c/a2acf0c0e2da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


