Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CC64DA978
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 06:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346524AbiCPFB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 01:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbiCPFB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 01:01:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427304D256
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 22:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1922B81A43
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 05:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99DBEC340F2;
        Wed, 16 Mar 2022 05:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647406810;
        bh=2vjkPDpC/gRbqOp24+KeEgNNXlFZ6moAe5tIglLTU7Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oDVkDqdxD4ES+EPVpj6BQd5jc2UWORIYjedNL9YEWMVBN8hBYLCZEw6sjo0uXcWN5
         RLbwYHh1QCcjKzPhcLwvKLKTZCS6/fzumRuC+7lsMimbkn9e2SI0IjAU8seMaRaAEi
         RgZHfe3XG0TZchxfuctFKrSf4q9GVqN4imJ8UaxIhNS34cF2fc3H6kK02Qs/RpcdA0
         F6Mys5k6B8ebXWRKvKXqrJQRWtAsjpUajLCljGeNHtZxFhyaCxeJMGxtdDi75d+zLh
         wK5qBRVKUoHuGxtXMjEgl7EZ3nnQpW2H8gTD2gWx38b3eytIotcOQSbTRZTRGcKYmd
         reRev3H8Kprrw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A2D6F03841;
        Wed, 16 Mar 2022 05:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sparx5: Use Switchdev fdb events for managing
 fdb entries
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164740681049.10029.15654788172211257147.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Mar 2022 05:00:10 +0000
References: <20220314160918.4rfrrfgmbsf2pxl3@wse-c0155>
In-Reply-To: <20220314160918.4rfrrfgmbsf2pxl3@wse-c0155>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, horatiu.vultur@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 14 Mar 2022 17:09:18 +0100 you wrote:
> Changes the handling of fdb entries to use Switchdev events,
> instead of the previous "sync_bridge" and "sync_port" which
> only run when adding or removing VLANs on the bridge.
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---
>  .../microchip/sparx5/sparx5_mactable.c        | 11 ++-
>  .../ethernet/microchip/sparx5/sparx5_main.h   |  3 +-
>  .../microchip/sparx5/sparx5_switchdev.c       | 91 +++++--------------
>  3 files changed, 33 insertions(+), 72 deletions(-)

Here is the summary with links:
  - [net-next] net: sparx5: Use Switchdev fdb events for managing fdb entries
    https://git.kernel.org/netdev/net-next/c/9f01cfbf2922

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


