Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201A546ECED
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240944AbhLIQXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:23:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41922 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240929AbhLIQXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:23:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15D2CB82566
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 16:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B98DCC341C7;
        Thu,  9 Dec 2021 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639066809;
        bh=uCJu0+R9955bQNOZd0OHPZpyWYvNhb7PW14xRlrZZ7o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YJxacQNvOOacsKNX53AcCS49ThebUZsnGF+G4gTKezE7o5Jyzw98cQjU+TRNcbI99
         FOwKcmdsP5zyA39MQxgSjmnb8gIwS9mmVzdX2zqI3O6bhIW2dPsN6cWgHhpODolEvW
         WDE5aURKlV9zkpZolCUaBosN46dncPWZJfSS1uOAiFg7OnKOnJf8HM42eS750JH8Wu
         XAaFeSi6ZR9kSlzjJmh7cfgSycU5UwP4JEXbpr2tiIfhmq8tdWpXyKNMbt3W1xTQ6T
         5o8Q6LMolOk7mfFMErfsmznWhIgYTSA0jZ/pafF1ayiW3bT0nr5t0wyqUKwnaQuiI2
         8DlsPSWXDCeuw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9FAB860A3C;
        Thu,  9 Dec 2021 16:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] net: wwan: iosm: bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163906680964.23169.14056577657562493566.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 16:20:09 +0000
References: <20211209101629.2940877-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20211209101629.2940877-1-m.chetan.kumar@linux.intel.com>
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com, linuxwwan@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 15:46:26 +0530 you wrote:
> This patch series brings in IOSM driver bug fixes. Patch details are
> explained below.
> 
> PATCH1:
>  * stop sending unnecessary doorbell in IP tx flow.
> PATCH2:
>  * Restore the IP channel configuration after fw flash.
> PATCH3:
>  * Removed the unnecessary check around control port TX transfer.
> 
> [...]

Here is the summary with links:
  - [net,1/3] net: wwan: iosm: fixes unnecessary doorbell send
    https://git.kernel.org/netdev/net/c/373f121a3c3a
  - [net,2/3] net: wwan: iosm: fixes net interface nonfunctional after fw flash
    https://git.kernel.org/netdev/net/c/07d3f2743dec
  - [net,3/3] net: wwan: iosm: fixes unable to send AT command during mbim tx
    https://git.kernel.org/netdev/net/c/383451ceb078

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


