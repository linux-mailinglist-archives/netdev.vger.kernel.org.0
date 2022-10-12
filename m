Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2795FC57E
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiJLMkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJLMkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:40:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56D77B2AA;
        Wed, 12 Oct 2022 05:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 16BBECE1B2D;
        Wed, 12 Oct 2022 12:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A028C433D7;
        Wed, 12 Oct 2022 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665578415;
        bh=xjMgXIvqMwoitiYdM8Fd/wo6GXLsZu3oIGa2mxFKVdc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UeSFF4TXZ4U1/LZR3QcjxuULfGHhLIiBQ9dF0O5b6OAOGzwV6D0b/Ccv91sQLlbex
         DrdEMIc5bzvo0tXz+oniOPGTKfW554ffB4nX+B0VxcT7c8UxaG7NQ1KWJD+lEwIRt9
         wxhsINqZfp5bdnCQDOgVlQ0Z5EWghTt8/3ZaNxWHLbzNI1YZZss084cwB8CwVG7pZy
         EjoEqee2ko24QJcEQFu8Emm9NEi/4aD31nCzISju7VUpcuztgwOn54YXySFPDrUMAd
         j1fvYvIaHnYRdkD6GRwAnhjLuhj7QEjQ3WWxosXxQHY4P8Sco3iTviCHAPIh4PnQwQ
         fVL9yM51VOm7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19D5FE21EC5;
        Wed, 12 Oct 2022 12:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] selftests: netfilter: Test reverse path filtering
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166557841510.32004.6740633560901619092.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Oct 2022 12:40:15 +0000
References: <20221012121902.27738-2-fw@strlen.de>
In-Reply-To: <20221012121902.27738-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, phil@nwl.cc, gnault@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 12 Oct 2022 14:19:00 +0200 you wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> Test reverse path (filter) matches in iptables, ip6tables and nftables.
> Both with a regular interface and a VRF.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> Reviewed-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net,1/3] selftests: netfilter: Test reverse path filtering
    https://git.kernel.org/netdev/net/c/6e31ce831c63
  - [net,2/3] netfilter: rpfilter/fib: Populate flowic_l3mdev field
    https://git.kernel.org/netdev/net/c/acc641ab95b6
  - [net,3/3] selftests: netfilter: Fix nft_fib.sh for all.rp_filter=1
    https://git.kernel.org/netdev/net/c/6a91e7270936

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


