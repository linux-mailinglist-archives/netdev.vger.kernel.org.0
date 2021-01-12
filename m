Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907D62F2520
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbhALAuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728318AbhALAut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 19:50:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E23B225AB;
        Tue, 12 Jan 2021 00:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610412608;
        bh=ZvM12w1dpi1IFpqJn6ilFHd5zrD0OROGkeh4C8N3tTo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MR9xmzzq1qwYFxfKfcb0cOdU/ipwRiRh13E53H3DdLCp/A6OsTeZsFJna1+rxubgo
         LZYqECpAR+wfjrpaWyDKw7PHPBF/xv3qCJ026G5N9+lGX6q7MmifWYgOQxpolxNXQv
         qDpplciFESOSWSQ67GwRXMUErxaOxS7ICv8XkEHR28Qw4sU2GLb1m0BX9Opw885mcG
         hE50FXQv34G0CjQdlz3HmooBypmCprO0loglqyCrlUBztpxrqKlZAnGhYULxDicMxS
         4xUL09jFvyYOK2yU5AYlWYjkzR34fiTVBqnoOyXLiHpSLMxjHnS0hwhwiT6FPKqLsS
         WyK2nNTAiilOA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 3C64A600E0;
        Tue, 12 Jan 2021 00:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: marvell: prestera: Correct typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161041260824.10251.7012028065285144107.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jan 2021 00:50:08 +0000
References: <20210109050622.8081-1-f.fainelli@gmail.com>
In-Reply-To: <20210109050622.8081-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, vkochan@marvell.com,
        tchornyi@marvell.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  8 Jan 2021 21:06:22 -0800 you wrote:
> The function was incorrectly named with a trailing 'r' at the end of
> prestera.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Jakub, David,
> 
> [...]

Here is the summary with links:
  - [net-next] net: marvell: prestera: Correct typo
    https://git.kernel.org/netdev/net-next/c/22fe6b04b460

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


