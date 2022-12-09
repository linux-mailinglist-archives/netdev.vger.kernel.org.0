Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B2964885C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiLISUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLISUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A745A11808
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 10:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 427E9622F8
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 18:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92313C433F1;
        Fri,  9 Dec 2022 18:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670610017;
        bh=E9lnkjbSzFArOBRgEvAEobha87/xQuT8L7xnhaSDufw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gbz+zbdJMQ0g5kDctPsRFMsBa0QSAiLq5Wpq2C8g8/CXPNq9+OfTIA9PlzqXvKNX7
         YaukCJEGc3jJjeO455xujNI3qYdtUCXr8RVqF2zrPvr4yxPDlHT/Nt0iQm7fcZMFmi
         ZO54Yam1bQ9KbGRtZrQ9Q13oGm/NS/39w+DT35l1J6rNm+LINZv+OSQN1j3Sy3rppj
         0nIb8n3euoJcOIAjOfL67c+ZKoFlOdD+I7KmETlVxo0v+Gg2kwdcRMrEjfvQs8EwAg
         IFvz8ZJNwZRF3HT/wAPopziViAmBjJ6lVdY8BUmIFT9cOU73g0zRxd5e/7yF5cNc5g
         23pbiITAVd4VQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73A33C41612;
        Fri,  9 Dec 2022 18:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] ip-link: man: Document existence of netns argument
 in add command
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167061001747.13827.8092969149707001850.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 18:20:17 +0000
References: <25bdd4763e23c73aca71f17d43753311de0c268a.1670525490.git.dxu@dxuuu.xyz>
In-Reply-To: <25bdd4763e23c73aca71f17d43753311de0c268a.1670525490.git.dxu@dxuuu.xyz>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        stephen@networkplumber.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Thu,  8 Dec 2022 11:53:06 -0700 you wrote:
> ip-link-add supports netns argument just like ip-link-set. This commit
> documents the existence of netns in help text and man page.
> 
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
>  ip/iplink.c           | 1 +
>  man/man8/ip-link.8.in | 6 ++++++
>  2 files changed, 7 insertions(+)

Here is the summary with links:
  - [iproute2] ip-link: man: Document existence of netns argument in add command
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=1a408bda2eec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


