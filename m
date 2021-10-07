Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB52425CC7
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241784AbhJGUCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236210AbhJGUCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 16:02:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 50561610C8;
        Thu,  7 Oct 2021 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633636807;
        bh=RH9bOR8XoFNTkhlmoufx0mIr+7AtFOAnO2k9u1/anN0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ry1xVbO/WFeMCyY24JvHajNSVBWQl8AglidLCWTzPvJhgMZeqkNgtHsQEMnEsrPdG
         8vNqD8Jcq/TVFoJG4276eFrJhDoWzTZIVnY2tV0ws+g5JA85vaCVZ4r7zxFmcTiWgi
         BuxC1c8Iexl289Ak1+PQPQscWC1y8B7118u7U7K9HTjbtSr+rbtrPsq6LRA30jCaF8
         KLV298auCASjrV23Ii1Vl7SvGA0utxSbiJY0oSH6bQOcWKtGHQfgLPv9yUlEtj8aRY
         6WUlTcdtQXIiFzc6ZJED/2Txl3K7Hiln+hu2t6f4SrkAbbJHFnIC6DjPA7M/f+P9xT
         VDoyee6bl0efw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4200760A39;
        Thu,  7 Oct 2021 20:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] mips,
 bpf: Fix Makefile that referenced a removed file
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163363680726.2891.16519442145591885027.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Oct 2021 20:00:07 +0000
References: <20211007142339.633899-1-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20211007142339.633899-1-johan.almbladh@anyfinetworks.com>
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        paulburton@kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        tony.ambardar@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu,  7 Oct 2021 16:23:39 +0200 you wrote:
> This patch removes a stale Makefile reference to the cBPF JIT that was
> removed.
> 
> Fixes: 06b339fe5450 ("mips, bpf: Remove old BPF JIT implementations")
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>  arch/mips/net/Makefile | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [bpf-next] mips, bpf: Fix Makefile that referenced a removed file
    https://git.kernel.org/bpf/bpf-next/c/065485ac5e86

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


