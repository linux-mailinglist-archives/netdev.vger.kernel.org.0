Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8227F3E12A9
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 12:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbhHEKaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 06:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240337AbhHEKaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 06:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D11A3610A2;
        Thu,  5 Aug 2021 10:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628159405;
        bh=U0Mh9BU99ln86RjZkvjJcfBCeOWHuI286RoN9JQwBIM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KEgXHsGlYRBxBpMHceJJ8aPCm/OHAV5nOWy2pqmJdxBypGwKKO5RpS9wscW2jvhyb
         srCHAeRUC7GxbyE22Qcqudu+SQ6RLKgUGXI7Qob0sAdY8JQxcww+Ma0wZx/b1llIfX
         busUWURu0aPv4H4o+BPepj2BU7WpGTPWfmeSqCnSa9o4XOVgrj16/zqiyNf1tdVLSV
         uu7Cc9do0jm9OyBLDUKBDRrsucW5IzYouwUeyDRrIwF9ugcVNe/MrSkOIs0ggz2PaW
         F5sN8UE/m5h/b26gmJIAggx2bAcxNr9+fQUspPKJl1f1fqA/ca2Sh5gFiTaXnrhgaf
         JMh0o8cxe4Y/A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C409460A72;
        Thu,  5 Aug 2021 10:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/4] net: wwan: iosm: fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162815940579.12505.8844586412472635889.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 10:30:05 +0000
References: <20210804160952.70254-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20210804160952.70254-1-m.chetan.kumar@linux.intel.com>
To:     Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed,  4 Aug 2021 21:39:48 +0530 you wrote:
> This patch series contains IOSM Driver fixes. Below is the patch
> series breakdown.
> 
> PATCH1:
> * Correct the td buffer type casting & format specifier to fix lkp buildbot
> warning.
> 
> [...]

Here is the summary with links:
  - [1/4] net: wwan: iosm: fix lkp buildbot warning
    https://git.kernel.org/netdev/net/c/5a7c1b2a5bb4
  - [2/4] net: wwan: iosm: endianness type correction
    https://git.kernel.org/netdev/net/c/b46c5795d641
  - [3/4] net: wwan: iosm: correct data protocol mask bit
    https://git.kernel.org/netdev/net/c/c98f5220e970
  - [4/4] net: wwan: iosm: fix recursive lock acquire in unregister
    https://git.kernel.org/netdev/net/c/679505baaaab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


