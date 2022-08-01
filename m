Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06085872F0
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 23:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbiHAVPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 17:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiHAVPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 17:15:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B06E22;
        Mon,  1 Aug 2022 14:15:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5571B81722;
        Mon,  1 Aug 2022 21:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9964BC433D6;
        Mon,  1 Aug 2022 21:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659388546;
        bh=8CHl3MXm6TyorcFsGdIMsPD4XhETDWiwvWiFw3lx/Uc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S7h12Wx3Gu1bVi5lIAeaFGZUURYNDOgbqorU12PT1ytdGOtb5nuYt/bMmxUV7w6bd
         d+/tH63wAzogYR4nGqkfmDw7sngOs4rZzE7ysH/EPHrKQzrgp1n4fuey5YxnmK/fbQ
         0fbRBk8tRl0wtiRSGp7n8mmCM7LJAT3xcN25dPp2S270d845yyJvpWywf8q96dDKwX
         RHRViLc2bcTQeL4JNLZwpGesRNM30YtsTTAbNLwEiUJmTxad/CRCZV7Jul9Yt+HFRJ
         R/hKTVhr3C0qwjOMSL0VpuJj+ZbDIgotyd9IErXhYgYaMEsUEr7ViGAVXU7ENLK+vb
         8VxCd9WckNuZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C304C43142;
        Mon,  1 Aug 2022 21:15:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2022-07-26:
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165938854650.17345.7668424614098862889.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 21:15:46 +0000
References: <20220726221328.423714-1-luiz.dentz@gmail.com>
In-Reply-To: <20220726221328.423714-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to bluetooth/bluetooth-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Jul 2022 15:13:28 -0700 you wrote:
> The following changes since commit 9b134b1694ec8926926ba6b7b80884ea829245a0:
> 
>   bridge: Do not send empty IFLA_AF_SPEC attribute (2022-07-26 15:35:53 +0200)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-07-26
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2022-07-26:
    https://git.kernel.org/bluetooth/bluetooth-next/c/e53f52939731

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


