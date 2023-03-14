Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5DE6B86A1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjCNAKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCNAKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717C361888;
        Mon, 13 Mar 2023 17:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0FB361570;
        Tue, 14 Mar 2023 00:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3899FC433EF;
        Tue, 14 Mar 2023 00:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678752618;
        bh=lwSrZHpB/2H3KGj25BHrgbq8Bljm/f9GEWsbt/dHqTI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oKn5ya6t2iobg/GAg+FG4/Ru8R6m48f55SKtsFOueUuCxVCaO+hiJOrYxRmlXJWZk
         TU0ydkcxTJgta69faBgNpx5AyRKOc35Q7SQg9kkTHCAxZXiTVrfl8WBalQYPvYZl2r
         JE+NCQQOlnkmn8oAtJhiFfnUPZkukaauznRO0MWgxxoKNQkknHXdtN/fBsqbKBPRhf
         zeDoyitIfyBicarXLdPYRMHSTwoquxFHFcYUi1W2j0SRQyvSJiO+1h1cqyLuKNsYna
         FNMyJv1zgQlNqiG32erH2pK/s/p10Oc6PdljqVkEPDpurAqqDOW3WEy529x8w2nPrZ
         1Q4OFl41hzFCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C6FEE66CBA;
        Tue, 14 Mar 2023 00:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net 1/2] net: dsa: mt7530: remove now incorrect comment
 regarding port 5
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167875261811.15210.2328160287953861315.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Mar 2023 00:10:18 +0000
References: <20230310073338.5836-1-arinc.unal@arinc9.com>
In-Reply-To: <20230310073338.5836-1-arinc.unal@arinc9.com>
To:     =?utf-8?b?QXLEsW7DpyDDnE5BTCA8YXJpbmM5LnVuYWxAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, dqfext@gmail.com,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com, opensource@vdorst.com,
        rmk+kernel@armlinux.org.uk, arinc.unal@arinc9.com,
        netdev@vger.kernel.org, erkin.bozoglu@xeront.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Mar 2023 10:33:37 +0300 you wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Remove now incorrect comment regarding port 5 as GMAC5. This is supposed to
> be supported since commit 38f790a80560 ("net: dsa: mt7530: Add support for
> port 5") under mt7530_setup_port5().
> 
> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> [...]

Here is the summary with links:
  - [v3,net,1/2] net: dsa: mt7530: remove now incorrect comment regarding port 5
    https://git.kernel.org/netdev/net/c/feb03fd11c56
  - [v3,net,2/2] net: dsa: mt7530: set PLL frequency and trgmii only when trgmii is used
    https://git.kernel.org/netdev/net/c/0b086d76e7b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


