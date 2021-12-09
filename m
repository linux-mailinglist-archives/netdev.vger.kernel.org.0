Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A5F46F5F0
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 22:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbhLIVeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 16:34:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35396 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhLIVeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 16:34:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE062B8268C;
        Thu,  9 Dec 2021 21:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B198C341C7;
        Thu,  9 Dec 2021 21:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639085423;
        bh=0nLiGm6DRDI48lr5XPK/3aMQSk0B5ldWPNaWbeZDORE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GEskyYFfxQ1ojYuDEvF79vtFaEsMF7UwU0vr2OBCMYdV616mpJe3K7LUFZVBgyjfm
         znKq6cuwNBgeiXyDgYdiCBPzChQVt0B6mv97mb5TBrnC7d8Q+hN8ZTKxj3DNBaJpn3
         DFLIz6ysMYVb9EZsF+xAPLj2SD5C1UMqG7WCT36nMxrjRttcnLc+Oslc3Lgci39NBI
         L4xcjCOQMZtFVUsUPa0SO3A37j+opB8pGKz4Ls2fUvBLMYGZb1/lUrmnsDystY25ae
         XpOO0uUlnR6bUwADclbINISGCZeG1gKIdQIKdDiCVUo2KBCfQ9D2AkZDAxWsRaVB+9
         klpD3+aHgWvIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6F4A2609D7;
        Thu,  9 Dec 2021 21:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] skbuff: Extract list pointers to silence compiler warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163908542345.522.6404194998355353542.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 21:30:23 +0000
References: <20211207062758.2324338-1-keescook@chromium.org>
In-Reply-To: <20211207062758.2324338-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     kuba@kernel.org, davem@davemloft.net, jonathan.lemon@gmail.com,
        edumazet@google.com, elver@google.com, alobakin@pm.me,
        pabeni@redhat.com, cong.wang@bytedance.com, talalahmad@google.com,
        haokexin@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Dec 2021 22:27:58 -0800 you wrote:
> Under both -Warray-bounds and the object_size sanitizer, the compiler is
> upset about accessing prev/next of sk_buff when the object it thinks it
> is coming from is sk_buff_head. The warning is a false positive due to
> the compiler taking a conservative approach, opting to warn at casting
> time rather than access time.
> 
> However, in support of enabling -Warray-bounds globally (which has
> found many real bugs), arrange things for sk_buff so that the compiler
> can unambiguously see that there is no intention to access anything
> except prev/next.  Introduce and cast to a separate struct sk_buff_list,
> which contains _only_ the first two fields, silencing the warnings:
> 
> [...]

Here is the summary with links:
  - skbuff: Extract list pointers to silence compiler warnings
    https://git.kernel.org/netdev/net-next/c/1a2fb220edca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


