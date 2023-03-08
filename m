Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3176B00C9
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCHIVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjCHIUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:20:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004F4AF6BF
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 00:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74E1D616DD
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 08:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCEAFC433EF;
        Wed,  8 Mar 2023 08:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678263618;
        bh=ZwGQEB2eZzOw/haBXUSb02xM1davG3v7VjkCD0BnvIU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uWnnmYjSE19mcRzLWTO/SFa1EqC12ZMBYauNEBZcsajJeJmjSs0N3FA6q58372bQg
         926fRjjz0OKgeKK703BDKBeAdqh8VypkPtLciQVMUNzXy5HCHlTy9M45pT5Ugdebc3
         JHYzrk1UF+MT+eu4w7dvMoRPYSWY7FomF6JCLdsTM8fDe6Hrhd/JoIkMFfImBfnI8q
         L29NMt9SRNFbdGD15TCUn54oG3guq106q3jekPKDlKIB6g8d66+1nLRQGwdfKO5slm
         psbyaINshq1AVZHuQoy4RC6JcO9rnTxc3sqxKcsffDQ8B1BESD4qV76YmxE/jj1p4M
         pt2p+8SeH24bw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ACE8AE61B6F;
        Wed,  8 Mar 2023 08:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: remove enum skb_free_reason
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167826361870.8176.13844519907843897624.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Mar 2023 08:20:18 +0000
References: <20230306204313.10492-1-edumazet@google.com>
In-Reply-To: <20230306204313.10492-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Mar 2023 20:43:13 +0000 you wrote:
> enum skb_drop_reason is more generic, we can adopt it instead.
> 
> Provide dev_kfree_skb_irq_reason() and dev_kfree_skb_any_reason().
> 
> This means drivers can use more precise drop reasons if they want to.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: remove enum skb_free_reason
    https://git.kernel.org/netdev/net-next/c/40bbae583ec3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


