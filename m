Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F59A3B3586
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhFXSW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhFXSWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 14:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E0D8F613B1;
        Thu, 24 Jun 2021 18:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624558803;
        bh=OZBTVtRaVWQrL3KSyZXTy7QijVkyD/HNAgjEkbH4bLY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UtOkphaqM7Z540x7CBoOXfwrMBxeXADbLmtCRqfCzHWFJn6HuSyaoW6B+YE8Hid81
         wWJ5RrmZfTEoujvuVIB7qpwWnQkLjpIiQIzRKvmD5p35RSQBaJJV43fqDPUdunQcco
         17/Kx6heYG32EapLuRtzMT5bhfB14JXuRhGObDvCiiOrvT1STEiN3HLe1lUbk7IzOs
         7hc28c11AuXKBW2ouyHrhJuWBrroc2rFtMX5ON+kQ//hN3PjVBGryF91UMEx1AE9P1
         YyTcmmnaixRRjhRfL9iiXn15zXWSAbH168RHTqpypY8LaxEo/8ao+Ogp1AHjt9IIRj
         M49+zXOtUigvA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D553560978;
        Thu, 24 Jun 2021 18:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/2] net: retrieve netns cookie via getsocketopt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162455880386.31056.3165434549238056943.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 18:20:03 +0000
References: <20210623135646.1632083-1-m@lambda.lt>
In-Reply-To: <20210623135646.1632083-1-m@lambda.lt>
To:     Martynas Pumputis <m@lambda.lt>
Cc:     netdev@vger.kernel.org, edumazet@google.com, daniel@iogearbox.net,
        ast@kernel.org, lmb@cloudflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 23 Jun 2021 15:56:45 +0200 you wrote:
> It's getting more common to run nested container environments for
> testing cloud software. One of such examples is Kind [1] which runs a
> Kubernetes cluster in Docker containers on a single host. Each container
> acts as a Kubernetes node, and thus can run any Pod (aka container)
> inside the former. This approach simplifies testing a lot, as it
> eliminates complicated VM setups.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: retrieve netns cookie via getsocketopt
    https://git.kernel.org/netdev/net-next/c/e8b9eab99232
  - [net-next,v2,2/2] tools/testing: add a selftest for SO_NETNS_COOKIE
    https://git.kernel.org/netdev/net-next/c/ae24bab257bb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


