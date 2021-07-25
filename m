Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FDF3D5051
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 00:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhGYV3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 17:29:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229604AbhGYV3f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 17:29:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3FB0860698;
        Sun, 25 Jul 2021 22:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627251005;
        bh=xeB5d2wQRPAQdHux5Mvt90JObNV/MRY3ROx403FAlP0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iOLrybFykCaDAQiDzKvk1yab6GfHtrSVzzYzjSNAppioKlO87d9Umlpf04ENE+x/0
         wX09SuO7Lx+pT1+blF8ywirbWoH3AZK4LzJlr3t10carTndT3eWZRcU7ExGaa25odc
         2QQFxwan5kOPF/U7dIIDLZ1PrLDFM0mDOA3+FzyD6g4oFXCBTXidU50gnlZJ43ogox
         iz4phHdC70o6oDmQ3d35sXJIyIZBfpy7QrIFcrFpEk4QZ/lKZV/HSKeXmhD2Lb7opQ
         iOkiGo1/pGrAi4ZgHlAY7ve3q3cr2kipSYLvRRd8F2Xu2dtW3kEFPQRnKr2i7Ldq7o
         u7FP8FqfztpZQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 33B9860A39;
        Sun, 25 Jul 2021 22:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: qede: Fix end of loop tests for list_for_each_entry
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162725100520.14953.14085680875273018061.git-patchwork-notify@kernel.org>
Date:   Sun, 25 Jul 2021 22:10:05 +0000
References: <20210725175803.60559-1-harshvardhan.jha@oracle.com>
In-Reply-To: <20210725175803.60559-1-harshvardhan.jha@oracle.com>
To:     Harshvardhan Jha <harshvardhan.jha@oracle.com>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 25 Jul 2021 23:28:04 +0530 you wrote:
> The list_for_each_entry() iterator, "vlan" in this code, can never be
> NULL so the warning will never be printed.
> 
> Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
> ---
> From static analysis.  Not tested.
> 
> [...]

Here is the summary with links:
  - [net] net: qede: Fix end of loop tests for list_for_each_entry
    https://git.kernel.org/netdev/net/c/795e3d2ea68e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


