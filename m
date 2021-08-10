Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966C93E561F
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238508AbhHJJAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236949AbhHJJA2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 05:00:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 41AA360ED8;
        Tue, 10 Aug 2021 09:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628586007;
        bh=XqWSWaTZHzLaSU1ELOx8/u7JPCQ9OtAKaORBLFqFPiQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ePf7DVoRhMMg5NmxHrbPbKmW4xCRkApaoBiZ7QIpeqyTIxkXeXpNeCLXAzuZ8iyqf
         y7c/CFtPSLI0FAt2ZBqkT9/juX5eL4uBuToWchzcUY21qyfKSjhwOncitLBwmAMva/
         pmBLlwH8GRSgrqJJe/fIE+KbUm/aMkFc01Ac1GiQzdLYQ8KQqbbo0ifEBhyzeRin+y
         +HRfbMRfaebAJkEmNipSXdWZgGu4AoShrbl5CE8mlEwdxiLyq2WhHRow6qtvDvC8BM
         fnzCO4tXFiJ5oVt56fB7nswcrJTuITxIpWM0G+2MR4yblA8HRC/u3J8jONrA3ZX5w9
         mh3UA4Np18OSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 30B5C609AD;
        Tue, 10 Aug 2021 09:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can 2021-08-10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162858600719.23529.7661440175156491627.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Aug 2021 09:00:07 +0000
References: <20210810063702.350109-1-mkl@pengutronix.de>
In-Reply-To: <20210810063702.350109-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Tue, 10 Aug 2021 08:37:00 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 2 patches for net/master.
> 
> Baruch Siach's patch fixes a typo for the Microchip CAN BUS Analyzer
> Tool entry in the MAINTAINERS file.
> 
> [...]

Here is the summary with links:
  - pull-request: can 2021-08-10
    https://git.kernel.org/netdev/net/c/31782a01d14f
  - [net,2/2] can: m_can: m_can_set_bittiming(): fix setting M_CAN_DBTP register
    https://git.kernel.org/netdev/net/c/aae32b784ebd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


