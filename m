Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818C760F65C
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbiJ0Lk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbiJ0LkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9852A3B44D;
        Thu, 27 Oct 2022 04:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42180B825C1;
        Thu, 27 Oct 2022 11:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2BF1C433D7;
        Thu, 27 Oct 2022 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666870815;
        bh=RF8Y5zep0x7rqgzfxQFPqd8WIra/ygMKrhNsxfV1RTQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WVl8EVgZN0s4jNjH5Tj/pQZxm/GFX87VFUfxglOs9BnLSmY1nhojE6HCwRyRjtnUT
         LfCWrV+nBN9A8UfHHqVXxDscWqDL7UIqkrmeT/i8bN4eUp+y/xJYELalaOrJl393Hw
         8jNBKV8DMbij0C/m7qmL0OfN/JBZte90qqc16ppwfmoK1KD4C3ZMfwyCE8B4Sf/MpJ
         eSkzJvVN7E+NNi4XsZDJeHyeefFCxhRk6c6s9BaqZ4Uzext2SwCjbVlEn6qNw/APW7
         ydJyuiee4sdQDnmChMBf27OwVou0X5625IAN8JisbSdpk6WgVx5oOHG6kRcsrDm77c
         kmqd6ZPbfTm2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A1BEAE270D8;
        Thu, 27 Oct 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] eth: fealnx: delete the driver for Myson MTD-800
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166687081565.19214.14130841762810817464.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 11:40:15 +0000
References: <20221025184254.1717982-1-kuba@kernel.org>
In-Reply-To: <20221025184254.1717982-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arnd@arndb.de,
        tsbogend@alpha.franken.de, mpe@ellerman.id.au, npiggin@gmail.com,
        christophe.leroy@csgroup.eu, lukas.bulwahn@gmail.com,
        stephen@networkplumber.org, shayagr@amazon.com, leon@kernel.org,
        mw@semihalf.com, petrm@nvidia.com,
        wsa+renesas@sang-engineering.com, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Oct 2022 11:42:54 -0700 you wrote:
> The git history for this driver seems to be completely
> automated / tree wide changes. I can't find any boards
> or systems which would use this chip. Google search
> shows pictures of towel warmers and no networking products.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] eth: fealnx: delete the driver for Myson MTD-800
    https://git.kernel.org/netdev/net-next/c/d5e2d038dbec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


