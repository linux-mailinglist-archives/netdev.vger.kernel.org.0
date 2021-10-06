Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544F6423FDC
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238881AbhJFOMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238832AbhJFOMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 10:12:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 828526115B;
        Wed,  6 Oct 2021 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633529408;
        bh=vocae2m6dSGS+52XuUaxcACciUmH7O1HU/UkhECfy2g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tz8rVHQvywSMdw3a9knliLZGFFHnfGbjgzHL1PAZd/yx9F2hM2uFkRBstZo8E38Vx
         89ZLev/3+q7jDuL0DSZcAlMjqr2F0vVdCrabHbLMF6Pgs2giFP7QMKhiHhJ5KdzpD4
         5lgq+d85lhqzNKvNx+Pojj7gPkzYAXW2SrAV5jCyexfs0oeCYACDeov4BN0JYkL8bm
         FvrJX2LxLB8AwLjmPyIsylN/SX9hJVz2tb1M03YFNn75M6JYbq0XDmKmHgeIn2GByB
         t94QjTob7F3Yksrs2k2ZB0ZpbmJq5bUTntXY/GSqAM67zC2NaCCnI4J4/aaqHqWW4R
         rTV9xAv5Dd9uQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7B17E60A44;
        Wed,  6 Oct 2021 14:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/3] gve: Correct available tx qpl check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163352940849.9599.5042360494603838549.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 14:10:08 +0000
References: <20211006024221.1301628-1-jeroendb@google.com>
In-Reply-To: <20211006024221.1301628-1-jeroendb@google.com>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        csully@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue,  5 Oct 2021 19:42:19 -0700 you wrote:
> From: Catherine Sullivan <csully@google.com>
> 
> The qpl_map_size is rounded up to a multiple of sizeof(long), but the
> number of qpls doesn't have to be.
> 
> Fixes: f5cedc84a30d2 ("gve: Add transmit and receive support")
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Signed-off-by: Jeroen de Borst <jeroendb@google.com>
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] gve: Correct available tx qpl check
    https://git.kernel.org/netdev/net/c/d03477ee10f4
  - [net,v2,2/3] gve: Avoid freeing NULL pointer
    https://git.kernel.org/netdev/net/c/922aa9bcac92
  - [net,v2,3/3] gve: Properly handle errors in gve_assign_qpl
    https://git.kernel.org/netdev/net/c/d4b111fda69a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


