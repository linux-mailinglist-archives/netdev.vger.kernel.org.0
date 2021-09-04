Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE62400AB0
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 13:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbhIDKBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 06:01:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234995AbhIDKBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Sep 2021 06:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C4D33610A1;
        Sat,  4 Sep 2021 10:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630749605;
        bh=jHpuVOTPumI+Lfd5Paeo0YIOXpOnxRI4D416tO6vlRU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bqlkp12TPP05MwkZr1FjJnaryQj+IJ7gnHZeGc7HaDpZur4HP4IYtapL6PCURGxib
         RdW9uXtq5z/uNRNDR8ErLAa1kXX8NLtrJclKq825nwegRNkUZnvquroxFjaOEvjR7t
         LMdLR43Urc4MdBe+FfMaC0QUD1k+m0hIshky5e71LSuuqdf3hTr8dAU5LQhG0YtUNa
         ppxHBGwU8hvgfm7PPYH6WdF/RaCBhQ4oE1uZREU5Rv1P23xFulETiTkR1mG/tY4388
         n+mPSqLdm8824Ju/KChGSTJx5y2YVxK/UNZ7qvAe/9Tkyewthrre+GR3Pck8j8Xaxd
         BD2DSqvVforYA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B31DD60A5A;
        Sat,  4 Sep 2021 10:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] ethtool: Fix an error code in cxgb2.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163074960572.20299.4938752030864557270.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Sep 2021 10:00:05 +0000
References: <1630651353-22077-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1630651353-22077-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  3 Sep 2021 14:42:33 +0800 you wrote:
> When adapter->registered_device_map is NULL, the value of err is
> uncertain, we set err to -EINVAL to avoid ambiguity.
> 
> Clean up smatch warning:
> drivers/net/ethernet/chelsio/cxgb/cxgb2.c:1114 init_one() warn: missing
> error code 'err'
> 
> [...]

Here is the summary with links:
  - [-next] ethtool: Fix an error code in cxgb2.c
    https://git.kernel.org/netdev/net/c/7db8263a1215

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


