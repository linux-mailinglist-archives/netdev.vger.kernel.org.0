Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB4D633C7A
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbiKVMaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbiKVMaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E0F5800E;
        Tue, 22 Nov 2022 04:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2EEA6165E;
        Tue, 22 Nov 2022 12:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 258BBC433D6;
        Tue, 22 Nov 2022 12:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669120216;
        bh=PConb+OMZDzF2yYOshF1EXc2IF5ZvEGsAJTxG/Cf7cA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HidIvQ8qT2C4uXv4caQt0QuetMAkQNFoT3pMLca0YO4CWGK4sMvfTxrf/8LWtfJCB
         3UUuo+iXAeKvMb1Icttu6Thvpkgr/6gB66yRoEou1vMJXYTJQT5plhuWh3+R7UXpH+
         x4ed6x7TeoURwULXNLtu4pPDGJvenSpnQi5eug1bIEC5riXEkOVpGxTfSw6kAgrUWN
         p1/Nuzv5A8eFs7ntA0mK29NtqA41Dk7li+hvMppGYy52+3ZnKtsVygAuH8Fp3yfz0F
         JFqhFP/AUmERTy6Xtm+NUKEDGl/n1vluaZjzCT4lQ6UUuDZ278rqdZk08eivuYQGyw
         4qEtLxDF0jz/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 077ABE29F42;
        Tue, 22 Nov 2022 12:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] samples: pktgen: Use "grep -E" instead of "egrep"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166912021602.19490.6125731777868995356.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 12:30:16 +0000
References: <1668826504-32162-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1668826504-32162-1-git-send-email-yangtiezhu@loongson.cn>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, brouer@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 19 Nov 2022 10:55:04 +0800 you wrote:
> The latest version of grep claims the egrep is now obsolete so the build
> now contains warnings that look like:
> 	egrep: warning: egrep is obsolescent; using grep -E
> fix this up by moving the related file to use "grep -E" instead.
> 
>   sed -i "s/egrep/grep -E/g" `grep egrep -rwl samples/pktgen`
> 
> [...]

Here is the summary with links:
  - [net-next] samples: pktgen: Use "grep -E" instead of "egrep"
    https://git.kernel.org/netdev/net-next/c/6dcd6d015220

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


