Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14AE56BE2C6
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjCQILh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbjCQILM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:11:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF859C4894;
        Fri, 17 Mar 2023 01:10:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C959CB824D8;
        Fri, 17 Mar 2023 08:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BCECC433A4;
        Fri, 17 Mar 2023 08:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679040619;
        bh=j3wRu0uCHe3bhNCOdsobv3Cctl3RkaczI60njzrPvf4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XREYt+aSVJ/MPGxcH5dHJ3iY7iNMf+eEqtS+8dJLtSuS6F8qSdY4XrBLMCc2ztZBa
         27O4MrF8nzFjwE2UtEV6go8gM8KB2AJr43zJk4aX4k77q0D7+kqurUhn7CnJTLvSb7
         VfttbLxxco5FfgyJEk0riZzeJc3siseYjPjDbYK1Of6K+YFNUCxjpVGxn5B+98/Iiy
         of74VjAkfGvhtBhuEzdXFea9LH6qWj//AxrO4Wyl4dhDZvvQJikQSHVy232aYZ96/V
         ifHqU+LGJxMxSDk/7FIlhBApLjknZZt51/FbNOrJZyiw6G0iVbaB9CCmOTRhLnZaas
         p9GVvWQ89ff+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 711BFE66CBF;
        Fri, 17 Mar 2023 08:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Add J784S4 CPSW9G NET Bindings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167904061946.2993.11834380534111579675.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 08:10:19 +0000
References: <20230315075948.1683120-1-s-vadapalli@ti.com>
In-Reply-To: <20230315075948.1683120-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        nsekhar@ti.com, rogerq@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Mar 2023 13:29:46 +0530 you wrote:
> Hello,
> 
> This series cleans up the bindings by reordering the compatibles, followed
> by adding the bindings for CPSW9G instance of CPSW Ethernet Switch on TI's
> J784S4 SoC.
> 
> Siddharth Vadapalli (2):
>   dt-bindings: net: ti: k3-am654-cpsw-nuss: Fix compatible order
>   dt-bindings: net: ti: k3-am654-cpsw-nuss: Add J784S4 CPSW9G support
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] dt-bindings: net: ti: k3-am654-cpsw-nuss: Fix compatible order
    https://git.kernel.org/netdev/net-next/c/40235edeadf5
  - [net-next,2/2] dt-bindings: net: ti: k3-am654-cpsw-nuss: Add J784S4 CPSW9G support
    https://git.kernel.org/netdev/net-next/c/e0c9c2a7dd73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


