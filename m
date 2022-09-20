Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82645BD922
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiITBKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiITBK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:10:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1754CA28;
        Mon, 19 Sep 2022 18:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49CD3B822B6;
        Tue, 20 Sep 2022 01:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8E1DC433D6;
        Tue, 20 Sep 2022 01:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636220;
        bh=5TMdfKIjL6zFSE6itbf87erfcQY7LCgNjFUrXTvqFKU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z7rH639ogXreEXumqOsuElRk7tF85OGObgqK6EiNf4bnrxeb3azv38Z9ShKs22xe7
         +2qzsWJP/fA9g4bS4Tu9pb3/M8DNVM8rjTRtDeXpq29FqxaRrPdbObovVxmG4ULhXO
         u9BdMKnoXpxG4OWaDeV3AoTZsy+OqhP4bgNSaA0Tma/oh9L+QRGZ+pnPkgOkXKM71L
         sNvNIn0OhnheUIPMx1V8wI7CzB1FAYaIRVWAWScTNu73iSyag8l8ErZ5GR0hS9Tm4Z
         O/m5POTRymAFch4IH19sRDAEJXoHxfhl9jds3BDBZv9mm7U7Nlj+ZaLv+oz20vmeIx
         AHpRG936M6E2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BDC09C43141;
        Tue, 20 Sep 2022 01:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] dt-bindings: net: renesas,etheravb: R-Car Gen4 updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363622077.23429.9768017743524095335.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:10:20 +0000
References: <cover.1662714607.git.geert+renesas@glider.be>
In-Reply-To: <cover.1662714607.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, s.shtylyov@omp.ru,
        sergei.shtylyov@gmail.com, wsa+renesas@sang-engineering.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
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

On Fri,  9 Sep 2022 11:13:21 +0200 you wrote:
> Hi all,
> 
> This patch series contains two updates for the Renesas Ethernet AVB
> Device Tree bindings.
> 
> Thanks!
> 
> [...]

Here is the summary with links:
  - [1/2] dt-bindings: net: renesas,etheravb: R-Car V3U is R-Car Gen4
    https://git.kernel.org/netdev/net-next/c/1bd81d785dfc
  - [2/2] dt-bindings: net: renesas,etheravb: Add r8a779g0 support
    https://git.kernel.org/netdev/net-next/c/231c4f0bcdb2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


