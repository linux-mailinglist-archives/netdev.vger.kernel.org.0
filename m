Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE5F59F5D8
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 11:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbiHXJB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 05:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbiHXJAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 05:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136974D4DB;
        Wed, 24 Aug 2022 02:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C28C7B8239A;
        Wed, 24 Aug 2022 09:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 887A4C4347C;
        Wed, 24 Aug 2022 09:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661331617;
        bh=DIyDXRMGPEwMbEMkwbMgHVnFxapb2eO9DrJc5leDcUM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t7qQWvkcqBjNwyJLO9ZbCCY5EFkUK8DTaB8aVq4wdKV+7awaXmNot3YLnTqlTFREb
         szz7oFZit93UFTi/ppqoix+UqbgedHuyeRpaoktmCJSc72fqqachnxiX2MqSNwRUSJ
         u4Qms2/PtF+OAqu2rhNezoP/sByBm3GS4P/X2t5ZhLxxf4DQYdWjbhpU8nPFPROQYj
         QSXNzD0GsjGROkeDs2j6vI0R8C1xu53nGn7pFmxPhM8wc3U6KWqTZZqspIjAIZDChB
         t9QUYAPrJ1VucjY3ZsN/Es+ndzvv409+qreA75dHdo+HcN76YUhwdZEtom++4E9FX4
         t0L4xQdaT8qfQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71C81C0C3EC;
        Wed, 24 Aug 2022 09:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 0/3] J7200: CPSW5G: Add support for QSGMII mode to
 am65-cpsw driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166133161746.23661.7556984594416171977.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 09:00:17 +0000
References: <20220822070125.28236-1-s-vadapalli@ti.com>
In-Reply-To: <20220822070125.28236-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        linux@armlinux.org.uk, vladimir.oltean@nxp.com,
        grygorii.strashko@ti.com, vigneshr@ti.com, nsekhar@ti.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com
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

On Mon, 22 Aug 2022 12:31:22 +0530 you wrote:
> Add support for QSGMII mode to am65-cpsw driver.
> 
> Change log:
> 
> v4-> v5:
> 1. Move ti,j7200-cpswxg-nuss compatible to the line above the
>    ti,j721e-cpsw-nuss compatible.
> 2. Add allOf and move if-then statements within it to allow future if-then
>    statements to be added easily.
> 
> [...]

Here is the summary with links:
  - [v5,1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J7200 CPSW5G
    https://git.kernel.org/netdev/net-next/c/d98495169d9f
  - [v5,2/3] net: ethernet: ti: am65-cpsw: Add support for J7200 CPSW5G
    https://git.kernel.org/netdev/net-next/c/37184fc1120e
  - [v5,3/3] net: ethernet: ti: am65-cpsw: Move phy_set_mode_ext() to correct location
    https://git.kernel.org/netdev/net-next/c/763015a794e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


