Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A270E3AA4DC
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 22:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhFPUCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 16:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231373AbhFPUCK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 16:02:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CFF85613AE;
        Wed, 16 Jun 2021 20:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623873603;
        bh=POmf+WVO9y5O/nN+Wzboim15X/TYvCMspgbWo8n7m2s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=izb90jjhCwoiWfDMuJN5po2vyeUPLHbAyztJ08wCKzoBbeA0K3rmEglMWLQ+bFpyB
         l5++5vYXfdcr99F7KfX1unmXCs+a1yGmK2G+yj0S1VfVjbywI/ckP8qbs7p5Mlb+Mn
         7bex5v4KulWsqdG/TDhciZomdkBvf+9vFjDdYcazKBEqbZAjBjvYzt9/BKUKiwDZ+d
         hSwLIW67b5YPYAQL10JPxljmfMkMomda34NstPTihT3DI156o5FydHDMJjPqasaq/C
         PAaQNh+LERPrveSrHmnYuieI3y/rssIjCsiIY0rmDrqcdkeKYhs9CILk/hs3Gvu4h3
         YXaSnA1/QIa1A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C525F60C29;
        Wed, 16 Jun 2021 20:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: net: use bash to run udpgro_fwd test case
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387360380.18083.6212471705621078321.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 20:00:03 +0000
References: <YMoRV6IOOVhS3nEi@xps-13-7390>
In-Reply-To: <YMoRV6IOOVhS3nEi@xps-13-7390>
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     shuah@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Jun 2021 16:57:27 +0200 you wrote:
> udpgro_fwd.sh contains many bash specific operators ("[[", "local -r"),
> but it's using /bin/sh; in some distro /bin/sh is mapped to /bin/dash,
> that doesn't support such operators.
> 
> Force the test to use /bin/bash explicitly and prevent false positive
> test failures.
> 
> [...]

Here is the summary with links:
  - selftests: net: use bash to run udpgro_fwd test case
    https://git.kernel.org/netdev/net/c/1b29df0e2e80

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


