Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C24567F66F
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 09:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbjA1Ik0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 03:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbjA1IkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 03:40:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263973347F
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 00:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7394DCE0121
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8334C433D2;
        Sat, 28 Jan 2023 08:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674895217;
        bh=TIACtGo+TzrQDBKq9eHLHFO+E4vBLQ4MsyBUB0wVLWo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ET3PsqeIY/PGzXWeFZntgrj59Vbmc3WcUVMav53FyIUSPoteIAML/BnQwBFJChRiz
         zvbRCcvRn4qrcBFERYy0TOeM3BjYmwDhDY7bgLPhfSQCSkEVJ3/Sw1gpgyOfMJ7NPZ
         TxS3LpvOpAJOHvSIvJcJAJswB7IrxAD1RN5R8AoZ+VgSFCj7T1P28wFwM9kpa1imhi
         DnfIZgW2HSk74l+kGG03qvSJyT5ggLK18sc43r/5516zCvCtO+MbGhPLdIBLlChkle
         ctsQUS37iK7TrNoMzx05+6YvErMh+jpk9pZUhGAfcj7eBcY4xXig4xR02jiB+w9eiM
         7ddbhBWC7NJKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 87DD6E54D2D;
        Sat, 28 Jan 2023 08:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mctp: purge receive queues on sk destruction
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167489521755.20245.6562954815286655255.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 08:40:17 +0000
References: <20230126064551.464468-1-jk@codeconstruct.com.au>
In-Reply-To: <20230126064551.464468-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, matt@codeconstruct.com.au,
        pabeni@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org
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

On Thu, 26 Jan 2023 14:45:51 +0800 you wrote:
> We may have pending skbs in the receive queue when the sk is being
> destroyed; add a destructor to purge the queue.
> 
> MCTP doesn't use the error queue, so only the receive_queue is purged.
> 
> Fixes: 833ef3b91de6 ("mctp: Populate socket implementation")
> Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
> 
> [...]

Here is the summary with links:
  - [net] net: mctp: purge receive queues on sk destruction
    https://git.kernel.org/netdev/net/c/60bd1d9008a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


