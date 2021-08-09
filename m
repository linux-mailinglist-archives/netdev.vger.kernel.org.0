Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2113E4F69
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 00:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236837AbhHIWkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 18:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234408AbhHIWk0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 18:40:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D41FB60FDA;
        Mon,  9 Aug 2021 22:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628548805;
        bh=g1nUGkg6GQlvm4InUSkXcMNL1PaQ3uFk3HwiLu5gbhE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Efw0FYxaweSI6WaitbLRaJBj3UYpx2qaj+eK2pioYbaN+27tC6ymwTLP2FGaEFJ7u
         HN8NoDlV5sgxPR8YOq/4xvJDaVKBH4QWSWmN7Ok9et3XtHFXxiv8A0xn3FksqrtrU4
         4jQBVyrVaWk2hHjzJyLSPxPgTbJ1LvD0cWdiUE6m5Pswl3/9t1n2BRBBQCU0GT6LKF
         mVHtSWmTRRfQw71UDeggueuyDavp0sc39T2iml8p0AZaPkeKdjtIlvXXJxT+FTonzN
         /gePevs2n4+q+jKxTyDuseo7xphSNUEr5o0tuiYwfG5hUrK3XGZTBrYKKnDr/J1lJB
         6YXE3QVs9rkXA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C352C609B8;
        Mon,  9 Aug 2021 22:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: openvswitch: fix kernel-doc warnings in flow.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162854880579.3525.12593633041465975593.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Aug 2021 22:40:05 +0000
References: <20210808190834.23362-1-rdunlap@infradead.org>
In-Reply-To: <20210808190834.23362-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  8 Aug 2021 12:08:34 -0700 you wrote:
> Repair kernel-doc notation in a few places to make it conform to
> the expected format.
> 
> Fixes the following kernel-doc warnings:
> 
> flow.c:296: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * Parse vlan tag from vlan header.
> flow.c:296: warning: missing initial short description on line:
>  * Parse vlan tag from vlan header.
> flow.c:537: warning: No description found for return value of 'key_extract_l3l4'
> flow.c:769: warning: No description found for return value of 'key_extract'
> 
> [...]

Here is the summary with links:
  - net: openvswitch: fix kernel-doc warnings in flow.c
    https://git.kernel.org/netdev/net/c/d6e712aa7e6a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


