Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0023ED1F8
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbhHPKai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230250AbhHPKah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:30:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 194D061BB4;
        Mon, 16 Aug 2021 10:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629109806;
        bh=jCkUPYoeziPY7nIGB0kStqO+W50IyRNA01ftXJyMfSg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gj9xoEM1EFDEm9ylS1r6VgoRKc71MSV/ZTZpOFED1jMJrYPGECx4eayyzWPSPFAtY
         DrfUGjbkPW6wISWp6NX4tgGCyEwIexBa+CiYUNq9hRJZ89kOUMEmFV6muFyZh9QJCo
         JsgVwl0F00dWRnPSAgDMrZPdqovPLXp7iVnxyyA1Zay83sTDbCj4tEeXKIfKXxpicD
         JS1+O7PdOonaeIIHR3t4gph2mxOB9zEyfIEJ6J13NERgUSn3RR+HxsJ6l8WSRD/tdQ
         t0eHbwH4sU0whfsiq5JnI1RBF88VMSlEuyyFY+sCUo41OguXV7pI63VPdvp9JxPFps
         0o/ARSYOtNXFA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0D2F5609CF;
        Mon, 16 Aug 2021 10:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] qed: qed ll2 race condition fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910980604.576.14276820310361436253.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:30:06 +0000
References: <20210815110508.19434-1-smalin@marvell.com>
In-Reply-To: <20210815110508.19434-1-smalin@marvell.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        aelior@marvell.com, malin1024@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 15 Aug 2021 14:05:08 +0300 you wrote:
> Avoiding qed ll2 race condition and NULL pointer dereference as part
> of the remove and recovery flows.
> 
> Changes form V1:
> - Change (!p_rx->set_prod_addr).
> - qed_ll2.c checkpatch fixes.
> 
> [...]

Here is the summary with links:
  - [v3] qed: qed ll2 race condition fixes
    https://git.kernel.org/netdev/net/c/37110237f311

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


