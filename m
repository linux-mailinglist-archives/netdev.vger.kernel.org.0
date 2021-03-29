Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333EB34DC91
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhC2Xkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230244AbhC2XkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1FC9E619B6;
        Mon, 29 Mar 2021 23:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617061212;
        bh=Qk7SJFtrDWduVqU8xPUppOOejmbZrjOF5V8cTmsypyI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hazSrk2UDUyY1wtvope7Hfq+alq02Eky5swVoFO1SyQJXWYKpOnuClVyHJ/KrRWau
         mtIX4oeEUOKq+vDQMnRhp7ejNIWZHIckpef0Dq0Pt+yz9lVSb6e5bC+sU/KE+DRyRa
         y53EArf54vCdkqw85ee4C1ss90emF+7UP+hwcEWdhik8YJhPfOrAq94qd1uR06HQFg
         XSsKmkooGfMgsNwZYBoEYJhhbx60zJ1oLUma7ksG1cd2p1v4yfaarqYEwImPVBzAvt
         Ra96Kpeh/g58YW1bNUEdZ2zhTq3N6ww0cKyimitm75w+4l6wuXydrJaAzITzwqEsu7
         lXYcDF+OxGFaw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 13AC260A56;
        Mon, 29 Mar 2021 23:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: tipc: fix htmldoc and smatch warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161706121207.22281.4191926226819709248.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 23:40:12 +0000
References: <20210329171731.2332713-1-jmaloy@redhat.com>
In-Reply-To: <20210329171731.2332713-1-jmaloy@redhat.com>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, parthasarathy.bhuvaragan@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 13:17:31 -0400 you wrote:
> From: Jon Maloy <jmaloy@redhat.com>
> 
> We fix a warning from the htmldoc tool and an indentation error reported
> by smatch. There are no functional changes in this commit.
> 
> Signed-off-by: Jon Maloy <jmaloy@redhat.com>
> 
> [...]

Here is the summary with links:
  - tipc: fix htmldoc and smatch warnings
    https://git.kernel.org/netdev/net-next/c/02fdc14d9bf1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


