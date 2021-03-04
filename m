Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050EC32C9D9
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 02:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244259AbhCDBMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 20:12:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239562AbhCDBAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 20:00:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B37964F47;
        Thu,  4 Mar 2021 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614819613;
        bh=pbLbqUe2ezgPfIqCgBPpfZI6aj64Lg26MM3O9GwA58I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zf0V9WQWONy5P2DVlciUi2otNy2C3FIcqNK8EfS91UXzCe7IITX9D34roJcFhTf+I
         NfATcUhhiZfzAswZTO/5x7F7418tFqpNFcey9PruffyV8pj01lKUw8E1MQqiqivW/A
         FOrplg4r0znukubXmW4mNDtMuJRzijeH29VXqpmLc8vaWqC84OdXaL5PrwpAojbcCq
         jxYdgExEklJ6FU4ozA/It66Spzmr5Lb9N57ZxaamqohdzIiI9m8C/O0ZsqC+UnDduM
         aYl5b7+M+TRBUyXBUfvfbMDEpzqTr8XlYBluPR8xfeETNoVTw8Sms5DpJoty+ypcVr
         YoOI2TUFhQn7w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6D2BB600DF;
        Thu,  4 Mar 2021 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: l2tp: reduce log level of messages in receive
 path, add counter instead
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161481961344.28060.10946640973574514262.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 01:00:13 +0000
References: <bd6f117b433969634b613153ec86ccd9d5fa3fb9.1614707999.git.mschiffer@universe-factory.net>
In-Reply-To: <bd6f117b433969634b613153ec86ccd9d5fa3fb9.1614707999.git.mschiffer@universe-factory.net>
To:     Matthias Schiffer <mschiffer@universe-factory.net>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tparkin@katalix.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  3 Mar 2021 16:50:49 +0100 you wrote:
> Commit 5ee759cda51b ("l2tp: use standard API for warning log messages")
> changed a number of warnings about invalid packets in the receive path
> so that they are always shown, instead of only when a special L2TP debug
> flag is set. Even with rate limiting these warnings can easily cause
> significant log spam - potentially triggered by a malicious party
> sending invalid packets on purpose.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: l2tp: reduce log level of messages in receive path, add counter instead
    https://git.kernel.org/netdev/net/c/3e59e8856758

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


