Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07E73AF5FE
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhFUTW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:22:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231495AbhFUTWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:22:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 186ED6135D;
        Mon, 21 Jun 2021 19:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624303205;
        bh=l9FBgRorjyY0WGNvcNv/KLuTbN+PP2BdonCV1ZyXiu0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BnyRcUF5e+9KJFXDZuleziIYRlhNPC81SpT3MZT8xiScTJLYtP/pbDpYIgeHMwrsa
         ypwPs6o42wH4wU0zmSd44PpkCExZNPzITRK1ciGLJwqgEHHmEBDBGKyCd/1kmpCfQ1
         uvuXjHbGd90G734KcJwtVP+BDS1Cpf6BNgM93Gq/9ABWhBjbcyt5FXAAOlRoS3NnYu
         7JWINqnDyEOMwkYfoWpom2UWKh0cEmngHvcRqsuGl17myKoWKeOf58w3uzQfwKzERT
         b3sXeFUWNUSNC3TKT/elSFLmuu8JEjpYkTg+4Olx+OBTSTWp2h63H2G9ERdEdkxY2I
         dQbFzZrUX2cSg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 08FB0609E3;
        Mon, 21 Jun 2021 19:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/smc: Fix ENODATA tests in
 smc_nl_get_fback_stats()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430320503.6988.10664396793932851537.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:20:05 +0000
References: <YM32HV7psa+PrmbV@mwanda>
In-Reply-To: <YM32HV7psa+PrmbV@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kgraul@linux.ibm.com, guvenc@linux.ibm.com, davem@davemloft.net,
        kuba@kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 19 Jun 2021 16:50:21 +0300 you wrote:
> These functions return negative ENODATA but the minus sign was left out
> in the tests.
> 
> Fixes: f0dd7bf5e330 ("net/smc: Add netlink support for SMC fallback statistics")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/smc/smc_stats.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net/smc: Fix ENODATA tests in smc_nl_get_fback_stats()
    https://git.kernel.org/netdev/net-next/c/1a1100d53f12

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


