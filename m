Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90040516EC6
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 13:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384820AbiEBLYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 07:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384711AbiEBLXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 07:23:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BFCBD1;
        Mon,  2 May 2022 04:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E224B8163A;
        Mon,  2 May 2022 11:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F13B2C385AF;
        Mon,  2 May 2022 11:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651490413;
        bh=AjGfv3z3/ugF5d5VkVPNqYh1Aq+30ubCMZA+UuDQ1gU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ferKUypJ1oP7KJnIeRK1LKL2dr9cfb/QX9Uo+ijBrVF9cVMRpT03kAY/xkmKtQSMn
         AHCU6hW+Jl8TJp3an8fWEzHV3B1O0dW0IZ27OQMcwRZzxxfqErxQJEqmymKJGQybo/
         8Ljkh73c5tKO3POCtlrU2IemI8TEPMyaTIbwTpATJr221Y1KBoCmhwOCFjyr/RC7Ty
         aFowrtDyXOny78aj11Qq6Mg2iblF+v9NUy5PDyCfNjNcunpCPB7YaJzQWbSM6nVHSu
         DTNAjaia0ipoqPZNsZ3pTo+HLy20eK8KkzKNqoA+Ks1GUZ4x824WHzbn0VhR8AR8T4
         sUpifHdtbnFQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D09F5E6D402;
        Mon,  2 May 2022 11:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/9] dt-bindings: can: renesas,rcar-canfd: Document
 RZ/G2UL support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165149041284.4404.12759253528996620814.git-patchwork-notify@kernel.org>
Date:   Mon, 02 May 2022 11:20:12 +0000
References: <20220502075914.1905039-2-mkl@pengutronix.de>
In-Reply-To: <20220502075914.1905039-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        biju.das.jz@bp.renesas.com, krzysztof.kozlowski@linaro.org,
        geert+renesas@glider.be
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

This series was applied to netdev/net-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Mon,  2 May 2022 09:59:06 +0200 you wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
> 
> Add CANFD binding documentation for Renesas R9A07G043 (RZ/G2UL) SoC.
> 
> Link: https://lore.kernel.org/all/20220423130743.123198-1-biju.das.jz@bp.renesas.com
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] dt-bindings: can: renesas,rcar-canfd: Document RZ/G2UL support
    https://git.kernel.org/netdev/net-next/c/35a78bf20033
  - [net-next,2/9] can: m_can: remove a copy of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/e1cf330fa28a
  - [net-next,3/9] docs: networking: device drivers: can: add ctucanfd to index
    https://git.kernel.org/netdev/net-next/c/5f02ecbe08d6
  - [net-next,4/9] docs: networking: device drivers: can: ctucanfd: update author e-mail
    https://git.kernel.org/netdev/net-next/c/75790ef3b796
  - [net-next,5/9] can: ctucanfd: remove unused including <linux/version.h>
    https://git.kernel.org/netdev/net-next/c/704fd1762045
  - [net-next,6/9] can: ctucanfd: ctucan_platform_probe(): remove unnecessary print function dev_err()
    https://git.kernel.org/netdev/net-next/c/e715d4459485
  - [net-next,7/9] can: ctucanfd: remove inline keyword from local static functions
    https://git.kernel.org/netdev/net-next/c/a51491ac6ed2
  - [net-next,8/9] can: ctucanfd: remove debug statements
    https://git.kernel.org/netdev/net-next/c/e391a0f7be61
  - [net-next,9/9] can: ctucanfd: remove PCI module debug parameters
    https://git.kernel.org/netdev/net-next/c/28b250e070e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


