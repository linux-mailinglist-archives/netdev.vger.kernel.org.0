Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D861528108
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 11:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbiEPJub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 05:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239666AbiEPJuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 05:50:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6245437034;
        Mon, 16 May 2022 02:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2839CB8103F;
        Mon, 16 May 2022 09:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF5E3C3411B;
        Mon, 16 May 2022 09:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652694611;
        bh=K7RtQLBUXvDluU8d53MMK5CuRaFQr50f2uQr8Nl/bgk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TyZVSoJCgbEvCNDNtPeRVIGCnhv8f2wJmGbKsP9ywas6i6RJsftaHtzhVASAA3YVT
         kBt84PaBmDafBZEiCUWpppruXC5ZbHLIC/4k/HU7CfpMOFCKbYsf6hrpSw62CiV8vz
         MEJXFXvcliHkJ3t1tFCYWtYzRJOVpDtzBfKg+Leze1EN3rIIqzDRLxBIn1tuycsMhX
         Jvk4IUyK7ofuSwLneDD3YbMkOEKS4WPzEOZc2S3ulRZm9AY2mU3XOMcczoF1hsj614
         dcgGf6CRn9TaStwsRfFBl7FtIP/wdmkfQ0peyTHDln187mAH4xedjGVS1NjBXmxq9W
         TkbEL2hMcbvGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A408E8DBDA;
        Mon, 16 May 2022 09:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net/smc: align the connect behaviour with TCP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269461162.15960.10529231601090799406.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 09:50:11 +0000
References: <20220513022453.7256-1-guangguan.wang@linux.alibaba.com>
In-Reply-To: <20220513022453.7256-1-guangguan.wang@linux.alibaba.com>
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Fri, 13 May 2022 10:24:53 +0800 you wrote:
> Connect with O_NONBLOCK will not be completed immediately
> and returns -EINPROGRESS. It is possible to use selector/poll
> for completion by selecting the socket for writing. After select
> indicates writability, a second connect function call will return
> 0 to indicate connected successfully as TCP does, but smc returns
> -EISCONN. Use socket state for smc to indicate connect state, which
> can help smc aligning the connect behaviour with TCP.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net/smc: align the connect behaviour with TCP
    https://git.kernel.org/netdev/net-next/c/3aba103006bc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


