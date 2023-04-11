Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979B56DCF77
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 03:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjDKBkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 21:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjDKBkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 21:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DE410FC;
        Mon, 10 Apr 2023 18:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FDD361888;
        Tue, 11 Apr 2023 01:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65595C433D2;
        Tue, 11 Apr 2023 01:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681177219;
        bh=Phhd3b5xzdZAq0qYVQ0j7I4tVQEDlwELHRNYYxVGzQ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rFQz5u8numU+VO3K8uAIuwctXgTPHOcbX/too+33oIYjjIuOyL97mMo5stgHxhCZ4
         pNXeWJYG23z0+YyqALum1JYA1dTtlcd/rmmsFkSuWwSLoy7yzeJsTWtTbxkhWIM4LV
         VHuWDqHg+T18W6fyInmm9IQ5UfAvQGaWUyihXD6F32ewefWpUTDbdBUn0roQ4h909B
         jiPnmyXMaNSLRFsACFmKPVzr4YoqTjt5V+E1OuhAsm3FXsUpr6ceguFHtE+/fgh2Qk
         gk0aHfbMDays/4hagH3BcjMKYYJDzF5OYxGKonzm0rn0wFG90mume4WiPy9ybtrp24
         /8BmdLaaal2hQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47E1CC395C5;
        Tue, 11 Apr 2023 01:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: ethernet: mtk_eth_soc: use be32 type to
 store be32 values
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168117721928.17236.15670103612054656296.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Apr 2023 01:40:19 +0000
References: <20230401-mtk_eth_soc-sparse-v2-1-963becba3cb7@kernel.org>
In-Reply-To: <20230401-mtk_eth_soc-sparse-v2-1-963becba3cb7@kernel.org>
To:     Simon Horman <horms@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo@kernel.org, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 07 Apr 2023 15:26:51 +0200 you wrote:
> n_addr is used to store be32 values,
> so a sparse-friendly array of be32 to store these values.
> 
> Flagged by sparse:
>   .../mtk_ppe_debugfs.c:59:27: warning: incorrect type in assignment (different base types)
>   .../mtk_ppe_debugfs.c:59:27:    expected unsigned int
>   .../mtk_ppe_debugfs.c:59:27:    got restricted __be32 [usertype]
>   .../mtk_ppe_debugfs.c:161:46: warning: cast to restricted __be16
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: ethernet: mtk_eth_soc: use be32 type to store be32 values
    https://git.kernel.org/netdev/net-next/c/9bc11460bea7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


