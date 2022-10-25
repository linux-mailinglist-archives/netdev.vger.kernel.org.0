Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9552D60CAC4
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiJYLUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJYLUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3514855A3;
        Tue, 25 Oct 2022 04:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88188618C5;
        Tue, 25 Oct 2022 11:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3030C433D6;
        Tue, 25 Oct 2022 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666696815;
        bh=U162O3bGj7nv99ZVG9NgsSTPlPrzIqMUpNZG/wdu75M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Soq9eQc163E5pUYs4qjxez8XxuhvCnSHx0bvTxH9JLT4pengYTO/Lqq7xJ9jNfrnw
         /5Ns7GEDnmlWouIxawGrLsSb+U3j7ENqXYnjLTp5Eu/5HIhu7bCM5GFCb6MO7Ujohp
         yq5B2vAbdB9f1cN1ZQeYo6O5LmT/6MsIzAS/VwhrDTsE+TQqCiramjthPhDyny9/oL
         h7l1xHGW84ehxFjNeWHkB5RaWXMzzhVZyKIJV6OwCVabwaGpOYczk+fWjzdAE+Wnxt
         NkLkI8JmeGsKrGq+XIj6f0rFwRltYJ05HpvIZlz8n+oRvyH/OJySE+kdZWVN7lIeMF
         hlR1dtdzOCbaw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B75A5E29F32;
        Tue, 25 Oct 2022 11:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] bnx2: Use kmalloc_size_roundup() to match ksize() usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166669681574.30918.11457311323167299344.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 11:20:15 +0000
References: <20221022021004.gonna.489-kees@kernel.org>
In-Reply-To: <20221022021004.gonna.489-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     rmody@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 21 Oct 2022 19:10:47 -0700 you wrote:
> Round up allocations with kmalloc_size_roundup() so that build_skb()'s
> use of ksize() is always accurate and no special handling of the memory
> is needed by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.
> 
> Cc: Rasesh Mody <rmody@marvell.com>
> Cc: GR-Linux-NIC-Dev@marvell.com
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> [...]

Here is the summary with links:
  - [v2] bnx2: Use kmalloc_size_roundup() to match ksize() usage
    https://git.kernel.org/netdev/net-next/c/d6dd508080a3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


