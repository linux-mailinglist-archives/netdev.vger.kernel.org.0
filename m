Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DE83CFC7C
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240006AbhGTN7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239999AbhGTNup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5CB9561244;
        Tue, 20 Jul 2021 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626791406;
        bh=yqPfKPvezPfquBcaYh/moLLHAyfcdAjJqajDiNGMRow=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kLtUnEPEpJH36c/9XM0M2zqHxNq7lU+Oc8lh6tZag4CfXqiPwSt9Bv7t/Z1wu6OH5
         s6y7+vfkbLK0kD2E10DiYNneutGGe/szX+0mFMQD9Bl6YTanczlfLC8LehWd5JKsrC
         QWAnvGVI7jk28gRgmScKUh7N63E4fLUVR/YU1hzY4/Qk3FOSK+XgDDvXa8pBU5EMqf
         Vyo1jGfPTPwYM0rw2rzpKHdIZaKeBlFnOsjJSj7Idcmh2/5myE9siT3o7qKJeDm7bS
         IqXpVcsd9gZFiQE/6qqhnZvlZu+Hqfh0xRGtV+F0KCwuXwxGUF6udegyOmMAARl4Ha
         DG0dREYg/z/Ig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 54AFE60D02;
        Tue, 20 Jul 2021 14:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: marvell: clean up trigraph warning on ??! string
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679140634.23944.13639576500085016559.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:30:06 +0000
References: <20210720130311.59805-1-colin.king@canonical.com>
In-Reply-To: <20210720130311.59805-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     thomas.petazzoni@bootlin.com, davem@davemloft.net, kuba@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, netdev@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Jul 2021 14:03:11 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The character sequence ??! is a trigraph and causes the following
> clang warning:
> 
> drivers/net/ethernet/marvell/mvneta.c:2604:39: warning: trigraph ignored [-Wtrigraphs]
> 
> [...]

Here is the summary with links:
  - net: marvell: clean up trigraph warning on ??! string
    https://git.kernel.org/netdev/net-next/c/fa660684e531

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


