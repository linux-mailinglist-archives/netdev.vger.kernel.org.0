Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B426BE4C2
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 10:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjCQJCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 05:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbjCQJCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 05:02:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D83E41CB
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 02:00:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7EC86223A
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24997C4339C;
        Fri, 17 Mar 2023 09:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679043622;
        bh=8fP8URfn+w2r5iqipHI7dWWqfEgZYl4uxcyxNLXax7Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tEZjmw5GM+Fi7hCD4hiZhuHIH6Evav04uhb3LjmcBdb4iDlh8FnbyK5/kjt8eSFHB
         R3PBEgq2EC01J39u80+sXVODDZVXWTldq7oG+cVAmHlMwbFeigQR9WAgk7LHRuE69O
         V7Dk8LT4KzqPFrMNXixJWwCmK4VgOHCJMgPkp2TbwsIXkAOYxygGVvYrhf3GyVTMCM
         bta7l8bC1PDg0WW5q6pyrErg4pVQU9HQ5WNG3juiCajVLFMdc9UpFJez6e5sZbHpk7
         iyZN+RGqMkxyQPPB73PUC9qYUsZ1ziTycvwk3qTeJRQzT6WrvfgnbpR0eI14LARsk4
         waso9zMTAnxaw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A732E2A03A;
        Fri, 17 Mar 2023 09:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] net/packet: KCSAN awareness
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167904362203.30854.1241906989916128506.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 09:00:22 +0000
References: <20230316011014.992179-1-edumazet@google.com>
In-Reply-To: <20230316011014.992179-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, willemb@google.com, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Mar 2023 01:10:05 +0000 you wrote:
> This series is based on one syzbot report [1]
> 
> Seven 'flags/booleans' are converted to atomic bit variant.
> 
> po->xmit and po->tp_tstamp accesses get annotations.
> 
> [1]
> BUG: KCSAN: data-race in packet_rcv / packet_setsockopt
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net/packet: annotate accesses to po->xmit
    https://git.kernel.org/netdev/net-next/c/b9d83ab8a708
  - [net-next,2/9] net/packet: convert po->origdev to an atomic flag
    https://git.kernel.org/netdev/net-next/c/ee5675ecdf7a
  - [net-next,3/9] net/packet: convert po->auxdata to an atomic flag
    https://git.kernel.org/netdev/net-next/c/fd53c297aa7b
  - [net-next,4/9] net/packet: annotate accesses to po->tp_tstamp
    https://git.kernel.org/netdev/net-next/c/1051ce4ab64d
  - [net-next,5/9] net/packet: convert po->tp_tx_has_off to an atomic flag
    https://git.kernel.org/netdev/net-next/c/7438344660fa
  - [net-next,6/9] net/packet: convert po->tp_loss to an atomic flag
    https://git.kernel.org/netdev/net-next/c/164bddace2e0
  - [net-next,7/9] net/packet: convert po->has_vnet_hdr to an atomic flag
    https://git.kernel.org/netdev/net-next/c/50d935eafee2
  - [net-next,8/9] net/packet: convert po->running to an atomic flag
    https://git.kernel.org/netdev/net-next/c/61edf479818e
  - [net-next,9/9] net/packet: convert po->pressure to an atomic flag
    https://git.kernel.org/netdev/net-next/c/791a3e9f1a86

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


