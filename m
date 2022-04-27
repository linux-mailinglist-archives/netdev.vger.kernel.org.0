Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D23510D7B
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 02:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356501AbiD0Axb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 20:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347338AbiD0Ax1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 20:53:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D473311C34
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 17:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDDB0611CD
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23165C385B4;
        Wed, 27 Apr 2022 00:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020612;
        bh=vpDLd3Nnb8oKVr+X8UEooQ+7hydViZByyPDYHHPBfpc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ttTzyV8BOUJvK8ubnnZxVctO4rL5BlWJyE2z4+JKruP0ojuhuLoODnnH4XUuO0gQf
         sHjmvkPKr73DtoKf6ZKKnKfG+mOazO+iuRnfQ9wb1y4D7tZypZoS8jIRl1m/Ozs/fA
         42Fu/EB+USmhGUzzxTy/ljZV6jomfY/x+xTqhKB5qMNPuxt1v62CHlR43ilv5CXaM7
         T//6zS51nSmli4an5vhQhzj2obPZiAMXJwcV2MxhZFSeK80MoNl3+KLuAo+9TN90IG
         d/6VT2klEcZsfXmgb96/XIFbHsikdCMy0BiEr2H1SjD3SR/L0z8r807ruhcEgKyBDp
         50Qf4WPxsSm6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 008F5F03848;
        Wed, 27 Apr 2022 00:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: generalize skb freeing deferral to per-cpu
 lists
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165102061199.18100.7962532951463386947.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 00:50:11 +0000
References: <20220422201237.416238-1-eric.dumazet@gmail.com>
In-Reply-To: <20220422201237.416238-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 22 Apr 2022 13:12:37 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Logic added in commit f35f821935d8 ("tcp: defer skb freeing after socket
> lock is released") helped bulk TCP flows to move the cost of skbs
> frees outside of critical section where socket lock was held.
> 
> But for RPC traffic, or hosts with RFS enabled, the solution is far from
> being ideal.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: generalize skb freeing deferral to per-cpu lists
    https://git.kernel.org/netdev/net-next/c/68822bdf76f1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


