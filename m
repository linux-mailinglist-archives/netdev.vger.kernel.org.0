Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CCF3E437A
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbhHIKAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233909AbhHIKA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 06:00:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 061C5610A7;
        Mon,  9 Aug 2021 10:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628503207;
        bh=SdW/SuNXFXN/vTK59yBXFSjJvE0WBr9/l9e+/dHNYpI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rzXjEJMK0FspaRrMDrmBnCh6hudGsBZqFVhIo/xlmnjxkCokw1sVUf592hDjTus4c
         bhYrwOqtAwd8ppi3xGIKEC1UM7bHl3/3hC1CXWABFHQlL+orjpz6CgkMb3cmzBo301
         n1Vd+whzD/vFGWR+buYuxYjYye+4YYyOd4OZNmJJ2pGXcLCCUApH/iXcUPC8zX9/Bn
         BMWvioRRnX6L1UxtIVFTtR807qE4xBBf29TdnBc6T+JpNguIFv93v7pURcZm0D+jqI
         yduMxM2Z2sTVY/Dv0UzBcPa1csJ0p+SJm/yNwn6dwdeoMRdxoTMpl2UzZy3Ie+r1H4
         1f56oGXAR/p2Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F385860A90;
        Mon,  9 Aug 2021 10:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/smc: Allow SMC-D 1MB DMB allocations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162850320699.31628.12804915327366228968.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Aug 2021 10:00:06 +0000
References: <20210809081014.2300149-1-guvenc@linux.ibm.com>
In-Reply-To: <20210809081014.2300149-1-guvenc@linux.ibm.com>
To:     Guvenc Gulce <guvenc@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, kgraul@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  9 Aug 2021 10:10:14 +0200 you wrote:
> From: Stefan Raspl <raspl@linux.ibm.com>
> 
> Commit a3fe3d01bd0d7 ("net/smc: introduce sg-logic for RMBs") introduced
> a restriction for RMB allocations as used by SMC-R. However, SMC-D does
> not use scatter-gather lists to back its DMBs, yet it was limited by
> this restriction, still.
> This patch exempts SMC, but limits allocations to the maximum RMB/DMB
> size respectively.
> 
> [...]

Here is the summary with links:
  - [net-next] net/smc: Allow SMC-D 1MB DMB allocations
    https://git.kernel.org/netdev/net-next/c/67161779a9ea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


