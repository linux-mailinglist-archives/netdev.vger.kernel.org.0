Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAF563C60E
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236582AbiK2RDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236454AbiK2RCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:02:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3376DCD9;
        Tue, 29 Nov 2022 09:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCB44B817B0;
        Tue, 29 Nov 2022 17:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69FBDC43149;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669741218;
        bh=Z/6MUHT6UVocmS5c/b5KTcD52w2K0v1WxpXiJsIrsQw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DM5tz1JG5cuO9lCybHaNnpOAYfIO/DdlRlj6evMohFCJ6ZQTgvTP6mHv5hxvobpSc
         LnYziJ5WHMVPPUqPyxksTzwTfy8Qe4PLpBRubA6S+9+VRkgXVi96JQyJBNUetpzPa1
         PVLo9rTvf92axzIJ+o4K/NDVbU0FbfxD24JvhFGbg0RqJAVSAaJkIKRWf5Ycm6Zhun
         1165u9OHKruzcWAJkbMuxLVx5sWFF07KQ1mYXZWPxXEcVVVuk7G3nqE12iVGBKnYqM
         nRd2JN4DfJtN4WAnL/R42O9CsgTeVeYBISmemhB8HKU3kDKdiJgue9uTpv5F9bORyr
         jrc1nmGjDKBWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4BB35E50D67;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: renesas: ravb: Fix promiscuous mode after
 system resumed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166974121830.7750.2703244123651337985.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 17:00:18 +0000
References: <20221128065604.1864391-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20221128065604.1864391-1-yoshihiro.shimoda.uh@renesas.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tho.vu.wh@renesas.com
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

On Mon, 28 Nov 2022 15:56:04 +0900 you wrote:
> After system resumed on some environment board, the promiscuous mode
> is disabled because the SoC turned off. So, call ravb_set_rx_mode() in
> the ravb_resume() to fix the issue.
> 
> Reported-by: Tho Vu <tho.vu.wh@renesas.com>
> Fixes: 0184165b2f42 ("ravb: add sleep PM suspend/resume support")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed
    https://git.kernel.org/netdev/net/c/d66233a312ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


