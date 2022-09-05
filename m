Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F005AD1D4
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 13:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiIELuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 07:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiIELuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 07:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA473FA2F
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 04:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DB4AB810F1
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B97FFC4347C;
        Mon,  5 Sep 2022 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662378614;
        bh=W6TgJdn3WjIvkNPzYIELmYc3adwOz/lf/dVjs1GNREI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k39wuCx1r26Bt1RpAvaxFqCg0pyLjv9TvgF52p2icFCPClpREE1/FRouruJc/R60o
         S48v2iDKIKllganaRcfL0EpnEQc6Wo3Mu6PRcHUZrsAmJBziJrKpzeweRoL/5eRucv
         qdYX0QF9LsoCYPGRzdfzOMR1J/S9I/3nCQqlV774OSDQ3NJX8uyeBVX73r8PQOOdSG
         3Ss4ZYy/1rk8HkuO1BgxKVdsrkNZ9OgaxQ004DWdhphJTcZsSaAYQUdM9yh6H1cS4L
         dNlJZ+F3FDm3PzKyqhAgkChl35oL3rY1vssXHKZ3I86KVcKT+dbPFvYYHvqkYRk8us
         xnjeEZsFBy9jA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A3DC4C73FE0;
        Mon,  5 Sep 2022 11:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: remove comment about apparently non-existing
 chip versions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166237861466.7756.5915427131444033129.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 11:50:14 +0000
References: <5c282efc-0734-9153-905c-e54ffbc82f60@gmail.com>
In-Reply-To: <5c282efc-0734-9153-905c-e54ffbc82f60@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 2 Sep 2022 22:21:57 +0200 you wrote:
> It's not clear where these entries came from, and as I wrote in the
> comment: Not even Realtek's r8101 driver knows these chip id's.
> So remove the comment.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 6 ------
>  1 file changed, 6 deletions(-)

Here is the summary with links:
  - [net-next] r8169: remove comment about apparently non-existing chip versions
    https://git.kernel.org/netdev/net-next/c/baa71622cf67

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


