Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1F12F3D77
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437962AbhALVhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436897AbhALUUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 15:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C69602311B;
        Tue, 12 Jan 2021 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610482808;
        bh=caIIJgBgqLrq++aVZ/Fjc3uNJEwQtrm6ZhN5o3vkT0k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cW4wcx/QQ/WdzP/1IaZoMZEgcyGsOkKPP3JsZkvlg+MdvK3uVZc3vvZQdeaHcWD5h
         Karomr7NVwb1DgKD3LHXLv5YycdhlJ7THJ9KbaKqk7plcZgfENRVWcnbnyoZmIMd1b
         pUTvpB5uGR/U0ERZNuuORN8HIb/94FrgV6K61Y8ahgg51EkrQVLxDr6VGS8ZKfBrx9
         X+1G5qhsHEIKzeg0an6URhuaNS0ocyQwimEHmRIctSdkrH8vaUlvo611BBybfJ15WU
         d3+reM8pcRjS8FFNjCoSaotbJ+xaf8wHMdCaaCOL8jsFWuaSU1IVXJWzxhOQx/70Mz
         ItlG2MFQefBXQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id B90A460354;
        Tue, 12 Jan 2021 20:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf 1/2] bpf: allow empty module BTFs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161048280875.1131.14039972740532054006.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jan 2021 20:20:08 +0000
References: <20210110070341.1380086-1-andrii@kernel.org>
In-Reply-To: <20210110070341.1380086-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com, chris@kode54.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (refs/heads/master):

On Sat, 9 Jan 2021 23:03:40 -0800 you wrote:
> Some modules don't declare any new types and end up with an empty BTF,
> containing only valid BTF header and no types or strings sections. This
> currently causes BTF validation error. There is nothing wrong with such BTF,
> so fix the issue by allowing module BTFs with no types or strings.
> 
> Reported-by: Christopher William Snowhill <chris@kode54.net>
> Fixes: 36e68442d1af ("bpf: Load and verify kernel module BTFs")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> 
> [...]

Here is the summary with links:
  - [bpf,1/2] bpf: allow empty module BTFs
    https://git.kernel.org/bpf/bpf/c/bcc5e6162d66
  - [bpf,2/2] libbpf: allow loading empty BTFs
    https://git.kernel.org/bpf/bpf/c/b8d52264df85

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


