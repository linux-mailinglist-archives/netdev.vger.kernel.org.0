Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CD43A4884
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 20:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhFKSWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 14:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231191AbhFKSWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 14:22:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9A589613C6;
        Fri, 11 Jun 2021 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623435604;
        bh=+rI/yPlO8PfkgRay0Cw4WqM7y+82qGwqJpRc3JW5kas=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fk0vJpH3+Q73JfBkfCtq0ZRD1y7TqS5Qzye1sJVbbzsVF8tvsQM6OrDbZ29fU/wNf
         MYXVrRD0n/pUJW7Z4YrUKJ8m7D0NHtCShb7xK+4h+00Ut4iYLFJD+07t+lgg2DJcMU
         Wzo7GE46R3Dg1Qmi03wCezwos8xuOAVjXzrC2HDHv7oDm+zL6vLILgY5dSWNzwjcwg
         OTtFQkctNZvOzFa9nngGBQvHpJkJ8eygS5JoJbtUcKKWcXs5KGeVnHVnwbhvllcZch
         zMytoCaiMADjJzZwn1Ah0b7VYG5bXumZor0W7fTy4QFGRzwZMz+E0juwlNfR96M2f6
         iw8+NtGqANKqw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 872D960A49;
        Fri, 11 Jun 2021 18:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] alx: Fix an error handling path in 'alx_probe()'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162343560454.20873.16773485320756110269.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 18:20:04 +0000
References: <2d0fa41ff6266f38b04b7e46651878c70d32d5ef.1623391908.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <2d0fa41ff6266f38b04b7e46651878c70d32d5ef.1623391908.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        johannes@sipsolutions.net, bruceshenzk@gmail.com,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 11 Jun 2021 08:13:39 +0200 you wrote:
> If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
> must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
> call, as already done in the remove function.
> 
> Fixes: ab69bde6b2e9 ("alx: add a simple AR816x/AR817x device driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - alx: Fix an error handling path in 'alx_probe()'
    https://git.kernel.org/netdev/net/c/33e381448cf7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


