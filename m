Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD51E31A693
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhBLVKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 16:10:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231583AbhBLVKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 16:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 311F964DEC;
        Fri, 12 Feb 2021 21:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613164207;
        bh=WDnwwzuH5I1tWUZdI0KxcU+sZ9q1EGTq11foIk4i988=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jfFIjnbn7fPTzmOAlrHaKMy5OxPBAWxyHsisNqJLegwvNnRmjsncYsCBYV7V7HGix
         bwy+Pam/hyx9LuYMNNQIJuvfTG1LMW5TBUfiiUXt5hIA0JLS5EsDHWqX4zDYh6gym2
         TXILk+2AIZdKCQx3KIsoVOhc37SQ+2x4xJ0X9rGGPUrOTehcJM9uio7Mp9ern6kU/f
         Yo8XQr3uD0U8b0bwEjl6LX59tnq+WfnB8r2MvpVs6Pc7L7zq0qs+PlNeNoA1HIGGID
         DPKWRHgYx0I1ZyWbTz40kAhREKztF2zm+Y7AxiXp0Cov8yAIMuUfDwhNC/PqTRciXs
         lU2KE3KBfyaTQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 27BD260A2B;
        Fri, 12 Feb 2021 21:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: add /libbpf to .gitignore
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161316420715.6965.3911954868027730478.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Feb 2021 21:10:07 +0000
References: <20210212010053.668700-1-sdf@google.com>
In-Reply-To: <20210212010053.668700-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 11 Feb 2021 17:00:53 -0800 you wrote:
> There is what I see after compiling the kernel:
> 
>  # bpf-next...bpf-next/master
>  ?? tools/bpf/resolve_btfids/libbpf/
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] tools/resolve_btfids: add /libbpf to .gitignore
    https://git.kernel.org/bpf/bpf-next/c/90a82b1fa40d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


