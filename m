Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811A55F02B3
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiI3CVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiI3CVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:21:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0F2E7202;
        Thu, 29 Sep 2022 19:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E8A06221B;
        Fri, 30 Sep 2022 02:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4F36C43142;
        Fri, 30 Sep 2022 02:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664504466;
        bh=ueEwZNI3LGnm0spa0UV7x3J2NHzMX38/TS/8V2AKkGw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a75zbWes8dPjQwRmocWdadbZgD/99pxc2Uu64BnD+gNWkZsUsj3g4DbAbcMxiWeaf
         1tWv/aQHTM9m1oB9FOSkNRliziQNoClrj2Ld/Nls5eAvxvuaqjpuYaQoUJGIWK0xYD
         rsRIR3ZrR1u9E2u/FGxj+xmNWvDHmrUc2sBomGzP4gvKj6hdffPgmLjQMwsMD8mf/S
         C7bHxi+XRErRduteOAm1EFy+axBXHGDIjkgjc8ejSxoyDCiqcanBasq1JqynHIVQO/
         EyomuHrXhqwWv4/EDggnGU2hdm3ahUxSWJ+pCbbOa3xG4q1NFCKqLPCsc7rIB+B5J4
         FXxX9BwGG1oGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9FDEAC395DA;
        Fri, 30 Sep 2022 02:21:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: snps,dwmac: Document stmmac-axi-config
 subnode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166450446665.30186.2865460822947348151.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 02:21:06 +0000
References: <20220927012449.698915-1-marex@denx.de>
In-Reply-To: <20220927012449.698915-1-marex@denx.de>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-arm-kernel@lists.infradead.org, alexandre.torgue@foss.st.com,
        davem@davemloft.net, edumazet@google.com, peppe.cavallaro@st.com,
        kuba@kernel.org, joabreu@synopsys.com,
        krzysztof.kozlowski@linaro.org, pabeni@redhat.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 27 Sep 2022 03:24:49 +0200 you wrote:
> The stmmac-axi-config subnode is present in multiple dwmac instance DTs,
> document its content per snps,axi-config property description which is
> a phandle to this subnode.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> ---
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Cc: netdev@vger.kernel.org
> To: linux-arm-kernel@lists.infradead.org
> 
> [...]

Here is the summary with links:
  - dt-bindings: net: snps,dwmac: Document stmmac-axi-config subnode
    https://git.kernel.org/netdev/net-next/c/5361660af6d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


