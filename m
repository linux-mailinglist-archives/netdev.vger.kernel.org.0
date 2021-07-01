Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C723B98CD
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 01:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbhGAXCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 19:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234126AbhGAXCf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 19:02:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F07CF61410;
        Thu,  1 Jul 2021 23:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625180404;
        bh=yXQImC86OQF+PrYXvWynpoxiBI9gssliyF0Zjj81fQc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ktXTTzG33hcqFMyzbejm7XRsFst0F9WIfS3nGVtHekQCBvD8ipzgYgEsxyi8ZAwCF
         PVetiyP6Iass724caciLE0pxdwBfO7019Tn6rBpcKHsCp2CW2zLCxi1t5Nrf4nvJWU
         LfDr378vfN4uyS5oUA7RqYNiWwJYlmYjp3NUvH0A6YwL73PQbpHreu9lnesQKtGKZT
         RtzJdwRlr7L+ocIX9GgifRIGrmMPN2zmEHDeGNV23YUzj4V+H2xOuMHkBKmVwnijPu
         4zHoq7rr7ec7BK+4sVn8B6waw9eXd4bZDQ4M9W2kpp7XUO2HbaUNrio0wVnfKHesbl
         btwI6+kKDEc/A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DFB5E60A38;
        Thu,  1 Jul 2021 23:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] s390: iucv: Avoid field over-reading memcpy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162518040391.15463.2980710384893731430.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 23:00:03 +0000
References: <20210701154407.3889397-1-kgraul@linux.ibm.com>
In-Reply-To: <20210701154407.3889397-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        guvenc@linux.ibm.com, keescook@chromium.org, jwi@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  1 Jul 2021 17:44:07 +0200 you wrote:
> From: Kees Cook <keescook@chromium.org>
> 
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally reading across neighboring array fields.
> 
> Add a wrapping struct to serve as the memcpy() source so the compiler
> can perform appropriate bounds checking, avoiding this future warning:
> 
> [...]

Here is the summary with links:
  - [net-next] s390: iucv: Avoid field over-reading memcpy()
    https://git.kernel.org/netdev/net/c/5140aaa4604b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


