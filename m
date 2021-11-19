Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A6C456E79
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbhKSLxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:53:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233737AbhKSLxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 06:53:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A6FE561A7D;
        Fri, 19 Nov 2021 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637322615;
        bh=0Xj+pkY5u8qil++KPeBcBERvckxUD4+fzfE54LTplVQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W96b2Oq5Z5nsvHPdbX6arsRoReWdb2dk0ROqB3z+BHGk7SrqsiC1IBG1KGIOKmCCB
         H9uXp+BvOMSncLqmGba7ElemORE+7JkKV59gKMdjCAR362bzvYxkoTJSLuKVTFay1t
         tGhAQNmHvjyNx83UglwW4FNID2PyiO9rl6ckkeC0DKsoO4ipkutMCxoaT9io4Jal3N
         sbnBWImwiBgB45p9J6janBUfwpqMtDUUgNFDqXE+c7JVSOmdY/3oBkh1qgMMJxnMXZ
         gZeVhDqNrPYr23dlOtbBO1nhYI5rBjGrXKdvhyhcWF3Zf0xR2stG5pzN7+TJgCFQ6J
         N6NCh/80y7OBg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9A05C60A0F;
        Fri, 19 Nov 2021 11:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dccp: Use memset_startat() for TP zeroing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732261562.10547.7623991356352277593.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 11:50:15 +0000
References: <20211118203019.1286474-1-keescook@chromium.org>
In-Reply-To: <20211118203019.1286474-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 12:30:19 -0800 you wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Use memset_startat() so memset() doesn't get confused about writing
> beyond the destination member that is intended to be the starting point
> of zeroing through the end of the struct.
> 
> [...]

Here is the summary with links:
  - net: dccp: Use memset_startat() for TP zeroing
    https://git.kernel.org/netdev/net-next/c/f5455a1d9d49

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


