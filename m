Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BAA3F72B7
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239811AbhHYKKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238910AbhHYKKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:10:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6526C61103;
        Wed, 25 Aug 2021 10:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629886206;
        bh=yDPDAMbJBJ5nJcrraLiSOsK0F6HwLn31hVOm4+H8O1s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D7KVoTfNlXGqXj3iSYqkmPDTNKGtWqQLaadNfaB/NmPMNjdXnrdlUZaT2pS0qLTVA
         nX4Y0RmSQ1bv2yv2BKqCdRHnvphD4+utPtIIG9Ng5HAPRZpkswQdlysXaJLKj/x27I
         7h5ZueDeC7YyJrauKl+IevO2kUrI24ZC0ue68aoxXYOEabpZSpyi79nuew+jUZm+8U
         X7Bt9Pn+BMEZxUGorCC9hUqjxXMVzY0TK+8DryU7GoYmkWpyWRrd6K6cIIHEWaUtoh
         Q/86OjviKpfHRAhmLqEisHzTzFeL26OQ0dv/oVpFUiLvfPICC02KRffi6ZdABFucID
         /rNt3lZSjX5lw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 59EEC60A12;
        Wed, 25 Aug 2021 10:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qede: Fix memset corruption
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988620636.3256.13580298647321859860.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:10:06 +0000
References: <20210824165249.7063-1-smalin@marvell.com>
In-Reply-To: <20210824165249.7063-1-smalin@marvell.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        keescook@chromium.org, aelior@marvell.com, malin1024@gmail.com,
        pkushwaha@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 24 Aug 2021 19:52:49 +0300 you wrote:
> Thanks to Kees Cook who detected the problem of memset that starting
> from not the first member, but sized for the whole struct.
> The better change will be to remove the redundant memset and to clear
> only the msix_cnt member.
> 
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> 
> [...]

Here is the summary with links:
  - qede: Fix memset corruption
    https://git.kernel.org/netdev/net/c/e543468869e2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


