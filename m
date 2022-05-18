Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD36652AFA5
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbiERBKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbiERBKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:10:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C7238BF9
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 18:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA134B81BEA
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 01:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7664EC3411D;
        Wed, 18 May 2022 01:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652836211;
        bh=pbMWDSnTTpXoKczH2vZi8aIUjU6T2J7NW4/8WHeELTU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f1OuEDKf0giytrtr01uAokJwGhDCHhhwzhXI1Tie59+va3Ofp40IftvNzdCAXpAws
         BKciYm/NJMaJ4O5pMU7ozTJDbCxMPbvr5gpAZe1sOulq/KsvUmkcm6yVrFeDmGj87J
         BQkqDokVXz8oDi0q1oKXNtksGB8hBypy7qYfWtg9UUvfxas4j7zhqkRI4EL0W9DMlm
         hEjvCsuI6XE+yoXBkN2SlPlNyGELkTnwLmrrwftYhxf5bAvl87N73ArRPu0DOBYIzA
         w9F+s9dpcYuF4ozOYV05RHxKtT5XSO5Tn5M3tsZGXTeTQWdk1cERb05eH/l8ezPx3m
         FQWecPGvPB15w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60869F03939;
        Wed, 18 May 2022 01:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net-next] dn_route: set rt neigh to blackhole_netdev instead
 of loopback_dev in ifdown
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165283621139.1572.2015185918996203740.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 01:10:11 +0000
References: <0cdf10e5a4af509024f08644919121fb71645bc2.1652751029.git.lucien.xin@gmail.com>
In-Reply-To: <0cdf10e5a4af509024f08644919121fb71645bc2.1652751029.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 16 May 2022 21:30:29 -0400 you wrote:
> Like other places in ipv4/6 dst ifdown, change to use blackhole_netdev
> instead of pernet loopback_dev in dn dst ifdown.
> 
> v1->v2:
>   - remove the improper fixes tag as Eric noticed.
>   - aim at net-next.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net-next] dn_route: set rt neigh to blackhole_netdev instead of loopback_dev in ifdown
    https://git.kernel.org/netdev/net-next/c/9cc341286e99

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


