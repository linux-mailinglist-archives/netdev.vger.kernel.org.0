Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98703671E2F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjARNlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjARNkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:40:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C91A2972
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 05:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1DC3B81B05
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22E90C4339E;
        Wed, 18 Jan 2023 13:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674047418;
        bh=iGbPaP6Aeuy8C2KkwZiXw4QyHmrz/J8GRmosp2Lvx04=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lRnVyx+iJRgodD8wiYvvsrJ4G/uY14D7THCtO8McwwnosE1jEZ9XGWO53b2j8BHXR
         IwSO51m/2+UMbN/HvY+QeH6bdfT0vajiq97BNbEDJUsbJe7r3QQh9sJdlxFXPa6Dpe
         u+FwqYAE8XHsq7UcoCXLXTPE2Tr3PErzQS7oXZbq4Nuw5AbK6Upi9o0mJIhO6TsRNo
         wcFvmUghCSA91Rt6ycfZxtFiGIO8fuf2QHvgxJwOWNUymGZ6VG2TdqMXzlLUZMl8K0
         E1y3leiW95yStGZz4lJ5+L8D4DX8ALxX5h6U5idPIrKEA7UbRwZwu3v5lXBxDyJmep
         Ma11p4GRUfZCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4138C73FFC;
        Wed, 18 Jan 2023 13:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ftmac100: handle netdev flags IFF_PROMISC and
 IFF_ALLMULTI
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167404741793.5923.16592974192917646434.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 13:10:17 +0000
References: <20230116182716.302246-1-saproj@gmail.com>
In-Reply-To: <20230116182716.302246-1-saproj@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, vladimir.oltean@nxp.com
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

On Mon, 16 Jan 2023 21:27:16 +0300 you wrote:
> When netdev->flags has IFF_PROMISC or IFF_ALLMULTI, set the
> corresponding bits in the MAC Control Register (MACCR).
> 
> This change is based on code from the ftgmac100 driver, see
> ftgmac100_start_hw() in ftgmac100.c
> 
> Signed-off-by: Sergei Antonov <saproj@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ftmac100: handle netdev flags IFF_PROMISC and IFF_ALLMULTI
    https://git.kernel.org/netdev/net-next/c/75943bc9701b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


