Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFA93AF82D
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhFUWC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231715AbhFUWCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 18:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EA40C6128C;
        Mon, 21 Jun 2021 22:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624312804;
        bh=vX+RaGheyY1gsEhdZsoG6F0qs/k+AUQKs69sAR768xE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jTff1tasDIgFelIUw1rB8efd+bqGw/zY7+j2UEW3aBeabY0c6j22pYpcoSgW0/CC5
         wZ1hGkVDpm7gr8zaCCiqsDtrWQ7mT+YhkEgMq3okp4yaNZsMMz0NJ4K3NG1K9rIlHD
         EuKyAt655iNB0YkzW1dsHEQJ/KMFk+BJMAyXQUqaMd2g7KCPuaM2aT4ExIVX8Sq1mp
         S/f9ZiQ1MZ/cF6ixTN6d18VDj1neaqd/0WtWSmJ/8TV7xGUyaeF1C16qv4wryZpRV5
         sPy9u+s9AsVsVyHP9ShZjHg9u55SRAZTWfn76/SlCxECF5lzbvTXtO3waAWbZd0/0S
         dLa3OZpb2+tVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E294160952;
        Mon, 21 Jun 2021 22:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ibmvnic: Use strscpy() instead of strncpy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162431280392.22265.13378585860049565329.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 22:00:03 +0000
References: <20210621213509.1404256-1-keescook@chromium.org>
In-Reply-To: <20210621213509.1404256-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     davem@davemloft.net, drt@linux.ibm.com, sukadev@linux.ibm.com,
        tlfalcon@linux.ibm.com, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, kuba@kernel.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 21 Jun 2021 14:35:09 -0700 you wrote:
> Since these strings are expected to be NUL-terminated and the buffers
> are exactly sized (in vnic_client_data_len()) with no padding, strncpy()
> can be safely replaced with strscpy() here, as strncpy() on
> NUL-terminated string is considered deprecated[1]. This has the
> side-effect of silencing a -Warray-bounds warning due to the compiler
> being confused about the vlcd incrementing:
> 
> [...]

Here is the summary with links:
  - ibmvnic: Use strscpy() instead of strncpy()
    https://git.kernel.org/netdev/net-next/c/ef2c3ddaa4ed

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


