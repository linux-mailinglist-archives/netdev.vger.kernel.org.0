Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AAC3B0B71
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhFVRcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhFVRcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:32:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5E9DA610C7;
        Tue, 22 Jun 2021 17:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624383004;
        bh=E6qiPxwz91u/GZp7zdFKvscmtYO1klejZ1g4ju8yOrw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s/SajBxFdh6yyitZ4+jt+L3CPxN/bCaFjNCXIXWoiG51gzYDtjHBNIMsEEFQc/NfK
         EaiBxWudnoVPPAnJ9JcAFliPjTm8Hb5T31TCwG9YTD2GUHDAjLZM5wRz3AbZhOPIqr
         r9i7eGCmVXxNckmHHW7ZL6+vJgoDyG3PTVPj4rw4rF0WMD1hFy3NCF5BfNEch6KpZT
         jP/MW0eRL6Fc/3AAqDUx5hoFFDP1yjBFt2oIx1QXAldhfBDhUO+RgA4pd0o0MD1Ayv
         g0kqTG+6P+u58THmeEhboEmkMLqCPDpGP9MlY+7snfOubI23NtlwIah4utjJyoZgUT
         KW/M6rGamEzkw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 515A6609AC;
        Tue, 22 Jun 2021 17:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hv_netvsc: Avoid field-overflowing memcpy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438300432.21657.18268821954591671920.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 17:30:04 +0000
References: <20210621222112.1749650-1-keescook@chromium.org>
In-Reply-To: <20210621222112.1749650-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 21 Jun 2021 15:21:12 -0700 you wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Add flexible array to represent start of buf_info, improving readability
> and avoid future warning where memcpy() thinks it is writing past the
> end of the structure.
> 
> [...]

Here is the summary with links:
  - hv_netvsc: Avoid field-overflowing memcpy()
    https://git.kernel.org/netdev/net-next/c/f2fcffe392c1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


