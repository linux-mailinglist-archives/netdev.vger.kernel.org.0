Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3809D3B97E7
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 23:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbhGAVCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 17:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232114AbhGAVCf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 17:02:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BE54161402;
        Thu,  1 Jul 2021 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625173204;
        bh=2sG8v97RtOFMgZV5K7unFKwFTNwaFUnDyGQfLtuHp4E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BYBO3PssfqxCFYs0/+iy+2X0rJPKvCfSmUHgXHvIUjb1Y96G8vXr4JL7RTHGKFCHE
         ZStQTgiY9kTy1iJZwAqwBER+g0+LW9l2uUEIslCyrKZkrcnkdztd3BcMnwGRC3qM0t
         wTGQMTfjFdAQ2FJ9E7hPKGyT7xHW6TC+unvWIAnRwrE9FXcbMJ0JOAJqHf+GLbjs2/
         GSAmnGQZQwLSQ3AYvFJwzJVgbdd7u9CLYXCEtZVNO/xOUaPdXpZdjWvqwdB6b/jdHf
         ZoG0I+vtfmiYzxDw3a4R7IScTFXxvUmHliRHTdPYFGLvGtkEHG1QdlOyIMm2TWnuig
         gWtUQxJiv7w3A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ABA63609B2;
        Thu,  1 Jul 2021 21:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] sms911x: DTS fixes and DT binding to json-schema
 conversion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162517320469.16051.953604245859525784.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 21:00:04 +0000
References: <cover.1625140615.git.geert+renesas@glider.be>
In-Reply-To: <cover.1625140615.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        agross@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  1 Jul 2021 14:02:19 +0200 you wrote:
> Hi all,
> 
> This patch series converts the Smart Mixed-Signal Connectivity (SMSC)
> LAN911x/912x Controller Device Tree binding documentation to
> json-schema, after fixing a few issues in DTS files.
> 
> Changed compared to v1[1]:
>   - Dropped applied patches,
>   - Add Reviewed-by,
>   - Drop bogus double quotes in compatible values,
>   - Add comment explaining why "additionalProperties: true" is needed.
> 
> [...]

Here is the summary with links:
  - [v2,1/2] ARM: dts: qcom-apq8060: Correct Ethernet node name and drop bogus irq property
    https://git.kernel.org/netdev/net/c/b6c880103823
  - [v2,2/2] dt-bindings: net: sms911x: Convert to json-schema
    https://git.kernel.org/netdev/net/c/19373d0233d0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


