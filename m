Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC930459185
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239821AbhKVPnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:43:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231697AbhKVPnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 10:43:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4EADC60273;
        Mon, 22 Nov 2021 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637595609;
        bh=cZfewvS5PAlcJFDY0Eq/GWJt9fC6OHF87EZvnel4SM8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fMkWVy/mTr0j7q3xu3b26dtnE550OSHSUJAQH/chzdvoT2iDzsA8ajZjHcleXe89z
         lQFvcRoKRinudp9oKSG3V3zh+isSAjBi8zr73/JCmMnv77dxZ0fpG2Mp8fgaYVDYD0
         GFeVzCxUTQC8cK/ETd5jWXJZWC/WbCaf2vnrQX4w8rcDG4xoFnik3zuvWsQ2xAs7MK
         whuafjatQiXzTc8pmPpSSCI5yh6u4iAHFbaMUHrYjAgNv6nkPrlN9fmdfAksdvxxOn
         f/mU5WraWhUr5GjoSRGhqWC+oX/QiFh3mP9nFrSyLBLwL29iWpHKwRqWr9uMvR5MRz
         MBKb1ZfwYFaPw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3F250609D9;
        Mon, 22 Nov 2021 15:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] skbuff: Switch structure bounds to
 struct_group()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759560925.30526.865099452539818028.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 15:40:09 +0000
References: <20211121003149.28397-1-keescook@chromium.org>
In-Reply-To: <20211121003149.28397-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     kuba@kernel.org, davem@davemloft.net, jonathan.lemon@gmail.com,
        alobakin@pm.me, jakub@cloudflare.com, elver@google.com,
        willemb@google.com, gustavoars@kernel.org, Jason@zx2c4.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, edumazet@google.com,
        cong.wang@bytedance.com, pabeni@redhat.com, talalahmad@google.com,
        haokexin@gmail.com, ilias.apalodimas@linaro.org, vvs@virtuozzo.com,
        linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 20 Nov 2021 16:31:47 -0800 you wrote:
> Hi,
> 
> This is a pair of patches to add struct_group() to struct sk_buff. The
> first is needed to work around sparse-specific complaints, and is new
> for v2. The second patch is the same as originally sent as v1.
> 
> -Kees
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] skbuff: Move conditional preprocessor directives out of struct sk_buff
    https://git.kernel.org/netdev/net-next/c/fba84957e2e2
  - [v2,net-next,2/2] skbuff: Switch structure bounds to struct_group()
    https://git.kernel.org/netdev/net-next/c/03f61041c179

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


