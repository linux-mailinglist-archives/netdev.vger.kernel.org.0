Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C306D495E63
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 12:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380151AbiAULaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 06:30:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43072 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349905AbiAULaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 06:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DFDF61A4E;
        Fri, 21 Jan 2022 11:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CAD8EC340E3;
        Fri, 21 Jan 2022 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642764610;
        bh=650N7PcNvKPfWeNXB7F2OHt2GjClFAE1LNtXV6TZyKg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bSSrynEUO7oQPZCZRtgjIlASjEIQ8wKjMo4OD/VDE9nSNudMUUTGddR1b5uN+Cq4g
         nTHa4f30HeVIbcNjMZxFY7f6Zsdw3bKmBlQjvTyAm+H2sGhA8WrLE7Qtj4lzDqc+bW
         dlC4UhGusHkSiCxpHZttpZfcitKBWgoA2LUrTdwsd+YR7mk1DFvrRgSbgIn4gMFvK8
         wuJj5I2AJPBg3WDnE/QZZtpXY147XACCHKD3Qjm2USZ0v8pRfxEknZb2rXfr27fXqz
         K88z7VcP2GxF2Qn05waayXcx/NgHPv6yNsHlzvtKq9sR6M0lp0wjmoRZTyNXdVvt4P
         xevvO7A5ic/Cw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AB09AF6079C;
        Fri, 21 Jan 2022 11:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2022-01-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164276461069.23387.15126169938356627984.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Jan 2022 11:30:10 +0000
References: <20220121110933.15CFAC340E1@smtp.kernel.org>
In-Reply-To: <20220121110933.15CFAC340E1@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Jan 2022 11:09:32 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2022-01-21
    https://git.kernel.org/netdev/net/c/67ab55956e64

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


