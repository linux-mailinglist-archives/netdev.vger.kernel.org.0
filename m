Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEFE8698C32
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 06:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjBPFkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 00:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjBPFkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 00:40:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE161A940;
        Wed, 15 Feb 2023 21:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1BD86CE290A;
        Thu, 16 Feb 2023 05:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2ED0BC4339C;
        Thu, 16 Feb 2023 05:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676526018;
        bh=QhOv2y9XRsJs0byJc6XeAvQzSdln+PXDBsqhD2FkRXE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bxTqOdAD8gU1b7TH++RQyINtP3JqzghARulIXGPQfpniGjfTg5tbWOSg0im/WpdSK
         liH/aQ12baLeKXCTUt9oAvW80Rd67t4ig8OpahMkvVIkzwGxk1z0u+KzQi8EmyGADP
         duk3SS5AYqZzC36CNfiSgqW9S6QdpHYSSRq20iqJ0mdFpkymcm+rzBx8uGGOmWRcEH
         y3rv/Zv+w8E6y3CqK0rom/HGVctsCvKGJlYnZ3hKK5+QGDAb2KNCXyZliQw1PBlIQP
         mKE+J2GUi+CzsEAROaxKHZDJMwXjcOSMQ97Ik6PWjpLAbX4S3IIvNGfbRNBbFUzZUj
         OMo8m68D+Z/ZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0B653E21EC4;
        Thu, 16 Feb 2023 05:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] dt-bindings: net: snps,dwmac: Fix snps,reset-delays-us
 dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167652601803.11549.5242243421394636673.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 05:40:18 +0000
References: <20230214171505.224602-1-ahalaney@redhat.com>
In-Reply-To: <20230214171505.224602-1-ahalaney@redhat.com>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     devicetree@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com,
        alexandre.torgue@foss.st.com, peppe.cavallaro@st.com,
        joabreu@synopsys.com, mripard@kernel.org, shenwei.wang@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski@linaro.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Feb 2023 11:15:04 -0600 you wrote:
> The schema had snps,reset-delay-us as dependent on snps,reset-gpio. The
> actual property is called snps,reset-delays-us, so fix this to catch any
> devicetree defining snsps,reset-delays-us without snps,reset-gpio.
> 
> Fixes: 7db3545aef5f ("dt-bindings: net: stmmac: Convert the binding to a schemas")
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
> 
> [...]

Here is the summary with links:
  - [v2,1/2] dt-bindings: net: snps,dwmac: Fix snps,reset-delays-us dependency
    https://git.kernel.org/netdev/net-next/c/affb6a3fd8f4
  - [v2,2/2] arm64: dts: imx8dxl-evk: Fix eqos phy reset gpio
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


