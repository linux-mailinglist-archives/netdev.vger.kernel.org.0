Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E1B54F5A2
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381219AbiFQKkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381209AbiFQKkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F50D62CCA
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E813661DEE
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 10:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B71AC3411F;
        Fri, 17 Jun 2022 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655462414;
        bh=9MluRvf1y2kcRSSa3Vj80TuGaHbnQaP7tRaLW7lcBnU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=naexucUpqU9wRn++d3eGDfnrCpPN/MWB5OLHuxVAJRA+82EPVm7F0oJpj6+ZB5P2p
         pP1hMfsE2wHiYaB3NxfgCkNbJDFfJiCBdiOkHHb4Hc7tJvyBM+jIJGyeFTI/21/V2U
         PfntCdDZMmoPuR+Enfu1ET2lgZx3pkbLQmCpd5J7aSY8XZURtqO2sO0N2iVl+zOkjv
         bT/uIOZL8zPDGCHum12VMp7UpTA7iD0n2nHKJKreHuQ25vXOdxra+dqZGwgPmxMk3Y
         A7HXNH9phrxtQhU8wLEed+H2AyFGKnN/jIz213zCTxNguYabBEWhwX28wXFbQZlJfy
         x8G7p1drRtppA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2FD7CE56ADF;
        Fri, 17 Jun 2022 10:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: fix data-race in dev_isalive()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165546241419.18293.16666510229880083317.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 10:40:14 +0000
References: <20220616073434.1511461-1-eric.dumazet@gmail.com>
In-Reply-To: <20220616073434.1511461-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Jun 2022 00:34:34 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> dev_isalive() is called under RTNL or dev_base_lock protection.
> 
> This means that changes to dev->reg_state should be done with both locks held.
> 
> syzbot reported:
> 
> [...]

Here is the summary with links:
  - [net] net: fix data-race in dev_isalive()
    https://git.kernel.org/netdev/net/c/cc26c2661fef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


