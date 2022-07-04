Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C62565116
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiGDJkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbiGDJkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07E4264D;
        Mon,  4 Jul 2022 02:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70F6FB80E59;
        Mon,  4 Jul 2022 09:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED378C341CE;
        Mon,  4 Jul 2022 09:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656927615;
        bh=Y/LxjYC6+sy6sNmCCI/ZVHsPGVVHgpq/h/w/n8MQO+A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JxZch3PAR9S6dAg3axe4q6ztushCT0UoXWo62tF1TcFf+t432VTRI8v02fkk/ADWN
         pybWtcDhXrovMuyyUT1f/w5OiJzkLT9RPH2BzK9ihY/2Uxuse0phBNfm7hNK+37cja
         Q1Hr8CjV59gq2WKehiZaykaf/gDFn0mE4KfnLnYjzohyIQvuaFkHxhLwMmM5dq8TXB
         kULyfBnLlkCyhyPPE29j5jzSPmfXbWVJ3kq47zfqNKKqsvFOAhFjrkzuCB2BpTQlY2
         gKwwidCs/OKLaH3nj2pSxADpoNAtHbXY3aFUQSDbnjUb9k1YNMN3ZH37ROYkOv8Yee
         S4VYdS3PbcDNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D13E4E45BDF;
        Mon,  4 Jul 2022 09:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] dt-bindings: net: dsa: renesas,rzn1-a5psw: add
 interrupts description
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165692761485.15750.6574577425084939690.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jul 2022 09:40:14 +0000
References: <20220701175231.6889-1-clement.leger@bootlin.com>
In-Reply-To: <20220701175231.6889-1-clement.leger@bootlin.com>
To:     =?utf-8?b?Q2zDqW1lbnQgTMOpZ2VyIDxjbGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg==?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert@linux-m68k.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, herve.codina@bootlin.com,
        miquel.raynal@bootlin.com, milan.stevanovic@se.com,
        jimmy.lalande@se.com, pascal.eberhard@se.com, robh@kernel.org,
        geert+renesas@glider.be
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  1 Jul 2022 19:52:31 +0200 you wrote:
> Describe the switch interrupts (dlr, switch, prp, hub, pattern) which
> are connected to the GIC.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> [...]

Here is the summary with links:
  - [net-next,v3] dt-bindings: net: dsa: renesas,rzn1-a5psw: add interrupts description
    https://git.kernel.org/netdev/net-next/c/326569cc33b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


