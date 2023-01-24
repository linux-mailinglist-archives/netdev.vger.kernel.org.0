Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25A9679093
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjAXGAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbjAXGAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBCAEC;
        Mon, 23 Jan 2023 22:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F5BAB81076;
        Tue, 24 Jan 2023 06:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D792C433EF;
        Tue, 24 Jan 2023 06:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674540017;
        bh=CxdriSAwmkKo5sOqhbD/ZD3b11jxTg6ywWYPe1BNqFA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vP99ObezP6pSPV2WhGc+0BfjdrBQJHVAKEEdzbhB92ItWIm8BLd47jHcVAGWFigRV
         6xYcL98lIhc+z4TJZCz2IaZ4IHalB+p70vwoG6uDPhjRngwLstYUniZNeyrAZNWJwT
         0Wb9dIIcDWn5g5zjB7yAzpjrup60aKEBQK6RsXj0Tp3Zvz+EokjWvpcB4Uhbw8jMpg
         BBKzkLe9h+ScxxxUQqznT8fA0qELhSRgcKGvK289e9EMqmFLaFOT3EpZDVRWfCVbvz
         rk1qKEo/3PwIbuebRLwn7+6D7yUEOPbnc+Z2zeBINmkErmrGbh9I2ZdcaMiAzw75zC
         EsqcBkEwlTvJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86E8EE4522B;
        Tue, 24 Jan 2023 06:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: nft_set_rbtree: Switch to node list walk
 for overlap detection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167454001754.8616.2198972017309241814.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 06:00:17 +0000
References: <20230123211601.292930-2-pablo@netfilter.org>
In-Reply-To: <20230123211601.292930-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
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
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon, 23 Jan 2023 22:16:00 +0100 you wrote:
> ...instead of a tree descent, which became overly complicated in an
> attempt to cover cases where expired or inactive elements would affect
> comparisons with the new element being inserted.
> 
> Further, it turned out that it's probably impossible to cover all those
> cases, as inactive nodes might entirely hide subtrees consisting of a
> complete interval plus a node that makes the current insertion not
> overlap.
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: nft_set_rbtree: Switch to node list walk for overlap detection
    https://git.kernel.org/netdev/net/c/c9e6978e2725
  - [net,2/2] netfilter: nft_set_rbtree: skip elements in transaction from garbage collection
    https://git.kernel.org/netdev/net/c/5d235d6ce75c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


