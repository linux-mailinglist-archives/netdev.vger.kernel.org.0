Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46818484C80
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 03:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237100AbiAECaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 21:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237097AbiAECaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 21:30:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EA2C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 18:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0F8B6164B
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 02:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12B45C36AF7;
        Wed,  5 Jan 2022 02:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641349810;
        bh=OpVXVIpQnIrL6R6R0m/874ExCIvOtxudlOTLMcWW4iw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JxWzgiv7iKfZ3osXt/ZCLnOXdyInMqmbW75qcwfA51mVuuF7I14GC6WkAKXEA/FGf
         cu+tl7vzEU7R7tNYhL0Om1/lrJHLyXOyi8RpMYfPxA0+0HvrLxXqXIRrPvUOjLJgXk
         FWtAQYy7KdUkazkbME2G68kktpIGF1iBZiB5eaefDGPmsutJoGWM8Ko3cQP3oKsihp
         qmO/pT4RV8av0JExu8Y1d5QulR2XlWn4De0PqDutuIokCkdzjLIB00Ws1bLYG/Avv6
         6rBI//A1rcbv/GVz/URyxzHtypsVVWnXzjNSCWwv/NdgtLA1SgpFcf4RbP4MJMfjtO
         lzRfdu4eInE/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2136F79409;
        Wed,  5 Jan 2022 02:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "net: wwan: iosm: Keep device at D0 for
 s2idle case"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164134980998.7326.1651026525434481861.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 02:30:09 +0000
References: <20220104150213.1894-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20220104150213.1894-1-m.chetan.kumar@linux.intel.com>
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com, linuxwwan@intel.com,
        kai.heng.feng@canonical.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Jan 2022 20:32:13 +0530 you wrote:
> Depending on BIOS configuration IOSM driver exchanges
> protocol required for putting device into D3L2 or D3L1.2.
> 
> ipc_pcie_suspend_s2idle() is implemented to put device to D3L1.2.
> 
> This patch forces PCI core know this device should stay at D0.
> - pci_save_state()is expensive since it does a lot of slow PCI
> config reads.
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "net: wwan: iosm: Keep device at D0 for s2idle case"
    https://git.kernel.org/netdev/net-next/c/ffd32ea6b13c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


