Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76F4456E7D
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhKSLxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:53:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:47124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233992AbhKSLxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 06:53:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EAFE361B1B;
        Fri, 19 Nov 2021 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637322616;
        bh=HYjWRtSh7OsyKlSj/ppdI20t46yLwmU6ztXQZj6VYZk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OW0fVP6HB/L+TwjkCCERFg3nzTMYTIICmtCBl7YPRbogzR/Gc9KHNDkfNr4YIYqQV
         1EfMsE3TYEmZMfP77+fOXruADUdLQLVTuxBer/Z6mazQP+nPPcAtAhM2z+sWF7jV++
         X0HiPcIMkT09cNd3UrF3VYOvesnQX3toARIl9P9GnyNrtkw67wegVJcfZWb+yvGEyh
         JMAvD0OkV7dxe+jfUDgb7fryU876tb+Hu1VoN49bvcaB1Aj0NzUObZyQbBmCJaQCl1
         MtChc7/0Uh/JwqZvcQcAwyTO+m777TaTTGOaMHMg1xD8xZuc3bqJElfGGyFgmiqinZ
         zG6ox2M6lNA0g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E411460A0F;
        Fri, 19 Nov 2021 11:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cxgb3: Use struct_group() for memcpy() region
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732261593.10547.9904754003494759075.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 11:50:15 +0000
References: <20211118184142.1283993-1-keescook@chromium.org>
In-Reply-To: <20211118184142.1283993-1-keescook@chromium.org>
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

On Thu, 18 Nov 2021 10:41:42 -0800 you wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use struct_group() in struct rss_hdr around members imm_data and intr_gen,
> so they can be referenced together. This will allow memcpy() and sizeof()
> to more easily reason about sizes, improve readability, and avoid future
> warnings about writing beyond the end of imm_data.
> 
> [...]

Here is the summary with links:
  - cxgb3: Use struct_group() for memcpy() region
    https://git.kernel.org/netdev/net-next/c/88181f1d3474

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


