Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B73462BFB0
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 14:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238649AbiKPNkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 08:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237831AbiKPNkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 08:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E7C1D652
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 05:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E799761DFF
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 13:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FCA4C43152;
        Wed, 16 Nov 2022 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668606016;
        bh=gabfQ8+RyjpcifIy3p0kiKVnk/v5sjFpzpBJ79SEi4o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EeTilC46oUXUQG3OcZ+vBtz11cov9N2vlmy500F0KGC3gCyvj5CzVLlWNyBzowVMs
         QoajiZFFY2tnKH4df7OCK0MmMS0djieVSwuiaCK9PsRj9qfDSMVC4R3fFA4afSJ+nj
         a0FAPZpE8J/Hcx8rcWZbPecsKYyuD/dtYTsS2HLR89kOCWvt6Jh04eqpKVSwpya1Vm
         JtSrcwBdMNXDmDAdzQQCbef85IMATCvT4tmcOMg7kCP8kWXHQ5kaxwCFxjeAHyXXqg
         axn2xGcDDrprCsywh5Xz0bojtGCi7LV+lTC4hZ/sA42iIAeyXgkYI6r4uMwcFzIcvn
         NNm/YuXGDSJEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2348BC395F6;
        Wed, 16 Nov 2022 13:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: annotate data-race around
 queue->synflood_warned
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166860601613.31330.5882095259483042865.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 13:40:16 +0000
References: <20221115091851.2288237-1-edumazet@google.com>
In-Reply-To: <20221115091851.2288237-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
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

On Tue, 15 Nov 2022 09:18:51 +0000 you wrote:
> Annotate the lockless read of queue->synflood_warned.
> 
> Following xchg() has the needed data-race resolution.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv4/tcp_input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] tcp: annotate data-race around queue->synflood_warned
    https://git.kernel.org/netdev/net-next/c/bf36267e3ad3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


