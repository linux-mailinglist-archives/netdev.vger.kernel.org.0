Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACC24334B5
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbhJSLc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:32:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235282AbhJSLcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:32:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6EB5C6137B;
        Tue, 19 Oct 2021 11:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634643042;
        bh=soCLeI73oadsY4+X8UFenzsrsG+rxjOd3vVTfNvF5Mg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X6QYdxlWofJtWy5k2LM0lnUUUtH4KlgdYq3dMwaSVKfvTuxaVBYqtANR0RtoPK23Q
         bUL7/mS28p1HHzD9g5fNKeXkQYUYJqt3qiPDEM+GhE/YIZI5Xh3K0qG9yinvFf4HZb
         Dyooq6GB1Ka1Y6LZiT3x2L9B/ZROKxunYOMgCO1P/pOFdVr5tE5ip0Z+kZocb7kUpu
         hz6Azepems1YzyTQBS6pU20wfaPt6y8GllyAOY3vOEVWCERH2EMoyZsyxcTq73TmVp
         alyvo3JBQF/cUrtaR2R3xr8Kll7mHZzeYy9+k+4xwctnkca0Ipt20AjF6vXM/F9LpV
         ZCxcE7pW/KOHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 68ED9609D7;
        Tue, 19 Oct 2021 11:30:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-10-18
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163464304242.15678.8158973345674766549.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Oct 2021 11:30:42 +0000
References: <20211018212625.2059527-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211018212625.2059527-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, jakub.pawlak@intel.com,
        jan.sokolowski@intel.com, mateusz.palczewski@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 18 Oct 2021 14:26:22 -0700 you wrote:
> Mateusz Palczewski says:
> 
> Use single state machine for driver initialization
> and for service initialized driver. The init state
> machine implemented in init_task() is merged
> into the watchdog_task(). The init_task() function
> is removed.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] iavf: Refactor iavf state machine tracking
    https://git.kernel.org/netdev/net-next/c/45eebd62999d
  - [net-next,2/3] iavf: Add __IAVF_INIT_FAILED state
    https://git.kernel.org/netdev/net-next/c/59756ad6948b
  - [net-next,3/3] iavf: Combine init and watchdog state machines
    https://git.kernel.org/netdev/net-next/c/898ef1cb1cb2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


