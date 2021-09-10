Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B64D4068FF
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 11:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhIJJVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 05:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231984AbhIJJVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 05:21:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 538566101A;
        Fri, 10 Sep 2021 09:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631265606;
        bh=TTnHjDM7hC2gqA+yHvVRiuvc2GFJfi+X+dpBc9bZjH0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BwfRFk0pR3YBkml0lP3z8+rCtgRe1dGGS7eAu6tXRAP42tzgnpSaGwpGyKybnA8ZK
         9eyGbK3o6EDqhn8YhB9Uju8ikO3mya1v16vyqOk9jYvU+RjWCIPTFtvtKwDOjJDelE
         qzSL3ra/zhrNMNUt3C6zgLIf/yEvvETfvRyu9hVeKBFo2+qYGmPnWt7WsZ+IfWXG01
         5DbbXgJNIam9aB1RbNCy4jscgcVeOioiITkBJPXFQ3XXDye6BcyRrDVK3WJQWQp1sg
         DTuIwMg2/bmoyfvsoVeOlGM9zOsJ3T7Guvde7Nn5qPmvvv1pnJLhsiuOIF2F5xgRgw
         2xpTwt5gGk2BA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4685B609F8;
        Fri, 10 Sep 2021 09:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] qed: Handle management FW error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163126560628.21841.13064285830398756933.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Sep 2021 09:20:06 +0000
References: <20210910083356.17046-1-smalin@marvell.com>
In-Reply-To: <20210910083356.17046-1-smalin@marvell.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        aelior@marvell.com, malin1024@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 10 Sep 2021 11:33:56 +0300 you wrote:
> Handle MFW (management FW) error response in order to avoid a crash
> during recovery flows.
> 
> Changes from v1:
> - Add "Fixes tag".
> 
> Fixes: tag 5e7ba042fd05 ("qed: Fix reading stale configuration information")
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] qed: Handle management FW error
    https://git.kernel.org/netdev/net/c/20e100f52730

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


