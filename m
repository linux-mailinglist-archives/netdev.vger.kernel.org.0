Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC2645331
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiLGEuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiLGEuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D40C25EAC
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 20:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D230461A25
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 344B0C4314B;
        Wed,  7 Dec 2022 04:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670388617;
        bh=FvwBOBATcd5hKJ/U3CH4vx2SVxGP67PzTE/WQKj0TuE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oP+Uo60flmHQ0+7U/WzeXRLGC9eYi2ZPplmKV5uabIxuHpt2WG+fHQz7iiargPFnz
         UtUSBjQWsunbkBfMN6OrerMYLsmX8HpxDVSK/uUHMDe3DIKLQs16sGVGQlrokABWGz
         kvLRhhpknkn3mmcqoLXu7wzaPeL4FerPzm+PAM/sk+3w2iVtRQKmIM8H3FTZH1bPLD
         CI9qCcoLA6uuzKw/BnaVFADt+IeuFA6WuwXkPsAq9Ot3Szf4VARk9OdmBMa/6mL9TX
         Nkw4TkIgnETIL06LICRw9E9v4wIkrovXYkublacevxxF2wn5u/EZemLjb2MBFG2EZt
         N5MOVRSJKVmpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1300EE49BBD;
        Wed,  7 Dec 2022 04:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: ethernet: mtk_wed: add reset to
 rx_ring_setup callback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167038861707.25696.6418625611096340423.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 04:50:17 +0000
References: <29c6e7a5469e784406cf3e2920351d1207713d05.1670239984.git.lorenzo@kernel.org>
In-Reply-To: <29c6e7a5469e784406cf3e2920351d1207713d05.1670239984.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        leon@kernel.org, sujuan.chen@mediatek.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  5 Dec 2022 12:34:42 +0100 you wrote:
> This patch adds reset parameter to mtk_wed_rx_ring_setup signature
> in order to align rx_ring_setup callback to tx_ring_setup one introduced
> in 'commit 23dca7a90017 ("net: ethernet: mtk_wed: add reset to
> tx_ring_setup callback")'
> 
> Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: ethernet: mtk_wed: add reset to rx_ring_setup callback
    https://git.kernel.org/netdev/net-next/c/ed883bec679b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


