Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A3755384E
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 19:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242913AbiFURAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 13:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237238AbiFURAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 13:00:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294D622BD7;
        Tue, 21 Jun 2022 10:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 67745CE1BCE;
        Tue, 21 Jun 2022 17:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B971AC3411C;
        Tue, 21 Jun 2022 17:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655830815;
        bh=iEUVf79dlSkhgkZYn+jLGG8VPISS4lvpWlkWSSE4ZUA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mLmKlbeK7rKv2c3vnwkKqD+9/f4NAE+NN+/wNShsjh/iB9dZP7KKmLl7y30EhCeCu
         omeHlSmJp//kbDcuNlYIwZNvpphnKYnZnDdPXy7f0Kr7ct9qB9Gm2yMnwxh0Rdz9yR
         UzU/OJjY7+9EUXfxDHQYFERioAiWWUql2Ip68PF6mciOCVmy1dbXxWMGL67Mvm9yGM
         KNHkx7XcawtZ+gyb15HQFYznC4cY8TCNM2upFG1hXjSMj5aSkDbG8V5qUJHxQ4WdG1
         o2L64Ogmcjrt6VIUodg60eu2eS1jDuHxxiHesfpMzo/BLX3L8m25BSkRWUVQFtMEb9
         a4O8e/rIFkJfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 90B49E73856;
        Tue, 21 Jun 2022 17:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/2] Allow mixing bpf2bpf calls with tail calls on
 arm64
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165583081558.23938.2888618327676957069.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Jun 2022 17:00:15 +0000
References: <20220617105735.733938-1-jakub@cloudflare.com>
In-Reply-To: <20220617105735.733938-1-jakub@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@cloudflare.com, tony.ambardar@gmail.com
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

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 17 Jun 2022 12:57:33 +0200 you wrote:
> This patch set enables using bpf2bpf calls together with tail calls on arm64.
> Patch 1 was borrowed from an RFC series for MIPS JIT [1].
> Patch 2 gives an explanation of tweaks needed to arm64 BPF JIT.
> 
> [1] https://lore.kernel.org/bpf/77dfea2d224e7545e5e4d3f350721d27e5a77b0d.1633392335.git.Tony.Ambardar@gmail.com/#r
> 
> Jakub Sitnicki (1):
>   bpf: arm64: Keep tail call count across bpf2bpf calls
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] bpf: x64: Add predicate for bpf2bpf with tailcalls support in JIT
    https://git.kernel.org/bpf/bpf-next/c/95acd8817e66
  - [bpf-next,2/2] bpf: arm64: Keep tail call count across bpf2bpf calls
    https://git.kernel.org/bpf/bpf-next/c/d4609a5d8c70

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


