Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E9C52BC01
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237676AbiERNUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237648AbiERNUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8371B1CEB;
        Wed, 18 May 2022 06:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7935D617B2;
        Wed, 18 May 2022 13:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD191C385AA;
        Wed, 18 May 2022 13:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652880011;
        bh=avjbSNidtagzZ6jQAeHx+sCWb/95cHhiJ54aAYjFjCk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fTOPk4OmT4MKgqRVqgxJYXaAR4DJyR23i7hMRBaOfbGm1OENsQYtj9yMf66Br8ams
         2qqk3kSfsyAZJkSBcSk/mkBb2jOXayLqdf30WjeVb+YRHIud08hB2qdLayXlOrEt5D
         hg8yOfbzNs5ckjf4wS73k5cTLXO9AMCIhMBktGdHyeH7Z6h4GgajmvPq6nSGoG0Rk+
         BrSX6pV3Sq/He5iffFIt+Y4k+0CxCtExvKe8hbsj56LsNVdzdnlrhBoOyRxNC72yll
         aZZMNnn46XY0zU4zpYKdleCU7TasJcylF85mB1re1si9YO4pNLBxTPI+X/UP4KpHn8
         Kdtx7rrQ5GJiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B5B7CF0383D;
        Wed, 18 May 2022 13:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: smc911x: Fix min() use in debug code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165288001174.1590.3038393436342538398.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 13:20:11 +0000
References: <ca032d4122fc70d3a56a524e5944a8eff9a329e8.1652864652.git.geert+renesas@glider.be>
In-Reply-To: <ca032d4122fc70d3a56a524e5944a8eff9a329e8.1652864652.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, guozhengkui@vivo.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 18 May 2022 11:04:19 +0200 you wrote:
> If ENABLE_SMC_DEBUG_PKTS=1:
> 
>     drivers/net/ethernet/smsc/smc911x.c: In function ‘smc911x_hardware_send_pkt’:
>     include/linux/minmax.h:20:28: error: comparison of distinct pointer types lacks a cast [-Werror]
>        20 |  (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
> 	  |                            ^~
>     drivers/net/ethernet/smsc/smc911x.c:483:17: note: in expansion of macro ‘min’
>       483 |  PRINT_PKT(buf, min(len, 64));
> 
> [...]

Here is the summary with links:
  - net: smc911x: Fix min() use in debug code
    https://git.kernel.org/netdev/net-next/c/a3641ca416a3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


