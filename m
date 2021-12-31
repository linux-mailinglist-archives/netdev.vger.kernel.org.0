Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B9A482188
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 03:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242259AbhLaCaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 21:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242229AbhLaCaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 21:30:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C21C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 18:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF111B81D38
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 02:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9BB98C36AEB;
        Fri, 31 Dec 2021 02:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640917809;
        bh=9cTcKdcwpOoE5YDi7msRL00Gpbkthu8VlG/u6bdaz/M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d8lqFEaGTpd8Uyt2utnSbKnHt1phL7DgGBI9l1bJD4Mz5Y18vlB0+t0uw/w57Ek43
         q07xMw468YrnJzTOQR6vQmfbfKXM7kps7WRkHrF9KW64APL75AI8ggfcdjHmpZS3s0
         0OW6qptr+E7En7zWBPW5zwOq2I9C0lYn4s8HM536mw4ZigSfaOH8axo/Ku1wPJjUZR
         PTQR7etLMnDfhVve3aVmsmhLq8s82+8O1h5fY35atfQIwH58CEQA6m88gYY8YWZs37
         XMt1SJvIgNupzAejCBcKxJ4Qcwj3hApG800ALtuMPb/I5He3JASXwATrehps39BCyj
         2ZdqtugM0/efw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D4DBC395E3;
        Fri, 31 Dec 2021 02:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] net: dsa: bcm_sf2: refactor LED regs access
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164091780950.19399.2794312145648302325.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Dec 2021 02:30:09 +0000
References: <20211229171642.22942-1-zajec5@gmail.com>
In-Reply-To: <20211229171642.22942-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        rafal@milecki.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Dec 2021 18:16:42 +0100 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> 1. Define more regs. Some switches (e.g. BCM4908) have up to 6 regs.
> 2. Add helper for handling non-lineral port <-> reg mappings.
> 3. Add support for 12 B LED reg blocks on BCM4908 (different layout)
> 
> Complete support for LEDs setup will be implemented once Linux receives
> a proper design & implementation for "hardware" LEDs.
> 
> [...]

Here is the summary with links:
  - [V2] net: dsa: bcm_sf2: refactor LED regs access
    https://git.kernel.org/netdev/net-next/c/af30f8eaa8fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


