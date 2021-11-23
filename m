Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55582459A08
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 03:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhKWCXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 21:23:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhKWCXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 21:23:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 128FC60FBF;
        Tue, 23 Nov 2021 02:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637634009;
        bh=CkmVHf7r6GXoGTzRujXL3XgDNQ3Y9Vu1bpjEELMYAfs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R5nH+wN6xS8DpqD9V3JSUh3hoi35NAOKE+JDiN4FNCAqQDJZ/6neRdIXL+jdnwd2A
         x1CVxMXO97XYA7sXWgazAgFLHei6OqgVUmULzseRJWddkeiE1Eubdcks2S46BXNiau
         uxVZrLUFny8C5wfPD2/MISr+U3F5ej7O438A4PUQl3JpE+0TaxgmucPq6ZwJByRKFA
         /fSZ9/QRJ1XjjGkw9y1+8KjgR6yeyJ9dTUtXu5okBjCFllKdVF5d0sezxfpxq6gvJd
         oDqUj1++P4xrPZiMuGgxiWHPIj8SXTTILXbePOt0V/20rMWN3OiZ6VVE9eG9CnFrTH
         +d78B0H1s+LIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 04C2B60A50;
        Tue, 23 Nov 2021 02:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/bpf: Fix trivial typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163763400901.23287.10698315968549925390.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 02:20:09 +0000
References: <20211122070528.837806-1-dfustini@baylibre.com>
In-Reply-To: <20211122070528.837806-1-dfustini@baylibre.com>
To:     Drew Fustini <dfustini@baylibre.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, trivial@kernel.org,
        alan.maguire@oracle.com, toke@redhat.com, hengqi.chen@gmail.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        gustavoars@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Sun, 21 Nov 2021 23:05:30 -0800 you wrote:
> Fix trivial typo in comment from 'oveflow' to 'overflow'.
> 
> Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Signed-off-by: Drew Fustini <dfustini@baylibre.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/btf_dump.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - selftests/bpf: Fix trivial typo
    https://git.kernel.org/bpf/bpf-next/c/fa721d4f0b91

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


