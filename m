Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF72569E602
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbjBURaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbjBURaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BE52D47;
        Tue, 21 Feb 2023 09:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BE8F6116C;
        Tue, 21 Feb 2023 17:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB0B2C4339B;
        Tue, 21 Feb 2023 17:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677000617;
        bh=m5EqS2hnbXfaW7CLmG0f6p125ejRG+Aqu9Q1yjEGSi8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l6nBXTFrxR2oqyEBsJX+URU9KCR7xj5d6MY4oQbLZP8b3UJt04c32TfNR8YvCU5Rm
         z7MxSleJ1td4HEgCxkfjWj3Dvkjil2iez8F4g8Hf3XxPyaCcZ+WC4Yl1R2Ekm7kAlY
         uPLY5Exm1Wxq38H9K4c+wyCY7+1D+ZILNTkBUuCewcTX+6BqGmI8Yk41unXMIOq3HH
         9LrRurxI0UL0cVlKwJrWdz2WhufvEA/JZe6H+8UvizsqtN50LlxbhpTIdc9XU2F1nq
         f2b8qIQgFxgZ3m4qwiKzyz3YASlZvSBEQA9YEUgShHH/KCvWCzOUZJMb3ikiry08QY
         ynLlaGvfieyCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ADFCBC43159;
        Tue, 21 Feb 2023 17:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] page_pool: add a comment explaining the fragment counter
 usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167700061770.3298.14628579257086462902.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 17:30:17 +0000
References: <20230217222130.85205-1-ilias.apalodimas@linaro.org>
In-Reply-To: <20230217222130.85205-1-ilias.apalodimas@linaro.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, alexander.duyck@gmail.com,
        alexanderduyck@fb.com, hawk@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 18 Feb 2023 00:21:30 +0200 you wrote:
> When reading the page_pool code the first impression is that keeping
> two separate counters, one being the page refcnt and the other being
> fragment pp_frag_count, is counter-intuitive.
> 
> However without that fragment counter we don't know when to reliably
> destroy or sync the outstanding DMA mappings.  So let's add a comment
> explaining this part.
> 
> [...]

Here is the summary with links:
  - [v3] page_pool: add a comment explaining the fragment counter usage
    https://git.kernel.org/netdev/net-next/c/4d4266e3fd32

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


