Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A5653BDF6
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 20:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238082AbiFBSU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 14:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237988AbiFBSUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 14:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B160E5DBFD
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 11:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30FDF616BF
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 18:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83477C3411C;
        Thu,  2 Jun 2022 18:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654194014;
        bh=D5RIeejn4YgRvg67JIphd9lReWFGHhQQi4AeaaJqW90=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YePiWmudG7vABqqElSfJvqdbM3BVkTbMYihUZsWT8nqUk2f/4vMqndOnVs0p4+jM5
         jr6ME5Nj8z71rZvOcP7rfzpMd14uIvFIzd+ugicyOg4DvzXWowNUBKjgtP4MU0eLZP
         bI3TAHa8SL4RKkxnpo5Cjcd/b9V3f9WbAKDUc9qHSs/MEc9Fi5aXeVOYF/MIuEagTy
         kUsZd2gn7XOn9SyXK/Xk1bY4Ya5JwmkmMYu6ox5RsjldGdeGyrfcpnTFhwbzrtjdU8
         gop+kyx2ifmfQmEBtbap12t3uubeSpJHLnKpxqaWpQCGBZUsmDck9MVSrg6SLluflM
         rZTrXr04LxzKw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69331F03945;
        Thu,  2 Jun 2022 18:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 0/3] net: af_packet: be careful when expanding mac
 header size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165419401442.24492.16341541730612381725.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Jun 2022 18:20:14 +0000
References: <20220602161859.2546399-1-eric.dumazet@gmail.com>
In-Reply-To: <20220602161859.2546399-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, willemb@google.com, edumazet@google.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  2 Jun 2022 09:18:56 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> A recent regression in af_packet needed a preliminary debug patch,
> which will presumably be useful for next bugs hunting.
> 
> The af_packet fix is to make sure MAC headers are contained in
> skb linear part, as GSO stack requests.
> 
> [...]

Here is the summary with links:
  - [v2,net,1/3] net: CONFIG_DEBUG_NET depends on CONFIG_NET
    https://git.kernel.org/netdev/net/c/eb0b39efb7d9
  - [v2,net,2/3] net: add debug info to __skb_pull()
    https://git.kernel.org/netdev/net/c/22296a5c0cd3
  - [v2,net,3/3] net/af_packet: make sure to pull mac header
    https://git.kernel.org/netdev/net/c/e9d3f80935b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


