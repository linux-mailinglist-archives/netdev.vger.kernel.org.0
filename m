Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A5947CFFE
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 11:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244180AbhLVKaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 05:30:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39500 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244163AbhLVKaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 05:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84919B81054;
        Wed, 22 Dec 2021 10:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44564C36AE8;
        Wed, 22 Dec 2021 10:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640169010;
        bh=d6enVSt23pIXhK+rZx1sR40kWpnw6LTgNRrXNoq46yI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hCmT5lEXIyv2Bdsg7RCMzaDHs6Aav66tjOPQ3kwzW34o1Ay7VkO4rg/Wh6mEF+j43
         impfMSSgXX464uv15xpyMGFT52GydDFI4BvIVR4A+5f5IuFvtdKJUWKb4w58WhH3Vk
         fD6VNEjgo9eKhh56jieFZvaxDV5LiNxIyfGbFlj+7D4x1zW/gpyWLp16P9Dp4WqsK9
         tYTwZl7hwrFFLHI3xdE6Rf+ypdUK1ILqCxb0ChiZ0bmGyIg8ckWROK4w59PxESjQJg
         m8PalqaCllGq1qfpK4PB+e4Q6X5EdyQhWk8AEex1W268kJQvnlFvWjnBYc3ek0A/zi
         U9gJN+oaiMeLQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 23F2960AA5;
        Wed, 22 Dec 2021 10:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers: net: smc911x: Check for error irq
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164016901014.30322.14444262139066973120.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Dec 2021 10:30:10 +0000
References: <20211222074112.1119564-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20211222074112.1119564-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 22 Dec 2021 15:41:12 +0800 you wrote:
> Because platform_get_irq() could fail and return error irq.
> Therefore, it might be better to check it if order to avoid the use of
> error irq.
> 
> Fixes: ae150435b59e ("smsc: Move the SMC (SMSC) drivers")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> [...]

Here is the summary with links:
  - drivers: net: smc911x: Check for error irq
    https://git.kernel.org/netdev/net/c/cb93b3e11d40

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


