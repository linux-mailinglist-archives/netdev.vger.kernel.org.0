Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8611A439A9E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 17:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhJYPmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 11:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231859AbhJYPma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 11:42:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E611960E97;
        Mon, 25 Oct 2021 15:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635176407;
        bh=ivjh99f3sqGlLnX11lyTPWapHMC1Nka/Qt2ZsoVzk/o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ay6vBTasmVOK0M3lhjzpwYmBLCNMznZrZHA8enBoREbtgYEYy5vZ4/Q4XyLYm+09t
         QspaGAlByGSqQZSASOdvb+kkdtFRvJNmppUmRhNnocI7wro6hw1B/cXQNzX6+R4ebR
         DSJ46pz6R6qt8QGRF9Aclh2suBlFh4GeSuzna+IyxkNtEvlKICxww01ZlpFyHqSTP3
         3f0WABGh1N9NOEMgQX+ywKgmVwoTJ7h+CYwjrZpW3OtZ5SXsrxvXtAcy4RY4//DG7w
         io6K2Xo3uAMSFtAOO2TzyO58X2Phrx7eS7e4nKVhBcMDBYJ3kBClKbp/puDQ6/LJT+
         xTMBbokxBfc0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D8B6B60A21;
        Mon, 25 Oct 2021 15:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/tls: tls_crypto_context add supported algorithms context
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163517640788.4268.815624619292262773.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 15:40:07 +0000
References: <20211025130439.92746-1-tianjia.zhang@linux.alibaba.com>
In-Reply-To: <20211025130439.92746-1-tianjia.zhang@linux.alibaba.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Oct 2021 21:04:39 +0800 you wrote:
> tls already supports the SM4 GCM/CCM algorithms. It is also necessary
> to add support for these two algorithms in tls_crypto_context to avoid
> potential issues caused by forced type conversion.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  include/net/tls.h | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - net/tls: tls_crypto_context add supported algorithms context
    https://git.kernel.org/netdev/net-next/c/39d8fb96e3d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


