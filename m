Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2585369B4
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 03:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355497AbiE1Bai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 21:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355540AbiE1BaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 21:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CC2132773;
        Fri, 27 May 2022 18:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F588B8266D;
        Sat, 28 May 2022 01:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3FCAC34114;
        Sat, 28 May 2022 01:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653701413;
        bh=i41YhGqBq9eNSRQxAZMF0GrW8MDdl0IZqfBg+V0ebuQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YVa5GRAnlAVbKMVhYp0nxxdEROvqIAq9gtl/4/f8aXeCJmmRIlVQj0Oug2zKIatgy
         4azN/h0Js+lkKu6kkXoM6wpIxIrZ9/K9wvjckRlBPXu8LuBPFV3CgT3Jm0TRZyjMc9
         T4frUIL3bN8Ayw/mkOgLONvlp59dkX2MZKd60s/zR3+CmvVAkyAquwnBpk4Zs07paF
         pAmFjbbK2mfvkjZP33Lzl0jjzllaMo2aSZWjqTde+QLnd0GJif3BeBkz6MCsZnxDVH
         NsiyZnQy6xopc5ODzeuyDpgy/mwr2Kg4lzHjakOKgl5s6qoQdDP4Qwy9NjIasmrQEg
         cuTkvcKm4swKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4F96EAC081;
        Sat, 28 May 2022 01:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] dt-bindings: net: Update ADIN PHY maintainers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165370141286.14527.15855968807352373650.git-patchwork-notify@kernel.org>
Date:   Sat, 28 May 2022 01:30:12 +0000
References: <20220526141318.77146-1-alexandru.tachici@analog.com>
In-Reply-To: <20220526141318.77146-1-alexandru.tachici@analog.com>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        devicetree@vger.kernel.org, edumazet@google.com,
        geert+renesas@glider.be, geert@linux-m68k.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-kernel@vger.kernel.org,
        michael.hennerich@analog.com
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

On Thu, 26 May 2022 17:13:18 +0300 you wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Update the dt-bindings maintainers section.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  Documentation/devicetree/bindings/net/adi,adin.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] dt-bindings: net: Update ADIN PHY maintainers
    https://git.kernel.org/netdev/net/c/4dc160a52da1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


