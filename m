Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1FE3AA4F3
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 22:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbhFPUML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 16:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232586AbhFPUMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 16:12:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 94B1D613CD;
        Wed, 16 Jun 2021 20:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623874203;
        bh=4Gt/aoI3FNo6u7V9Lxpm3MdaYQU+NTOW+paRxy40gyY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Amxym1gDYBqP1qzPAel24TXflq6JFkmZ/YLnxTSQYTRI2nBvcmM3L1vtfsqC2SdrK
         xw2cJ11aby/LloHWOj6a3+J5ZvFL2Ijrfhb1HZHBuzSzykZ4Pgv4kWTJlnwpKow0Sq
         kkVuF3ur/quRFHpQqa0yarcBQEtP3n3KLTEb8zpLSHbDX0OeJ6ewsQFPQQGHrzOTmW
         wnT3SYw8KfgVtadI6AD5qYAHOOMPSLnz0A3ht+n4f/nLu129avANwuAwRcb85PpItk
         4uLkkfrFuLUT0c8umBn0zpoCmtBkg+3qMZ6Ii7OH6vVVtdXFUd9+YK9L5uHdU1hQhH
         qncwTVXsFdcIg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 87BC260A54;
        Wed, 16 Jun 2021 20:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] r8152: Avoid memcpy() over-reading of ETH_SS_STATS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387420355.22643.16457529126274171882.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 20:10:03 +0000
References: <20210616195303.1231429-1-keescook@chromium.org>
In-Reply-To: <20210616195303.1231429-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        hayeswang@realtek.com, lee.jones@linaro.org, ejh@nvidia.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Jun 2021 12:53:03 -0700 you wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally reading across neighboring array fields.
> 
> The memcpy() is copying the entire structure, not just the first array.
> Adjust the source argument so the compiler can do appropriate bounds
> checking.
> 
> [...]

Here is the summary with links:
  - r8152: Avoid memcpy() over-reading of ETH_SS_STATS
    https://git.kernel.org/netdev/net/c/99718abdc00e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


