Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E61456E9E
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 13:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbhKSMDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 07:03:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234651AbhKSMDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 07:03:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0FF1161B1E;
        Fri, 19 Nov 2021 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637323213;
        bh=FBWFT5oIp+9kdfkjTMLIkLgfD8Gj58mxeMxVU5jC09U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pl2DynZ23b0SJxn3iNBNkFuyM0zWs86HxB70KMibkT4cIFF58ZkADmAWxGTfbOQLr
         FDxjzqWcYqNh34hRKnhDXdeKLrdAZhdGGDliu2Ybv6zXQedd631nwC40U37haIEK+k
         eogSb56wBqtBbM65su2YplE972KoYZBBdR4B/PFhn4vqBl667eKT7MGnCdER/sW4Hh
         rI5NbsnE3uJXXE+ezf5qZs6APLmCul1g5k+8y04M+ugp3U5CaJ7kvCCpsaJhdNYUKC
         62Imxn80W3SsET4CvbCtiIc/pYiY1JG7HQ6Dmupy68GXA/6fw73C0sDo9ykoacH/MX
         +iK+I0l9Ft6Dg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0972D6096E;
        Fri, 19 Nov 2021 12:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/af_iucv: Use struct_group() to zero struct iucv_sock
 region
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732321303.14736.13801236944180111201.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 12:00:13 +0000
References: <20211118203407.1287756-1-keescook@chromium.org>
In-Reply-To: <20211118203407.1287756-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     jwi@linux.ibm.com, kgraul@linux.ibm.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 12:34:07 -0800 you wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Add struct_group() to mark the region of struct iucv_sock that gets
> initialized to zero. Avoid the future warning:
> 
> [...]

Here is the summary with links:
  - net/af_iucv: Use struct_group() to zero struct iucv_sock region
    https://git.kernel.org/netdev/net-next/c/b5d8cf0af167

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


