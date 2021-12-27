Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9BD47FC9F
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 13:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbhL0MaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 07:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbhL0MaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 07:30:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490B8C06173E;
        Mon, 27 Dec 2021 04:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B55CECE0FF4;
        Mon, 27 Dec 2021 12:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33FF7C36AE7;
        Mon, 27 Dec 2021 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640608210;
        bh=OJ6prfhyyVzwfIrAvvDPIlzez3h/9MrKXfuEfKXmuN8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aqbpTbwxRovTuLfrbHstFuqbTR1ylsLRFQ9B3DpsOWHTpx8YCcVbYs2Va2G6Oa1uP
         VPTaBoqMO0R+R//6mBYj0864otaTQEWB66AvFKsvY31CbZvDnJvPyVRgEzGsNlfWLZ
         9ks+IPcfF+MJxcxSpvRo8aK66XXnu78m4FLuf+01sTi0onx+289zyAOAo30z4GHvZa
         PC442wIRqaQeJdAgXat/Itc4/f0HexJMcx1qHhQKtyiLPYo/Ud9Xb318k/kGuCy4zF
         cNBsYkFtYZJKRjeJigq2atQ9p1EWS8aZZDe/e4lbYlPL27OYc/OCvPaAcPmAQEuuHl
         VQqIWDnQZTxeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22AAFC395DD;
        Mon, 27 Dec 2021 12:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] net: wwan: iosm: Let PCI core handle PCI power transition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164060821013.30571.10900183755191915748.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Dec 2021 12:30:10 +0000
References: <20211224081914.345292-1-kai.heng.feng@canonical.com>
In-Reply-To: <20211224081914.345292-1-kai.heng.feng@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Dec 2021 16:19:13 +0800 you wrote:
> pci_pm_suspend_noirq() and pci_pm_resume_noirq() already handle power
> transition for system-wide suspend and resume, so it's not necessary to
> do it in the driver.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_pcie.c | 49 ++-------------------------
>  1 file changed, 2 insertions(+), 47 deletions(-)

Here is the summary with links:
  - [1/2] net: wwan: iosm: Let PCI core handle PCI power transition
    https://git.kernel.org/netdev/net-next/c/8f58e29ed7fc
  - [2/2] net: wwan: iosm: Keep device at D0 for s2idle case
    https://git.kernel.org/netdev/net-next/c/f4dd5174e273

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


