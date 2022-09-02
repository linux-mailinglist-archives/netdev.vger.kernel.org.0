Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E975AA6C8
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 06:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiIBEKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 00:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIBEKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 00:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65942DABA
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 21:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0FE961F6A
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 04:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 171D2C43142;
        Fri,  2 Sep 2022 04:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662091815;
        bh=uQDlbGQT/0I0gPLmYfdu37E9Fgzc71oqHFOZOeJBhwM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F9BJAaYG6igauM0bJ4JuSAMkIzJJ37/8WsIB9KE2mpZrVgWSx7Jlah+GqOuk0WGUG
         i+D0m1nWNoXL7dH1Y3iA3GykAlI81yma6ua6QjJT4hV87SNxnTJ30tZKROvEWrMXp9
         b5TS8BdGnX9nOHnfMazbPaXcSD8ZgDxMuQKz/CtCCzTiloQApN4EFA1Rfrt2soTiY9
         3WYmvKAH7YPtEl1z4KsBf4PlFPVF9hHikIwZCKad05E38zQ2p1HlyYiX9ks1ca5q4r
         J56kr52FO8c/D4Yiw1k0VbR0NYOKz65z8jtkV7PRcUBWgGFIZvy/pqaD9JTxUiU6qV
         mpuQ0/jqXAXBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2DABE924D6;
        Fri,  2 Sep 2022 04:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: tcp: send consistent autoflowlabel in SYN_RECV
 state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166209181498.19149.13471751013086116719.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 04:10:14 +0000
References: <20220831203729.458000-1-eric.dumazet@gmail.com>
In-Reply-To: <20220831203729.458000-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, ncardwell@google.com, edumazet@google.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 Aug 2022 13:37:29 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This is a followup of commit c67b85558ff2 ("ipv6: tcp: send consistent
> autoflowlabel in TIME_WAIT state"), but for SYN_RECV state.
> 
> In some cases, TCP sends a challenge ACK on behalf of a SYN_RECV request.
> WHen this happens, we want to use the flow label that was used when
> the prior SYNACK packet was sent, instead of another one.
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6: tcp: send consistent autoflowlabel in SYN_RECV state
    https://git.kernel.org/netdev/net-next/c/aa51b80e1af4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


