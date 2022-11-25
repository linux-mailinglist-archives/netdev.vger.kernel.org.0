Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC83D638500
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 09:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiKYIKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 03:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiKYIKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 03:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6E81CFD6;
        Fri, 25 Nov 2022 00:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD428B82989;
        Fri, 25 Nov 2022 08:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32066C433D7;
        Fri, 25 Nov 2022 08:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669363816;
        bh=nMTcg5K+Uv6UYGq5KcNArulXO64v9nPXRngEXJetdOE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cliHDYzP/6WpbqWTYz/PfV513v22+GONiZ7WHLbU5lFYgs3NoQThRUwioDigAI01r
         Gf0PIdjqrJ+Lf6lZU7D3X7KsHpWVcxYIIFrt9CLTdkg7VBmwZxGJylniwia7aOQAIK
         T/A8IpLonnwxuHw5KFW6O3jHJdPz6DdFStKmQMPLmGA4erL8Ol/vM8moTsFMgEUcxE
         8hfCQgJyYwW+PB/aOo1l+W+QZPcPMEC/w898h8U4SRBquwgJthzqgg+gyTFzcVk/RV
         Y55FN/DwsMZCO8S1Z55hwOO7sV7ckYhMQY07VsLHV1B2kNJu1SigENVlVUEsY4Lw52
         q7KCObdmjj3Qw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1198AE29F3C;
        Fri, 25 Nov 2022 08:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: add Motorcomm YT8531S phy id.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166936381606.2494.8260000718729755967.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 08:10:16 +0000
References: <20221122084232.3886-1-Frank.Sae@motor-comm.com>
In-Reply-To: <20221122084232.3886-1-Frank.Sae@motor-comm.com>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     pgwipeout@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Tue, 22 Nov 2022 16:42:32 +0800 you wrote:
> We added patch for motorcomm.c to support YT8531S. This patch has
> been tested on AM335x platform which has one YT8531S interface
> card and passed all test cases.
> The tested cases indluding: YT8531S UTP function with support of
> 10M/100M/1000M; YT8531S Fiber function with support of 100M/1000M;
> and YT8531S Combo function that supports auto detection of media type.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: add Motorcomm YT8531S phy id.
    https://git.kernel.org/netdev/net-next/c/813abcd98fb1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


