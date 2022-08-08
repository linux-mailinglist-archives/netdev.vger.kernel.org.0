Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C28458C5FB
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 12:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242202AbiHHKAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 06:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbiHHKAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 06:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF882AB;
        Mon,  8 Aug 2022 03:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F28C861026;
        Mon,  8 Aug 2022 10:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F780C433D7;
        Mon,  8 Aug 2022 10:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659952813;
        bh=46+/XHJPM1jHiZFHHIjiAfA9oHSmiU6V8kiBFMMGHls=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yv8ta1RritsP71NjAMeuQ7MMzNVtx7vXBxjJSlNsoZ43zEsP/z/4dSAwqOmk5FzDw
         5MKtxHrg5NuhJMKS3Ku8yERW2O/6dlZkM8tmB0Jm+N1wsvvipe51vijQaLA1Cp04vZ
         e3Z/hBoJ2kAG3FInwnub+ckjsASu09/DzmW4jX5zY6W1I1f7sBVC4PTuC+TzaR3bat
         nCDBV0O3G21QWTVRbolq0MwuD9+xJriyCrcIMSUgsg9KUOHhw4IDDb85bM5veE4YyS
         oGRbrnkPRI2uRxIUfYdsMjmdPf2Bgt7TKE0cAog+lI+xEndX4XcZywVsOLOd/WYAWr
         aLMefhVo4cEiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33E63C43140;
        Mon,  8 Aug 2022 10:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bpf: Use the protocol's set_rcvlowat behavior if
 there is one
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165995281320.20342.8222764157601079891.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Aug 2022 10:00:13 +0000
References: <OSZP286MB140479B6DBDB0F13651A55F9959F9@OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM>
In-Reply-To: <OSZP286MB140479B6DBDB0F13651A55F9959F9@OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM>
To:     Feng Gao <gfree.wind@outlook.com>
Cc:     martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, gfree.wind@gmail.com
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

On Thu,  4 Aug 2022 23:04:21 +0800 you wrote:
> From: Gao Feng <gfree.wind@gmail.com>
> 
> The commit d1361840f8c5 ("tcp: fix SO_RCVLOWAT and RCVBUF autotuning")
> add one new (struct proto_ops)->set_rcvlowat method so that a protocol
> can override the default setsockopt(SO_RCVLOWAT) behavior.
> 
> The prior bpf codes don't check and invoke the protos's set_rcvlowat,
> now correct it.
> 
> [...]

Here is the summary with links:
  - [net] net: bpf: Use the protocol's set_rcvlowat behavior if there is one
    https://git.kernel.org/netdev/net/c/f574f7f839fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


