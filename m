Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229D8587050
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 20:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbiHASUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 14:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiHASUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 14:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44F1EA2;
        Mon,  1 Aug 2022 11:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BBE1611D9;
        Mon,  1 Aug 2022 18:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F1D5C433D7;
        Mon,  1 Aug 2022 18:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659378013;
        bh=6HWYllLmgRs5KqJx5yU+86jW6FFp3/t4drX/nhaRq1E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X9tr+H0K5WedmTT/8uH/PNi5aVhBDDB1sblyEmn/oyUlFrlofFudvMODX6EiF1WT2
         bWkOhHJRxpK3Xz0JsjgKF+dlezdLws5rtKGrUszQ/x+w/hQMavPHx4yj5yROyXLfsB
         vWd+oFfsfJkbt45OZHOhTSczQNcF9MDQFv0qNuOyTSuz+hURJUrOFfc8GTNz5NKYoM
         4PJdzE0UvTs9H0tM9GkOQBHd7UFs7zNtarB/s+pJCf3dOT4iBI9Pas/OhUQJqZGM57
         OkYGE/F1ACjXVn6frxJ8/tv1u+cI0mPTPptND06GkFZ3x4BydYt3BOkE1pazNuY190
         zriGnPabeRIiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86BE7C43143;
        Mon,  1 Aug 2022 18:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V4 0/3] Add the fec node on i.MX8ULP platform
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165937801354.26429.3502205053569932269.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 18:20:13 +0000
References: <20220726143853.23709-1-wei.fang@nxp.com>
In-Reply-To: <20220726143853.23709-1-wei.fang@nxp.com>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        peng.fan@nxp.com, ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Jul 2022 00:38:50 +1000 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> Add the fec node on i.MX8ULP platfroms.
> And enable the fec support on i.MX8ULP EVK boards.
> 
> Wei Fang (3):
>   dt-bindings: net: fsl,fec: Add i.MX8ULP FEC items
>   arm64: dts: imx8ulp: Add the fec support
>   arm64: dts: imx8ulp-evk: Add the fec support
> 
> [...]

Here is the summary with links:
  - [V4,1/3] dt-bindings: net: fsl,fec: Add i.MX8ULP FEC items
    https://git.kernel.org/netdev/net-next/c/ad3564ccc367
  - [V4,2/3] arm64: dts: imx8ulp: Add the fec support
    (no matching commit)
  - [V4,3/3] arm64: dts: imx8ulp-evk: Add the fec support
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


