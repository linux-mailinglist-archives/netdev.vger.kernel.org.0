Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB444242AE
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 18:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238510AbhJFQcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 12:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231755AbhJFQb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 12:31:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 842EF60F6C;
        Wed,  6 Oct 2021 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633537807;
        bh=eCIyQf2bB20KLODueReaN6pOiB+BRZIoieVRu1Zzrdw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vQGtuOjiC7fSix+ZmD75UT1SraR3HjP4XUgQK7D17BYnmnooaOpOQMYja6iqteHyC
         kZo0wnPECN+WeHzorCUBCjjxIULfMP3b8vpTxwDFvOaMkl+KMeRKGNrrRPnDX+eV1o
         S6WnV4fAH5GaA+gBRScZ8RKIVJBmOjm7VWbwzObDYkfAmeTcM0eSJvE9/W/VtyyBwl
         oH7BFunNrJWJAbI3NgZY0YEQPBxVQCrT7fpVnZqrYgmrYv0tgKyqjxpUFAOxrMtgRf
         JLIq2LOncotj+S0AbNEnDEj033BncB5v0hIJtERT5k4OCcMZ6I3NtJK2dggFIFjW/B
         pgAeDsyAHj0LQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 77F4E60971;
        Wed,  6 Oct 2021 16:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: use $(pound) instead of \# in Makefiles
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163353780748.7077.6059227334886059915.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 16:30:07 +0000
References: <20211006111049.20708-1-quentin@isovalent.com>
In-Reply-To: <20211006111049.20708-1-quentin@isovalent.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed,  6 Oct 2021 12:10:49 +0100 you wrote:
> Recent-ish versions of make do no longer consider number signs ("#") as
> comment symbols when they are inserted inside of a macro reference or in
> a function invocation. In such cases, the symbols should not be escaped.
> 
> There are a few occurrences of "\#" in libbpf's and samples' Makefiles.
> In the former, the backslash is harmless, because grep associates no
> particular meaning to the escaped symbol and reads it as a regular "#".
> In samples' Makefile, recent versions of make will pass the backslash
> down to the compiler, making the probe fail all the time and resulting
> in the display of a warning about "make headers_install" being required,
> even after headers have been installed.
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: use $(pound) instead of \# in Makefiles
    https://git.kernel.org/bpf/bpf-next/c/bf2819e0b10f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


