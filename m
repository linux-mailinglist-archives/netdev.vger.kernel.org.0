Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E0845F56A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238848AbhKZTvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237756AbhKZTtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:49:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47C5C0613D7;
        Fri, 26 Nov 2021 11:30:12 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A798B8288D;
        Fri, 26 Nov 2021 19:30:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id EE0AC603CE;
        Fri, 26 Nov 2021 19:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637955010;
        bh=RQmdRU2dBAKV6cC3ApGSpuKLG1bLO208xQ+fST/dde8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JL91zVZYWRH7nnNsh1M6TrB+E1XOlQQhqWE4T4829tVrp+u7Y7mFDH6IZGxGzFKZq
         7XNrxYYWkA/+PiAEJBDqaB7MK6+4AsRqQ/jNgMxNln2nn9HEjxsOvXtC3/3k/7FvPb
         sTQ2A3FGMQ0hPFpnlM58u/4m8Piej7zq+mxmXBIfnJN1QIKAUXxD/U193ewm0hIk53
         YkkSGk0vwUFWObggKN3I0j9rRDPZN8kEJ9Dr+FvJLgWiKKmVVB2aj80Vt4fNgkxgnv
         pqfNjMlVq9l5H9s3tPC+N0NC5J16bqb2+RPNsEv9Bf4LTT3Prq4ntbCnU13z/CV2A2
         u4h1zA9jOd2gg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E856260A6C;
        Fri, 26 Nov 2021 19:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: fdp: Merge the same judgment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163795500994.14661.8771245042973034492.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 19:30:09 +0000
References: <20211126013130.27112-1-samirweng1979@163.com>
In-Reply-To: <20211126013130.27112-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wengjianfeng@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 Nov 2021 09:31:30 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> Combine two judgments that return the same value
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  drivers/nfc/fdp/i2c.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - nfc: fdp: Merge the same judgment
    https://git.kernel.org/netdev/net-next/c/af22d0550705

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


