Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C690311FE6
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 21:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBFUUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 15:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBFUUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 15:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 40AF064E2B;
        Sat,  6 Feb 2021 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612642808;
        bh=2s68UkrT2R3GvPehUjBkQv0J38MfwOm2pcZ5BDIcDOs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LHscacZ0nH2dTMHayAaP64NniOI3hKiYNrO8GJ5PVEq7cbTT5Ws9UYoRcOWVMj55a
         FdFWuXpmg1Pqw2z0FW8ePXdcUk7VDiYrdPJfbrxKCVnt/2hHd+bdKSBpaiJyqd63eH
         VfB1MceRIfZsdSQuFi1DPY7mq0cEBj1qW8DkP4jyRHt/Z5h/nGY+hFEvU7wBz8s1fj
         xMiSRpoH5BjrIFqJIIHq80ztgjqlpWhSXT+gsxx+oVmwPO9C5Tmr2ogRUHLMrD0XFV
         50is/yKAKGnbbCjgMTwCre/Rz/XgUS9kiXylMGnZS2Exzmq6Hj9gE9iTKPKDVqr3n/
         0ascrQDJn+RAQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3618E609CE;
        Sat,  6 Feb 2021 20:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wan: farsync: use new tasklet API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161264280821.16096.471136009297649468.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 20:20:08 +0000
References: <20210204173947.92884-1-kernel@esmil.dk>
In-Reply-To: <20210204173947.92884-1-kernel@esmil.dk>
To:     Emil Renner Berthing <kernel@esmil.dk>
Cc:     netdev@vger.kernel.org, kevin.curtis@farsite.co.uk,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  4 Feb 2021 18:39:47 +0100 you wrote:
> This converts the driver to use the new tasklet API introduced in
> commit 12cc923f1ccc ("tasklet: Introduce new initialization API")
> 
> The new API changes the argument passed to callback functions,
> but fortunately it is unused so it is straight forward to use
> DECLARE_TASKLET rather than DECLARE_TASLKLET_OLD.
> 
> [...]

Here is the summary with links:
  - net: wan: farsync: use new tasklet API
    https://git.kernel.org/netdev/net-next/c/8cc8993cbcee

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


