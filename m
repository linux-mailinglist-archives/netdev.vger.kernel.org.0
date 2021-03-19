Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29E534274F
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhCSVA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230467AbhCSVAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2084B6197E;
        Fri, 19 Mar 2021 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616187609;
        bh=KE6nic7+eMNfOn1jVk+xhyEA7WjJ2Dnzgo7mwKtEYsM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CNGF8DU70bgizHq1EBQfs3Luzi2ceggsN/4wi9sOHRJnt9eSZ/56eRmdF0oQKMF1c
         MTzz3BhFi+gBFLwgX1xDJdV5MsYoI5daO6qF+Iol9YB+e5HQN+O9B43ezsIuuB0hk3
         UicnbNRvyM51I62tVJIJbwmDSR0FmTdRQ/INiDYnyeQ6saP4IZq6k0Os9taGDLghTO
         wgm/wvsm9L2UxVQPfvT6NhZjx4I8yrJoLuPlY4oH9hTlPLl7fvw8NE1bYqZlsm5WYt
         HI8B5QJmARwL1f3xVcDIhZR+gxOtaKccSh5bVH3L2W9Y6r0bG1Uu1h1C7FAzW0WCVc
         X3RpASa8oBTlA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1266B626EC;
        Fri, 19 Mar 2021 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: forwarding: vxlan_bridge_1d: Fix vxlan ecn
 decapsulate value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618760907.12397.15248883787731266190.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 21:00:09 +0000
References: <20210319143314.2731608-1-liuhangbin@gmail.com>
In-Reply-To: <20210319143314.2731608-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, petrm@mellanox.com,
        idosch@mellanox.com, gnault@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 19 Mar 2021 22:33:14 +0800 you wrote:
> The ECN bit defines ECT(1) = 1, ECT(0) = 2. So inner 0x02 + outer 0x01
> should be inner ECT(0) + outer ECT(1). Based on the description of
> __INET_ECN_decapsulate, the final decapsulate value should be
> ECT(1). So fix the test expect value to 0x01.
> 
> Before the fix:
> TEST: VXLAN: ECN decap: 01/02->0x02                                 [FAIL]
>         Expected to capture 10 packets, got 0.
> 
> [...]

Here is the summary with links:
  - [net] selftests: forwarding: vxlan_bridge_1d: Fix vxlan ecn decapsulate value
    https://git.kernel.org/netdev/net/c/5aa3c334a449

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


