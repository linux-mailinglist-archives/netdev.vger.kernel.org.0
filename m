Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81ADF5BD927
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiITBKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiITBK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:10:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA673ED77;
        Mon, 19 Sep 2022 18:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FD87B822B7;
        Tue, 20 Sep 2022 01:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F087CC43141;
        Tue, 20 Sep 2022 01:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636221;
        bh=07EGYIZem37aOD6C4g6/dH8R2h8ek3SLzRXEZJcQ2wI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VaSPe2qkwOl9/mi+9t5oU7OsiIYCx0w4SgeYPY6UyZWM4dhDqzfh1J3VxmUc05MNv
         U9ehkpHBrRnD+pLjF/Q4ZkzBHQGRVqREuff92UAHwY6jN68iEQWLFv58dxdT+JpwkG
         Mnc9MBjnE2FTsRLwDT9unG3ExpurCQ06UR1RG2WgF0EBU8kkHJqvXVtokJFEC0riin
         OIm01kGKAqH+LjMPiQToVQct55U4kM2lyxJw9oG7B9NtTufX5W8g0rylkxGVijZV4b
         Mm4Y+kjNplFUG8r1DIjTbLHQfsewt4GO9qyMl73bg43xwr3BvRvb37OQlJuu4hIq5a
         UK2pXGLhigv+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D173CE52537;
        Tue, 20 Sep 2022 01:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Remove label = "cpu" from DSA dt-bindings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363622085.23429.2523783707495550803.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:10:20 +0000
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220912175058.280386-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        george.mccollister@gmail.com, kurt@linutronix.de,
        matthias.bgg@gmail.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, linus.walleij@linaro.org,
        alsi@bang-olufsen.dk, clement.leger@bootlin.com,
        arinc.unal@arinc9.com, Landen.Chao@mediatek.com, dqfext@gmail.com,
        sean.wang@mediatek.com, marex@denx.de, john@phrozen.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Sep 2022 20:50:55 +0300 you wrote:
> As explained in more detail in patch 1/3, label = "cpu" is not part of
> DSA's device tree bindings, yet we have some checks in the dt-schema for
> mt7530 which are written as if it was.
> 
> Reformulate those checks, and remove all occurrences of this seemingly
> used, but actually unused, property from the binding examples.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] dt-bindings: net: dsa: mt7530: replace label = "cpu" with proper checks
    https://git.kernel.org/netdev/net-next/c/3f301a280078
  - [net-next,2/3] dt-bindings: net: dsa: mt7530: stop requiring phy-mode on CPU ports
    https://git.kernel.org/netdev/net-next/c/cdd3e486d705
  - [net-next,3/3] dt-bindings: net: dsa: remove label = "cpu" from examples
    https://git.kernel.org/netdev/net-next/c/9cc115d8d6f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


