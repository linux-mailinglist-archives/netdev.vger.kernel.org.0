Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01EF678FDA
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjAXFaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjAXFaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:30:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA9311653;
        Mon, 23 Jan 2023 21:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1A490CE1397;
        Tue, 24 Jan 2023 05:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CF8CC4339B;
        Tue, 24 Jan 2023 05:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674538216;
        bh=u9veJcozE7PY0d6xyU5g2KdbliwKSBONZLe9x1IFe3U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gUc559U1/TYxKN+gFize3Iw84lnXl2igAVp41Q+w6L+lo/foVciDknvdUuS11OT+J
         MXTLQ0q25noNzaO9/bBPNRTV8dq3wKJgAf0ms7BpIhULML6NJaZPTJpa0SAhFD/ZJV
         xVX0OKoVHC32FM4nxG2/pzdOzUBYOcH0kq3O6iR5pLFEeFF4BuQc77fo6PUOFz+rTc
         DDubC/lQMqKietuCSU2W7/KK/bh4MErweTYhN54FsITynriO6qv3SlCyeFH/9vKOdI
         o8T7aY+9WjgOeTDVeUpU1YHT9svuf7FzAzXsVNi0zEofKGZVbE9RDnwFDcPnGjLNSx
         VG846XJ8Q3Nag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21984E4522B;
        Tue, 24 Jan 2023 05:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: asix,ax88796c: allow SPI peripheral
 properties
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167453821613.25349.16692808522163523181.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 05:30:16 +0000
References: <20230120144329.305655-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230120144329.305655-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     l.stelmach@samsung.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 20 Jan 2023 15:43:29 +0100 you wrote:
> The AX88796C device node on SPI bus can use SPI peripheral properties in
> certain configurations:
> 
>   exynos3250-artik5-eval.dtb: ethernet@0: 'controller-data' does not match any of the regexes: 'pinctrl-[0-9]+'
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> [...]

Here is the summary with links:
  - dt-bindings: net: asix,ax88796c: allow SPI peripheral properties
    https://git.kernel.org/netdev/net-next/c/306f208259ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


