Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962FF62F293
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 11:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241576AbiKRKaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 05:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241597AbiKRKaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 05:30:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1D72716F
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 02:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04D98B822ED
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 10:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A35A4C433D7;
        Fri, 18 Nov 2022 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668767415;
        bh=KQbLnIYHW9SWQVsKyEQq/AL+Ytggd6ShcwjfBZ7HWfs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZJ+01S13lcGTUhNhUw96ZjRQMJ92+06LioJSeGFUTLCYjiX8gIS3RohI4WqEg/xwm
         cOyJyL7EazyObak+kcoaJbqA0QAR3sAlXQD5bUbAsBm8+ZlxQh19SqEigmJyZ6hUFq
         Vmti2UAUibYnsWloH/NYBv4koLXCqd7SCxUE0rAvOBkDIUdOzep7vuAibi3+ooNYfy
         Xqa5q4qpOyC8dqu1VVt2242PVoKZK40b7XQoNWDxtbK4W/JzfXLWPHNAU5Otb64Ynb
         07483vcAAOYwlcZp+gVESyZvuUry+7Z2JMMiqCiserdH2EP8ur7RHZxdYdbJOZBrWE
         /1eITU7zgH3oA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 899E5E29F43;
        Fri, 18 Nov 2022 10:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: liquidio: simplify if expression
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166876741555.29065.13537691084613116282.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 10:30:15 +0000
References: <9845cbd62721437f946035669381a9719240fc89.1668533583.git.leonro@nvidia.com>
In-Reply-To: <9845cbd62721437f946035669381a9719240fc89.1668533583.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        dchickles@marvell.com, edumazet@google.com, fmanlunas@marvell.com,
        lkp@intel.com, netdev@vger.kernel.org, pabeni@redhat.com,
        sburla@marvell.com, shaozhengchao@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 15 Nov 2022 19:34:39 +0200 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Fix the warning reported by kbuild:
> 
> cocci warnings: (new ones prefixed by >>)
> >> drivers/net/ethernet/cavium/liquidio/lio_main.c:1797:54-56: WARNING !A || A && B is equivalent to !A || B
>    drivers/net/ethernet/cavium/liquidio/lio_main.c:1827:54-56: WARNING !A || A && B is equivalent to !A || B
> 
> [...]

Here is the summary with links:
  - [net] net: liquidio: simplify if expression
    https://git.kernel.org/netdev/net/c/733d4bbf9514

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


