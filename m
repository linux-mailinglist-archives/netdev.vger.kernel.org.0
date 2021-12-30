Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F00481C93
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239533AbhL3NkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239507AbhL3NkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 08:40:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8433CC061574;
        Thu, 30 Dec 2021 05:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38AD8B81C68;
        Thu, 30 Dec 2021 13:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D571DC36AEC;
        Thu, 30 Dec 2021 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640871608;
        bh=QYKwUTX7hFMpTo0elK0xCFZEfzVC8y3dGIC3VctZu8U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IqwpYn9RsnPHJBh+of+VKEAymU0JWAkGn1EtEHi2zLsQanFFPhiyxEcRlHmw4cy02
         XCZLMxyaSQ8acR3pUnK7vyinZLeAMsnGSUr+6xRRXCZyYw4/8YeTRGFs+EO/oWyYSp
         cJnPk21BerOanSZL/wxNspIY+Z0PKnO02sCxJ/Be/epoqzsdPtEB5DgWRGyY/A4NYc
         EnKgZ4jbTgK0TXunT0HDidabssLsecz8YPmgW18Ui+HRHGtOe/IDo9YQU2/jeCuaNk
         2ZNG9yI5qevdKjGPLoXforQTkdT8MaGw89Ew0O/9GvhA7sLRZCBUO5jJXu3pKOd0hq
         FqTl7IYia0ExQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BDA6DC395E4;
        Thu, 30 Dec 2021 13:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] fsl/fman: Fix missing put_device() call in fman_port_probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164087160877.13913.3977817078027535723.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 13:40:08 +0000
References: <20211230122628.22619-1-linmq006@gmail.com>
In-Reply-To: <20211230122628.22619-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        igal.liberman@freescale.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Dec 2021 12:26:27 +0000 you wrote:
> The reference taken by 'of_find_device_by_node()' must be released when
> not needed anymore.
> Add the corresponding 'put_device()' in the and error handling paths.
> 
> Fixes: 18a6c85fcc78 ("fsl/fman: Add FMan Port Support")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> 
> [...]

Here is the summary with links:
  - fsl/fman: Fix missing put_device() call in fman_port_probe
    https://git.kernel.org/netdev/net/c/bf2b09fedc17

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


