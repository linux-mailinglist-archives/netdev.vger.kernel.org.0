Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F36F397C6E
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbhFAWby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:31:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235023AbhFAWbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A08ED613CE;
        Tue,  1 Jun 2021 22:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622586604;
        bh=GF8cgu/orcAfXEkH72isRwxIix6N/6I5MuT3oJDvWzU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R62EZVnjx/c5qZXzO2o9uzubIzFhI4Q839IBInMN21jGjF793mqK9SaoJli/iwONm
         2KmyvCC66q5Nt8rx3tU30DnTmgdKZGieFMLKeD+0lwRkAHXAXBedzLn9REWYxOp35K
         UjYXaDuqaeTNuFL/sbDLTGH2OVCgTITJC3t8BpFeUaBMQB3XugMZWAHEzzOnAPuRfP
         LPHhaC1E1NWRGIJ/iKQHD3MWBjZM1eALyezdJLFqS41VroBGk2NEKCOpTEX9Upotcu
         xE0etaeN4rJ/vsjskmWvLvMcq2ezbZNmjaIwtgBQJ3X61iacjkJ8BJ7W6WbnhrrEWV
         r4dok+QJzaN9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9B59560A6F;
        Tue,  1 Jun 2021 22:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] fjes: Use DEFINE_RES_MEM() and DEFINE_RES_IRQ() to
 simplify code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162258660463.12532.12910120645202713688.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 22:30:04 +0000
References: <20210601062736.9777-1-thunder.leizhen@huawei.com>
In-Reply-To: <20210601062736.9777-1-thunder.leizhen@huawei.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 14:27:36 +0800 you wrote:
> No functional change.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  drivers/net/fjes/fjes_main.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)

Here is the summary with links:
  - [1/1] fjes: Use DEFINE_RES_MEM() and DEFINE_RES_IRQ() to simplify code
    https://git.kernel.org/netdev/net-next/c/d153ef5ce7db

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


