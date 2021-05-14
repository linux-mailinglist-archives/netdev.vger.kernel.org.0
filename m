Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A309381431
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbhENXVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230371AbhENXVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 19:21:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A543661444;
        Fri, 14 May 2021 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621034410;
        bh=Trje09rsM++X9OP/118f5iZH7IOdjaoQunsxpC+0Hjc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DQTLLRxuX6k2UGNGS3+X7Q5BqsUG11g+MW3PoHSsj/VomjDzB9sBI02MWFQq7bzRa
         ZxB2q95z14TWwuziQPuUDPM0Sfd5rFErVCwWb+AlH8N7rdigVnjPMKg1bkzI/DOahz
         0kYzYJay4w6JJxGPupR69r7MWZEZaiVwnuqK36VYApjJm140Da3abCWCrp7LjRESe4
         Kcx+W1hR8rJgs0NYFOwXoTkD8nZXHV2Sl6jqCFZjyTYU+pENKVSkhL+NqqD6Ot92Sr
         RCTZv12jlhlIeu3y2P2a5q83yK7rPA+5ijpO/pazMK2kuYubjcXJdQjqiGkqOZgqou
         LaAfy65kx69+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 993B760972;
        Fri, 14 May 2021 23:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] libbpf: reject static entry-point BPF programs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162103441062.30114.16345436625229192170.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 23:20:10 +0000
References: <20210514195534.1440970-1-andrii@kernel.org>
In-Reply-To: <20210514195534.1440970-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Fri, 14 May 2021 12:55:34 -0700 you wrote:
> Detect use of static entry-point BPF programs (those with SEC() markings) and
> emit error message. This is similar to
> c1cccec9c636 ("libbpf: Reject static maps") but for BPF programs.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 5 +++++
>  1 file changed, 5 insertions(+)

Here is the summary with links:
  - [bpf-next] libbpf: reject static entry-point BPF programs
    https://git.kernel.org/bpf/bpf-next/c/513f485ca516

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


