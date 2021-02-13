Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52CF31A973
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhBMBUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229708AbhBMBUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 20:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 26F1864DA5;
        Sat, 13 Feb 2021 01:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613179207;
        bh=YXJWaq0qEw8BEYek6ZgZhcas0+bn2mcKf2nnseL+fsE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U4Bn7NzCzuDtQGHh6jXDIZUasbUsGut9Q70zWS8Ekzbyd2V7Nnkw6ivdSfBlXiu1A
         XyXI3m0dFy/O+SdMZJg5Jv2DftEf0+S8F5Ciffef3TUFlKFhdwbpTiOZWIdmg8IKXG
         qNc0OfUS3Hpz8SwQQau0SkXRYAoY2sftJNJohVPZweaz3YpoTrUgIIqXEFRqZNsW/m
         29ZfNXXhObBeqZjcbGXWbrvpis1fjt0muDVSIOI3VNvUvI+79x1aDoffojczy1N8CP
         x9LBHVN7G4KQvNuwRFnLkovXes0Y5pgequ3aO3r7opQDUBJuG0AxRu3HwvSWRJX3sb
         p/Q+1aoLlYGxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1713B60A2F;
        Sat, 13 Feb 2021 01:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2] ibmvnic: change IBMVNIC_MAX_IND_DESCS to 16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161317920709.20729.18067463905862223456.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Feb 2021 01:20:07 +0000
References: <20210212201630.9003-1-drt@linux.ibm.com>
In-Reply-To: <20210212201630.9003-1-drt@linux.ibm.com>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, ljp@linux.ibm.com,
        ricklind@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 12 Feb 2021 15:16:30 -0500 you wrote:
> The supported indirect subcrq entries on Power8 is 16. Power9
> supports 128. Redefined this value to 16 to minimize the driver from
> having to reset when migrating between Power9 and Power8. In our rx/tx
> performance testing, we found no performance difference between 16 and
> 128 at this time.
> 
> Fixes: f019fb6392e5 ("ibmvnic: Introduce indirect subordinate Command Response Queue buffer")
> Signed-off-by: Dany Madden <drt@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [net,V2] ibmvnic: change IBMVNIC_MAX_IND_DESCS to 16
    https://git.kernel.org/netdev/net/c/a6f2fe5f108c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


