Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A2343FCA0
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhJ2Mwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229692AbhJ2Mwg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 08:52:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6D7E461167;
        Fri, 29 Oct 2021 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635511808;
        bh=eJ7Ojg3SZPvnTtyOBrG+Fpf2Wkhzf0ymIPhxsRJEZYk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qt7RScTkJ2N5XoR/QhEPvsdU6t5i/jBZ/HRP/adBrOLOu8o6VfV8Zvb5cXL204egP
         +RLq3OtwTmdnsm9R1HB6KIcUihdK4XU0PsLRcRHbF9QmQxf3uqbB07lYdONK5pOauq
         yUwYPsEfi0wBwkmlqS4l5YNEspFImX8rj72MeGtYvCs2Plu1ZGy4Hl2By+cTFRwlyg
         bo4C70HwjaSgILWKBIBXTBM84TsdLQ7L1NGNHriEvH2AE3Rd4cNgHQpkXAI7a1yfon
         YMWjHRzaz2xAgKFNzOD4jzJPbpdjg6vItP3608MK/Y0qGs6n1GxSwVssA8qfOwp8CV
         YdUwye93MOifw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5E05460A17;
        Fri, 29 Oct 2021 12:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] nfp: fix bugs caused by adaptive coalesce
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163551180838.32606.5927261985281379723.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 12:50:08 +0000
References: <20211029112903.16806-1-simon.horman@corigine.com>
In-Reply-To: <20211029112903.16806-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, yinjun.zhang@corigine.com,
        louis.peens@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Oct 2021 13:29:01 +0200 you wrote:
> Hi,
> 
> this series contains fixes for two bugs introduced when
> when adaptive coalesce support was added to the NFP driver in
> v5.15 by 9d32e4e7e9e1 ("nfp: add support for coalesce adaptive feature")
> 
> Yinjun Zhang (2):
>   nfp: fix NULL pointer access when scheduling dim work
>   nfp: fix potential deadlock when canceling dim work
> 
> [...]

Here is the summary with links:
  - [net,1/2] nfp: fix NULL pointer access when scheduling dim work
    https://git.kernel.org/netdev/net/c/f8d384a640dd
  - [net,2/2] nfp: fix potential deadlock when canceling dim work
    https://git.kernel.org/netdev/net/c/17e712c6a1ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


