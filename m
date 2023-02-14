Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDF8696020
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjBNKBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbjBNKAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:00:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627B125E32;
        Tue, 14 Feb 2023 02:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2664B81CCE;
        Tue, 14 Feb 2023 10:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69716C433D2;
        Tue, 14 Feb 2023 10:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676368817;
        bh=lTvtUBadmlpWwQeOZ6L7kfaww5BbsQR2JxusDsIOyjI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jSv6f5pm9a1xkeLXlqsvG8dlShizzQYLUiomQE8DpKvWMhBTuipNd3qOi0dVsx9pp
         h7exnarB8oA433Ak0wLYvBxRgl/xPJvQQVzCrUwctwec03aCTV7wUMGYCcet0apMde
         O7rawfNHakV5gPcVGiJUFO4zUbA3hXfSFEuG48cST6BIY+LCYtGFcFwXdnnes6GgCi
         9fJ4BnZrNa4vKOrrrT+6tmdYbLf4++Y3uZfVpViCE/3EWvj76ipucvMyh4v+GIpHaF
         Hmp3pu7QWdjNOXjT85xCDrOHzDsqON+NtSYleMp2mcGEHis5UVsNUgjjULvPv3ETyB
         gSYH2sIoWwIfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44FAFE68D39;
        Tue, 14 Feb 2023 10:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: dsa: mediatek,mt7530: improve binding
 description
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167636881727.16047.7374583953083530603.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Feb 2023 10:00:17 +0000
References: <20230212131258.47551-1-arinc.unal@arinc9.com>
In-Reply-To: <20230212131258.47551-1-arinc.unal@arinc9.com>
To:     Willem-Jan de Hoog <arinc9.unal@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com, Landen.Chao@mediatek.com,
        dqfext@gmail.com, sean.wang@mediatek.com, arinc.unal@arinc9.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 12 Feb 2023 16:12:58 +0300 you wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Fix inaccurate information about PHY muxing, and merge standalone and
> multi-chip module MT7530 configuration methods.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> [...]

Here is the summary with links:
  - dt-bindings: net: dsa: mediatek,mt7530: improve binding description
    https://git.kernel.org/netdev/net-next/c/a71fad0fd893

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


