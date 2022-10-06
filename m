Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F085F5FD8
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 06:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiJFEA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 00:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiJFEAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 00:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E685A894;
        Wed,  5 Oct 2022 21:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7644BB81FF1;
        Thu,  6 Oct 2022 04:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DF46C43141;
        Thu,  6 Oct 2022 04:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665028817;
        bh=2o7+0JIT7lCHWuirjo1nk52UnpVL4ZdoD8Gk4AuV/lk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bt8YHyYI6VG1ASx/14odCPjiRLjCfr30I9mXYWhe8A1zjOM8qxCqnCDh+nLZma/ph
         /Kj7XUTsDVZJrZag6b1BHV+kMcUdyvlJXiknSFsyJLYywNrAYtmsUx5gTHaO0qyEde
         PF+VzMNoX06IZGeau9OiW2ZbkCRzErVCywpJQ9EkJcoDYs8JU4jIR5e0yLtx/UHzY7
         RKCtxst7HewVJ7Re02lHOvnoU8zafncTNks0ul0raIvblKuVblKW7eeV1PI+hRnN/p
         8iP+mwZc0D3A8hFCuAnx2Y63MP277d6QoLoeZW6WJ1FIFzgTeRkmo60WtWhSmnMP9e
         RxxJv0Byhhk3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ECB75E524C3;
        Thu,  6 Oct 2022 04:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] net: ethernet: adi: adin1110: Add check in netdev_event
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166502881696.31263.9790847609578437709.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Oct 2022 04:00:16 +0000
References: <20221003111636.54973-1-alexandru.tachici@analog.com>
In-Reply-To: <20221003111636.54973-1-alexandru.tachici@analog.com>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 3 Oct 2022 14:16:36 +0300 you wrote:
> Check whether this driver actually is the intended recipient of
> upper change event.
> 
> Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  drivers/net/ethernet/adi/adin1110.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net-next] net: ethernet: adi: adin1110: Add check in netdev_event
    https://git.kernel.org/netdev/net/c/f93719351b0e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


