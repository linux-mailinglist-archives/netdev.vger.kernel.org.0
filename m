Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1092A581DF2
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239918AbiG0DKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbiG0DKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA8A615E
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D3E161797
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 03:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04CF1C4347C;
        Wed, 27 Jul 2022 03:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658891414;
        bh=ShW4UTAj3gEM/o8A9JqSUGF87Ffi7j2fzMhrVLHM2Fg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oahgOvOV55zKMy2WXVuPuDPMxaB4UQjl8im28IVT6EHp55qwKICkbr3JfE7jKUSDi
         Gxv6oVfHRzbURn/Zap+yo43xH5sU0eXdcVCdnNCtg8V/LaXgBrE8zIUob8OE5Plnfb
         Glps9yjvDIMI+VZ1v/XynalvND5AJQCKM00Tj26NeKftzyb80ZvW5TpZCxEsfpUBH6
         J6+6ONG2dNO/47K+6o+JLISiZpDHVfVAi02dW4KEmFGwweH0M3YW6sjFbBWH9DCOf4
         WyMzM6/us2mAqNOuvht2ckCLHGMKgEdqZ4iZy3wzWhTCHqjwKawRydve8sXjqP4Cd1
         1/yMxXuVo9pIw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF2E7C43144;
        Wed, 27 Jul 2022 03:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nf_queue: do not allow packet truncation
 below transport header offset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165889141391.5272.4804742479205778392.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jul 2022 03:10:13 +0000
References: <20220726192056.13497-2-fw@strlen.de>
In-Reply-To: <20220726192056.13497-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pwnzer0tt1@proton.me,
        pablo@netfilter.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Florian Westphal <fw@strlen.de>:

On Tue, 26 Jul 2022 21:20:54 +0200 you wrote:
> Domingo Dirutigliano and Nicola Guerrera report kernel panic when
> sending nf_queue verdict with 1-byte nfta_payload attribute.
> 
> The IP/IPv6 stack pulls the IP(v6) header from the packet after the
> input hook.
> 
> If user truncates the packet below the header size, this skb_pull() will
> result in a malformed skb (skb->len < 0).
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nf_queue: do not allow packet truncation below transport header offset
    https://git.kernel.org/netdev/net/c/99a63d36cb3e
  - [net,2/3] netfilter: nf_tables: add rescheduling points during loop detection walks
    https://git.kernel.org/netdev/net/c/81ea01066741
  - [net,3/3] netfilter: nft_queue: only allow supported familes and hooks
    https://git.kernel.org/netdev/net/c/47f4f510ad58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


