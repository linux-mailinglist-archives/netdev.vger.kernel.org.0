Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157614274B3
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 02:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhJIAcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 20:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhJIAcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 20:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EAEA660FE3;
        Sat,  9 Oct 2021 00:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633739408;
        bh=qhYam4hwST7tvzpY9UAnOFKz5QbNcEHRVuNJE/H6WMs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eBwEAxnU8XuiuSFiu8940iJWuGXcq5dPIRWUycvpSmMkYNRjSI/hHt9L3OwEjmFuD
         yNukjaME/HXKYfiRhLTQjG5h50eA54+BF3CvEaE1DhAjOvtZzMNNJZTrnsEWijHgb8
         iWVWuYGDMFoN0a0XBh/yd7+zGDzhCd2DbaApFpVbDbtmFQmcWdAq/X2S6MB31xhwKS
         IY/MAEQAcMYxklfyZb27kuDpghfr07/Cggc+kP6rGFSGBHgLukERYIENIQtmDw6MLQ
         4SsKdkoxx3sc3+osDM/6I3cdvY7LkzDSzWwwNSuGO2A/K+zTNBhoApLVwjCvs9BDPS
         tXgnuCfZbPRMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E3482608FC;
        Sat,  9 Oct 2021 00:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mlxsw: item: Annotate item helpers with
 '__maybe_unused'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163373940792.10203.2644888402367244918.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Oct 2021 00:30:07 +0000
References: <20211008132315.90211-1-idosch@idosch.org>
In-Reply-To: <20211008132315.90211-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com,
        nathan@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  8 Oct 2021 16:23:15 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> mlxsw is using helpers to get / set fields in messages exchanged with
> the device. It is possible that some fields are only set or only get.
> This causes LLVM to emit warnings such as the following when building
> with W=1 [1]:
> 
> [...]

Here is the summary with links:
  - [net-next] mlxsw: item: Annotate item helpers with '__maybe_unused'
    https://git.kernel.org/netdev/net-next/c/f12e658c620a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


