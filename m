Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CB43D81CD
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhG0VaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231944AbhG0VaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 17:30:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4067960FC0;
        Tue, 27 Jul 2021 21:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627421405;
        bh=/0TH+8S4Jwlt7pjr4CYE1nNWJcFGEsRlfZrY8Ylx06w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MxDf0ksAFo0ZHubjhsGrlqNzxlJcgrykYyBQZ99KVVyJhXkLxbV232+cLob3EvY5E
         yCgdxW4JZb1vEDYQPy6BXYYX5zbzc5YXqDmh38ay6fmSV83//THTz3ZHnjTWgQisjH
         TwP2WRynwLOzKR2Gw5nAQiMhqys9qdmNX7u5aOP72r9frYNjzJyNQ2r3FGB5l6Ief7
         vTKeS1owLX7bKDYv9+V1ZDhWdhTKifFpMpj2rF68vpRqYTIZw2WCnvxvmNtVUmLrVt
         FcqyGwqqzKzTe8xJNTWWicrTaFToHUOelgsxSF1cArBhjwpU+qM1KyJusEN3IygAjl
         BDzqaNDCPwDqw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 33B1660A59;
        Tue, 27 Jul 2021 21:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] libbpf: fix commnet typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162742140520.28558.9400918409950700066.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 21:30:05 +0000
References: <20210727115928.74600-1-wangborong@cdjrlc.com>
In-Reply-To: <20210727115928.74600-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 27 Jul 2021 19:59:28 +0800 you wrote:
> Remove the repeated word 'the' in line 48.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
>  tools/lib/bpf/libbpf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - libbpf: fix commnet typo
    https://git.kernel.org/bpf/bpf-next/c/c139e40a515d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


