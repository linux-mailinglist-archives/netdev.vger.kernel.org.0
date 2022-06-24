Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0774C558F94
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 06:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiFXEUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 00:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiFXEUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 00:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A95A4FC6A;
        Thu, 23 Jun 2022 21:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EB38620E3;
        Fri, 24 Jun 2022 04:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62578C341CC;
        Fri, 24 Jun 2022 04:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656044413;
        bh=FhwJzvp4jNVmC9Z/HccWr1dnATRfH+9ZOVhIkS4JuX0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kOoUIwiE6dZRciGdGtFWrtLn+i6IJ+X1FoJS8Dxs7xZtDN48UccFcee7p5YPqrhNp
         Y8rV7WPOT4ok7xokXqxPNSS0Fzf8+idlF5WkHc5p819OHgd/7GNLUyZwTkfcFr+Hyu
         dS1harg/IuFMzSY/+Tj2dTiJ5NY5Wk18ecM2FpntB9ddLVu7Id0DL5oIZlUMOqD6IM
         /KJig2V2zqUAyxEMrUYOQv3fn5W49LaDUXzUwhfseSfl+XFpuuGZK0eGWPm/nKllBg
         PzbBAKgbR2xIPot3El2Ppv9uhe9nFfIKcoPvfkeLyFxcQEu+uvzd/lpjxGVL+jNAXF
         2HP4vwylEb8aA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4759EE8DBDA;
        Fri, 24 Jun 2022 04:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH] net/ncsi: use proper "mellanox" DT vendor prefix
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165604441328.4225.4187173876361139168.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 04:20:13 +0000
References: <20220622115416.7400-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220622115416.7400-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 22 Jun 2022 13:54:16 +0200 you wrote:
> "mlx" Devicetree vendor prefix is not documented and instead "mellanox"
> should be used.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> [...]

Here is the summary with links:
  - [RESEND] net/ncsi: use proper "mellanox" DT vendor prefix
    https://git.kernel.org/netdev/net/c/ad887a507d73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


