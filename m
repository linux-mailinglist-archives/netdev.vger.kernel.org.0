Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34E141C2FF
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245224AbhI2Kvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245177AbhI2Kvr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:51:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 07A6B6141B;
        Wed, 29 Sep 2021 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632912607;
        bh=n2RbhopvmM+AP6hOmKbbLOpsYSIAwHqnxKS7z6w6wNs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C13k3yCa4b67qxqO2ST3ONcz8v0bQBbx8W262sl5zCA7NPSyDJH5IDXz2wMHCiSrk
         8Rlgfr+XEXLmQhxZqhCFVadMseoDHh4YTYbmZOsfvNn8vt3mKanLtgu2m8UrDAWJs2
         oW9whaRufDRbNzt6kgg9uUNp6oGkFm7nC6DmFrIzRNwe6HFEKPWvSb9wv+7zEXVjn4
         WA8aKDR3ArF3qapJpdESZCuyowm4amDL0angrW8xnEyHx8lykP1h6o8ZRAqRHjhVEV
         rvp0bL7NyE8e+1T3phXDBPhTdjbjjwYG4n4JeHq+88uScncnZ0xPG5j/3Q1hr+yi0G
         e/sAADSrscxsQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EF00060A9F;
        Wed, 29 Sep 2021 10:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next -v2] net/ipv4/datagram.c: remove superfluous header
 files from datagram.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163291260697.31673.11208020018884838621.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Sep 2021 10:50:06 +0000
References: <20210929053109.23979-1-liumh1@shanghaitech.edu.cn>
In-Reply-To: <20210929053109.23979-1-liumh1@shanghaitech.edu.cn>
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 29 Sep 2021 13:31:09 +0800 you wrote:
> datagram.c hasn't use any macro or function declared in linux/ip.h.
> Thus, these files can be removed from datagram.c safely without
> affecting the compilation of the net/ipv4 module
> 
> Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> 
> 
> [...]

Here is the summary with links:
  - [-next,-v2] net/ipv4/datagram.c: remove superfluous header files from datagram.c
    https://git.kernel.org/netdev/net-next/c/6a832a6c72b9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


