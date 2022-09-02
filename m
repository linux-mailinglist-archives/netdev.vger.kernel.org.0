Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BFD5AADBB
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbiIBLc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236124AbiIBLbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:31:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314A22A277;
        Fri,  2 Sep 2022 04:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 613D26209A;
        Fri,  2 Sep 2022 11:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C66C9C433D6;
        Fri,  2 Sep 2022 11:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662118217;
        bh=p56tPFujkhk9sqPkTP10zznYngxLR5f7HLsH03HaYzY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LiPG8H05Iu8lIKQL9SS/RdWdlipBUgpBuDQ0GPxiV+0kOXTdf7/eiEzGU/xdZMEd3
         LVGc+g4kTK/4TcrT27/21BsHaWfJU17NywrM1jEh2B4fiMv8gpGUn3nlZBV+OM6S3D
         TyhjaZt0X0FqRAj+V9pRXL26hoWbsyPtadH3JJwSVhzLXT4+nG36jdCtrdriDfB17A
         uhwMHjbNKEWUBfRffoF4aeS+eW4zJc6CoMSv2u+SuYnkcycKbRhPFZuVCSpVgRTPbh
         vI/LB8Yug8LlaIJGHjBtCLLDNmO9qjxtlBfBv6gJA+4uWPT7tjAMz1mOiXZM5x2nnu
         3xb97sLYxfTqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B0FA0E924D5;
        Fri,  2 Sep 2022 11:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: lan966x: make reset optional
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166211821772.29115.1067348886284578708.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 11:30:17 +0000
References: <20220831111855.1749646-1-michael@walle.cc>
In-Reply-To: <20220831111855.1749646-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, horatiu.vultur@microchip.com,
        UNGLinuxDriver@microchip.com, p.zabel@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Wed, 31 Aug 2022 13:18:53 +0200 you wrote:
> This is the remaining part of the reset rework on the LAN966x targetting
> the netdev tree.
> 
> The former series can be found at:
> https://lore.kernel.org/lkml/20220826115607.1148489-1-michael@walle.cc/
> 
> Michael Walle (2):
>   dt-bindings: net: sparx5: don't require a reset line
>   net: lan966x: make reset optional
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] dt-bindings: net: sparx5: don't require a reset line
    https://git.kernel.org/netdev/net-next/c/baa6a9b59070
  - [net-next,2/2] net: lan966x: make reset optional
    https://git.kernel.org/netdev/net-next/c/f4c1f51cea4e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


