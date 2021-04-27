Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D338D36CDCF
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239317AbhD0VXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:23:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237086AbhD0VXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 17:23:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B2B08613FE;
        Tue, 27 Apr 2021 21:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619558567;
        bh=XclifuiMUcGHM4fYxLsd7sqJvodk7gLGqLYKdsu3p+8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tlpq++/26O1PDSxeGB4WuMVU0sPFBxlhQjNTKFEzljMdQyCfNvVkWasWj3kIJBimU
         7+gxg9vq6s5T4Vp1zSliEhDSRxt1Tpf8xUbB5UwXGKlt5KqlL8wgX4J5+bMspPWBSC
         3MleBxgS2zwNu6j4wBVmKt4TTCpiGQSFAeZdg8tYKIDhy9u9QCvP3Q8uR8HTydfnXk
         Q4swNfoU8ZAqT6gJGVu+shcUb3BwbTdRGyC256vj/tmYAT+6/uriOEn1PKWuKG4UP4
         tNmQwAQmrUOGUFZRO5dGaBmnudXcsFDh7Pw35f5oqnwKNzqknliRV4dYA//zcy0uxi
         YaTEy+vhuzQJw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A950560A3A;
        Tue, 27 Apr 2021 21:22:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/tls: Remove redundant initialization of record
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161955856768.21098.16395317886854279600.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Apr 2021 21:22:47 +0000
References: <1619519302-59518-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1619519302-59518-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Apr 2021 18:28:22 +0800 you wrote:
> record is being initialized to ctx->open_record but this is never
> read as record is overwritten later on.  Remove the redundant
> initialization.
> 
> Cleans up the following clang-analyzer warning:
> 
> net/tls/tls_device.c:421:26: warning: Value stored to 'record' during
> its initialization is never read [clang-analyzer-deadcode.DeadStores].
> 
> [...]

Here is the summary with links:
  - net/tls: Remove redundant initialization of record
    https://git.kernel.org/netdev/net-next/c/3afef8c7aa2d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


