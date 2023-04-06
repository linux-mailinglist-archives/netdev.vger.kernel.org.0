Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8946D8C44
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbjDFBAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbjDFBAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:00:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D46C76B0;
        Wed,  5 Apr 2023 18:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D510F6427D;
        Thu,  6 Apr 2023 01:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 346A9C4339B;
        Thu,  6 Apr 2023 01:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680742818;
        bh=42PwD0PeaRVSUU+0iaIyIKF/CVnJ88aV4HGLz2EiXYM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=enREYWxVGFluM9Zo/59J3QGCwUPqawB11QtyLgjVuzo2SJy0E2FAKPQalBGBA9hSp
         USzvDT8jrOxg02vPr3gM+bPpQGGYbfpMoGRaWq4KrfpVaHLqEgFZs3ekLedC0GsaAc
         bNOaFl0cst6sQUW6hzjsOX9nNLUuZf1u/JCHDrSqJKs9QYZWXKpV0CU91XLRm0oVyy
         +BAoNZlNsqF0emxoYBLLot2pzNYBfZLigLdB6KG1c6/YhHC8ZEGe85TkgXIdU+9tRl
         /xJGCA1n+Zbe2iRtiIypiuCDABckmU0Mc48oyo64YfFtPQBexOtxXUZVlWyQaBVTCf
         O9RJq8GCrw+eA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18ABDC4167B;
        Thu,  6 Apr 2023 01:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: ethernet-switch: Make
 "#address-cells/#size-cells" required
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168074281809.15345.441924180206481162.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 01:00:18 +0000
References: <20230404204213.635773-1-robh@kernel.org>
In-Reply-To: <20230404204213.635773-1-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        ansuelsmth@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Apr 2023 15:42:13 -0500 you wrote:
> The schema doesn't allow for a single (unaddressed) ethernet port node
> nor does a single port switch make much sense. So if there's always
> multiple child nodes, "#address-cells" and "#size-cells" should be
> required.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> 
> [...]

Here is the summary with links:
  - dt-bindings: net: ethernet-switch: Make "#address-cells/#size-cells" required
    https://git.kernel.org/netdev/net-next/c/c8f1f2e94675

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


