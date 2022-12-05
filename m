Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7B96427CD
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiLELuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLELuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:50:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1F514D1E;
        Mon,  5 Dec 2022 03:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98D66B80EF4;
        Mon,  5 Dec 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5630BC433D7;
        Mon,  5 Dec 2022 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670241015;
        bh=DXKDXjr6wXXXvRIZgU4nvDFM/n/s0d0Th6NkDHZDBn8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nCJ2Q+osZhXR30MAe+9R/fxG9WLGAQ3VRzUF7lxyKb4kBICxVAAtF7G7Dtzcw1PIW
         WnpkqxjA2E9YFlvRR9uh0ecDRwAEv+sgs3S68pGP5Hvxa0uqaXUh+cPR495D32AMiZ
         LnPcgJJkmFxBixVXjlEF84X18/aWxPUG/GSOmczvxAiHzrMI881g9iWPjaDlGyC6pY
         zZj7MkVZBndSj7S3mvTXiDlhJ1h5IX+TSUU++/AxxwvWlOaQp2aDeYb4Mvtqnbd5TU
         cMNgWFBduO/LSZnZgjio42jABpgamGfVu76rgeirA0uOGwtmwqBrogPXlo0IzXPrAL
         ucTmri8e2jHfQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33F45E21EFD;
        Mon,  5 Dec 2022 11:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mvneta: Prevent out of bounds read in
 mvneta_config_rss()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167024101520.9380.656886968006446743.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Dec 2022 11:50:15 +0000
References: <Y4nMQuEtuVO+rlQy@kili>
In-Reply-To: <Y4nMQuEtuVO+rlQy@kili>
To:     Dan Carpenter <error27@gmail.com>
Cc:     thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
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

On Fri, 2 Dec 2022 12:58:26 +0300 you wrote:
> The pp->indir[0] value comes from the user.  It is passed to:
> 
> 	if (cpu_online(pp->rxq_def))
> 
> inside the mvneta_percpu_elect() function.  It needs bounds checkeding
> to ensure that it is not beyond the end of the cpu bitmap.
> 
> [...]

Here is the summary with links:
  - [net] net: mvneta: Prevent out of bounds read in mvneta_config_rss()
    https://git.kernel.org/netdev/net/c/e8b4fc13900b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


