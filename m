Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D22534A28
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 07:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345902AbiEZFKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 01:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343609AbiEZFKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 01:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E004BC6EB;
        Wed, 25 May 2022 22:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C188061A28;
        Thu, 26 May 2022 05:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E403DC3411A;
        Thu, 26 May 2022 05:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653541813;
        bh=r1iNoWcRZJU0O8vpO8cGgHs8O1llOLU009J/Sx/Z6eg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gWfeDo+E6vmEmnR58Qz+in5ognrVRoYmGyrz6o+AZ/o6a3mSLshhFxN4Kc+rreGLG
         NAsslmTRXhH7vw1sxlztkLm6ecgdfoNE9WQSXuHRTfc9ii4PeZBzbINBtT4gUHUN+g
         4exq9Djizu21Zn/jNQOV2EDqicr8DSrCCGCx3JeR2gXEeztXV8M1aCJRiIm2dmmrOw
         cUON5dT7hPN0NV+Wx/mrxJSSb44js6qlK77FoOVIRGtAT3ecFTKDcn7r8cGQ3NLB9r
         vpVkYW+Z5g2vZpGbXlLpxVvbLl/rC7/Hhlg7fMtFtIUT8l9hd5+dcq5og6+615Ihr0
         0lFFRDUnKC1Ow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3091F03946;
        Thu, 26 May 2022 05:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: adin: Fix adi,phy-output-clock description
 syntax
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165354181279.23912.8360582385555698481.git-patchwork-notify@kernel.org>
Date:   Thu, 26 May 2022 05:10:12 +0000
References: <6fcef2665a6cd86a021509a84c5956ec2efd93ed.1653401420.git.geert+renesas@glider.be>
In-Reply-To: <6fcef2665a6cd86a021509a84c5956ec2efd93ed.1653401420.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     michael.hennerich@analog.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        alexandru.ardelean@analog.com, josua@solid-run.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 May 2022 16:11:53 +0200 you wrote:
> "make dt_binding_check":
> 
>     Documentation/devicetree/bindings/net/adi,adin.yaml:40:77: [error] syntax error: mapping values are not allowed here (syntax)
> 
> The first line of the description ends with a colon, hence the block
> needs to be marked with a "|".
> 
> [...]

Here is the summary with links:
  - dt-bindings: net: adin: Fix adi,phy-output-clock description syntax
    https://git.kernel.org/netdev/net/c/6c465408a770

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


