Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBE5456E7C
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbhKSLxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:53:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:47158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234074AbhKSLxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 06:53:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2578D61B31;
        Fri, 19 Nov 2021 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637322616;
        bh=w4dmO9pSwEAzuHpAq9GiQ0AtQIdQG7vwxxRqPM4iib0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UKAfCb/SPs55IPQamWEYJEnRqM5312Q66V8QOkaQ/nNLKL4672bK+Igo8lZn3Pgdf
         6cu7fJ8lEjOXI4kci7mzkCdUACbxJZQ26jpO1xXmDIhUU7OWP783mLkzgCADaNTFl8
         BApvvcHN3PsNfdVKsHPKYkPjlZ7ij+WQJ1M5cX9+HVGmfYsV8TWNADnEdNbrODPml0
         oGNmo+kCRlBEUq+ii0A6pSNNBfumgvl5lTNemDNqQqizzFpxToXtRgc20escjbQTxI
         RqakpuNEeaVxTpOF4w3emqJo+aCVvXFVQy9HPLXZTCNChwgLjbHP+tTC1Hgo3RGaVc
         R0hiRHrZ7q0eQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 201CF600E8;
        Fri, 19 Nov 2021 11:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cxgb4: Use struct_group() for memcpy() region
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732261612.10547.9889685800124478844.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 11:50:16 +0000
References: <20211118184235.1284358-1-keescook@chromium.org>
In-Reply-To: <20211118184235.1284358-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 10:42:35 -0800 you wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use struct_group() in struct fw_eth_tx_pkt_vm_wr around members ethmacdst,
> ethmacsrc, ethtype, and vlantci, so they can be referenced together. This
> will allow memcpy() and sizeof() to more easily reason about sizes,
> improve readability, and avoid future warnings about writing beyond the
> end of ethmacdst.
> 
> [...]

Here is the summary with links:
  - cxgb4: Use struct_group() for memcpy() region
    https://git.kernel.org/netdev/net-next/c/641d3ef00ce3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


