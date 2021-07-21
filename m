Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D753D135B
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhGUP3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230378AbhGUP33 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:29:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E22946120D;
        Wed, 21 Jul 2021 16:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626883805;
        bh=POE4WgA3OdIZgGtz+HPgjoU8QHdTV77IyqKjUfV44P0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KaYyWQ2C5tAFZOkcej4TQMwEmnlyCE931m0mMhsrOqEHiyr3HvbOhEt3Resd06Pl0
         KmB2YRQhe1GHQL5uoLmCxS3T1dIm5sDcRBi75h3+cmjRXFk08e3zPpW57UjF6q7Ahr
         qaZzyTqTivVo6ZX0Tttc8FGuA5QsAGoAU6F/3o7Ak1pmQYdPeeO4OGDF0Ddcf5ye4g
         8NBSX8DTWmLOKFEO4BnrTueKb06PPTcPrYZlsE0bd2ZzmM4mFNzyy2JFJdEFsjBdnD
         gg8+pxln/yDNuwtzZc5AUp9pZdX2zP6Q7DJEnG/ExUrLy1PoHy8wgSYpyMDDUgJixP
         RDpqw13tcVSUw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D535060CCF;
        Wed, 21 Jul 2021 16:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ionic: drop useless check of PCI driver data
 validity
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162688380586.30339.9133086652433011547.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 16:10:05 +0000
References: <93b5b93f83fae371e53069fc27975e59de493a3b.1626861128.git.leonro@nvidia.com>
In-Reply-To: <93b5b93f83fae371e53069fc27975e59de493a3b.1626861128.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, snelson@pensando.io,
        leonro@nvidia.com, drivers@pensando.io,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Jul 2021 12:54:13 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The driver core will call to .remove callback only if .probe succeeded
> and it will ensure that driver data has pointer to struct ionic.
> 
> There is no need to check it again.
> 
> [...]

Here is the summary with links:
  - [net-next] ionic: drop useless check of PCI driver data validity
    https://git.kernel.org/netdev/net-next/c/524df92c1907

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


