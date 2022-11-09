Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2310622186
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiKICAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiKICAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2942B271;
        Tue,  8 Nov 2022 18:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12C7DB81CF2;
        Wed,  9 Nov 2022 02:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D821C43146;
        Wed,  9 Nov 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959215;
        bh=QJ6YypR2u2HdYjpAVqsKbMpBbfxRMBx3ONPbuHelp6g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OVT7HdcbxxxHLKdrqENamdZY9CuwyhJe1qXHGbAVGN8hgLxF2SgNEmE+zS3X5xPbL
         CW94olnIxs6fWE+hUw/Yk/y3qMZNXh3NyZjso9g3mOALIYn9lgX9+SViYwWiD2GxtA
         It6Ff7w+majBKw/nht3jxGbCFT9iYe0Hp9tF7j0Sa9ZtYsETZN3ld2ML/Pk3H5M6Jr
         Shl2WAmxukgAUSrHBC6HtJvcO4SdS7q2GuMCy1HMYukojmYaNmS287Ahbn+SR/x6bT
         Eo4J4olSJHaJbF4/41L4p9k6nEqqq42Xhpix2bS4v1BHQUXU4I2vXRKYjS41culVMV
         HFPaEo/ButjtA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 874C9E270CD;
        Wed,  9 Nov 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: renesas: rswitch: Fix endless loop in error
 paths
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166795921555.12027.4687508688577621860.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Nov 2022 02:00:15 +0000
References: <20221107081021.2955122-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20221107081021.2955122-1-yoshihiro.shimoda.uh@renesas.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        keescook+coverity-bot@chromium.org
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

On Mon,  7 Nov 2022 17:10:21 +0900 you wrote:
> Coverity reported that the error path in rswitch_gwca_queue_alloc_skb()
> has an issue to cause endless loop. So, fix the issue by changing
> variables' types from u32 to int. After changed the types,
> rswitch_tx_free() should use rswitch_get_num_cur_queues() to
> calculate number of current queues.
> 
> Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
> Addresses-Coverity-ID: 1527147 ("Control flow issues")
> Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> 
> [...]

Here is the summary with links:
  - net: ethernet: renesas: rswitch: Fix endless loop in error paths
    https://git.kernel.org/netdev/net-next/c/380f9acdf747

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


