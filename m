Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9313B6B0830
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 14:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbjCHNNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 08:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbjCHNNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 08:13:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3028252F59;
        Wed,  8 Mar 2023 05:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34E68B81C9E;
        Wed,  8 Mar 2023 13:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4A8CC433A1;
        Wed,  8 Mar 2023 13:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678281018;
        bh=HDU5RSFrhJRyPeHHGe9PSEO9fpmqEJDVjePgAMyAk7g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bOwDgHThICTR3yhRaANBrsC3Cp8OtkvmOo0my5DgyfeKSRp5BcEbZphH0xzYPFpG/
         htKwOKcYPzaS8TPfgNyGOlpQ3T1R8rzB5pZwvfkC2DfFKfsqUDm9+d0LT9NZvC8mGQ
         K0emFp5cNLZWeNPTEjxvy1PfOQkSTm8MLF/Ybe+E+HJzRtv2FT3xHwJhXIqm81qBad
         eYyFUKlkpAG3BJtxEG/8Mbo6xYllalw68jXMZGqlgOrazXasJEssGxQm0T/MntS9Sn
         OvQ4hoMX57uKoW9st5H2RcBrfKHxuS/mRjE4ljCldz+J+ZTFAIX8nVS8aXod13koPh
         e4fJmk3cyZEvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BAC19E61B61;
        Wed,  8 Mar 2023 13:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] dt-bindings: net: dsa: mediatek,mt7530: change some
 descriptions to literal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167828101875.17807.8617360531349466866.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Mar 2023 13:10:18 +0000
References: <20230307095619.13403-1-arinc.unal@arinc9.com>
In-Reply-To: <20230307095619.13403-1-arinc.unal@arinc9.com>
To:     =?utf-8?b?QXLEsW7DpyDDnE5BTCA8YXJpbmM5LnVuYWxAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com, Landen.Chao@mediatek.com,
        dqfext@gmail.com, sean.wang@mediatek.com, arinc.unal@arinc9.com,
        robh@kernel.org, erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  7 Mar 2023 12:56:19 +0300 you wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The line endings must be preserved on gpio-controller, io-supply, and
> reset-gpios properties to look proper when the YAML file is parsed.
> 
> Currently it's interpreted as a single line when parsed. Change the style
> of the description of these properties to literal style to preserve the
> line endings.
> 
> [...]

Here is the summary with links:
  - [v2] dt-bindings: net: dsa: mediatek,mt7530: change some descriptions to literal
    https://git.kernel.org/netdev/net-next/c/7d8c48917a95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


