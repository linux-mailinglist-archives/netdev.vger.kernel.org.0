Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA18634F4F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 06:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbiKWFA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 00:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiKWFAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 00:00:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92782E2B76
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 21:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F07AB81E9B
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 05:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ECE6FC4314A;
        Wed, 23 Nov 2022 05:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179620;
        bh=YQhjGoeHQS0CDc9pIt9Ahl4IVc/2e+gZDTJaANifVo4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gcVkClUGwEivllQs8kB4K40mTR9xtFGJ4tCuHFM/xS2/TtH391N99Y/e/aL9KXZrb
         Ji5PPD25JoYb3nPY8HbU312yehMmrccXdJCPh+rfufA4aWxRy0/lytFYmqMUvJw6Pp
         Dvd0ZX+c5fzHCIk8Koz8XqezUMg8hEWkYio4pp7VrCPE00gGWReJkJE4gfvIEgzUDb
         5UVv17f4IN3dhl3kzpVoYdry/rDIgjMM7m/iau6EUUbO6znUefpD5dVPeTfTon5pWe
         E5v5lL0YEAT/v4ovvu4KczibN0CDK/CZRsEuSxf3GRVkBk/uT0hZj54KSIPdq1LSxN
         DMFvLXEgrEXqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4F2AE50D6E;
        Wed, 23 Nov 2022 05:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/2] net: ethernet: mtk_eth_soc: fix memory leak in
 error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166917961980.4515.18210373992348311213.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 05:00:19 +0000
References: <20221120055259.224555-1-nalanzeyu@gmail.com>
In-Reply-To: <20221120055259.224555-1-nalanzeyu@gmail.com>
To:     Yan Cangang <nalanzeyu@gmail.com>
Cc:     leon@kernel.org, kuba@kernel.org, Mark-MC.Lee@mediatek.com,
        john@phrozen.org, nbd@nbd.name, sean.wang@mediatek.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 20 Nov 2022 13:52:57 +0800 you wrote:
> v1: https://lore.kernel.org/netdev/20221112233239.824389-1-nalanzeyu@gmail.com/T/
> v2:
>   - clean up commit message
>   - new mtk_ppe_deinit() function, call it before calling mtk_mdio_cleanup()
> v3:
>   - split into two patches
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] net: ethernet: mtk_eth_soc: fix resource leak in error path
    https://git.kernel.org/netdev/net/c/8110437e5961
  - [net,v3,2/2] net: ethernet: mtk_eth_soc: fix memory leak in error path
    https://git.kernel.org/netdev/net/c/603ea5e7ffa7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


