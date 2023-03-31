Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6356D2702
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 19:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbjCaRuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 13:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbjCaRuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 13:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7048022223;
        Fri, 31 Mar 2023 10:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0888062AC0;
        Fri, 31 Mar 2023 17:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51ED3C433D2;
        Fri, 31 Mar 2023 17:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680285019;
        bh=Dq+I0U2IazMebXMJy7F8LvzB3HXfZHR01bLczpoHXrA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=six9OycepFHBvUhgBdHhYhxtTHi5Qc/KDSG4PkKZw9EqopJYlv3JWFtHrAmelVssw
         g+d2kCj82Gg1pd4llWnGs0yG5IL1AKBzYzze+RiycbiAd9zWJwug9ncdvfvh+0CIv5
         7l/qaiUw/sdrpzMkrQ2/fCiwqSD3zZRec4LoYk2sYZjC8MdJijZIfdocVMG4HJ2o5q
         nNyIm9DXNkGmOXTxLxiJy3mvSF+x3zUVVLxjxm5TDHCoiunkKnkq/huh4/UXKaPT86
         um6KrB8SGJl49ddQL3ym8rnn2XTXn4xnDP+1EYrlReVj1wYuYYj3b5u3VqWnvKC9yJ
         HV11sEnzI4yLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 261A2C43157;
        Fri, 31 Mar 2023 17:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: fec: add power-domains property
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168028501915.16821.10174110791743243356.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 17:50:19 +0000
References: <20230328061518.1985981-1-peng.fan@oss.nxp.com>
In-Reply-To: <20230328061518.1985981-1-peng.fan@oss.nxp.com>
To:     Peng Fan (OSS) <peng.fan@oss.nxp.com>
Cc:     wei.fang@nxp.com, shenwei.wang@nxp.com, xiaoning.wang@nxp.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        peng.fan@nxp.com
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

On Tue, 28 Mar 2023 14:15:18 +0800 you wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> Add optional power domains property
> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/fsl,fec.yaml | 3 +++
>  1 file changed, 3 insertions(+)

Here is the summary with links:
  - dt-bindings: net: fec: add power-domains property
    https://git.kernel.org/netdev/net-next/c/99b3a769cd8a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


