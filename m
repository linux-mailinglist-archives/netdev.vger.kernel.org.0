Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9074D69C8F4
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjBTKuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjBTKuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162D3125A7;
        Mon, 20 Feb 2023 02:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A88BA60DC6;
        Mon, 20 Feb 2023 10:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08127C4339C;
        Mon, 20 Feb 2023 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676890217;
        bh=yEVhtS6FxR2Kzv7aZMd2KZgZnytjnwM+ed7XvVlAxBY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=noodEMRympV8Qmq3kHZ6ixYqDf/RHsBZ5p1y0WNNoBHLfPe9aL+GX6/soohqzH+cu
         PF+kDqOgtnE639K16vTZKqYcbEdBql9EOf6GtT7071qYknUH3rMB0eo7XLdzeFkA2B
         w0PnaukrK+ih4Vebpo0bczhRjMmlubDwaouN0BCnydxWVvfYA0iQkMcor82TIdB/XJ
         +m4D4LXygKZ6sEEgjV0TYT6m3AmbScotnptGaavUrYD/Cbn/DLRt1PMHPsG6MQrOjl
         +QbqYGhTUoFhPOFZAs1oKJrkiB5boEkDwT5Qezg25eRaCzYt8djSUdfJrEwCejpVw5
         5/oP3hEQKmx7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E2272C43161;
        Mon, 20 Feb 2023 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] sfc: Fix spelling mistake "creationg" -> "creating"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167689021692.13054.14484640120876008010.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 10:50:16 +0000
References: <20230217092528.576105-1-colin.i.king@gmail.com>
In-Reply-To: <20230217092528.576105-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Feb 2023 09:25:28 +0000 you wrote:
> There is a spelling mistake in a pci_warn message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/sfc/efx_devlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] sfc: Fix spelling mistake "creationg" -> "creating"
    https://git.kernel.org/netdev/net-next/c/0d39ad3e1b04

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


