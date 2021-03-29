Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4457A34C0C7
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhC2BAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231640AbhC2BAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 21:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 74A3C6195F;
        Mon, 29 Mar 2021 01:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616979611;
        bh=0g2W3XZM+hVSI30lbBAHhkb1BfpORb1FMZpfAKttWSI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lyHLyKRSWVPsBSM0yuiuGzKc0uTelkPujTKedHTUHtDjEwACt3PG+ghL9qZKCXPdl
         JaIjVmaW9OyoAEBG+Nd3ShCbn5IGCXBqVDLv/BN0dINyCq1QONPEdtwArt36FXwdra
         K0fPjuLt8Gok5H81EEjTYMtzcukEcWOy19qig95zvdGYHIVBhm/fA65XBefqEeuduJ
         XpjS4EOAsMH6lC5ZPpQkucnE3fI6xHNL2Vk+/AvCg/XuARYhBHdfRwn9vTPYF8JFoP
         aNyvxGMgm0oOxsj7lEyFR7INvEhnmSz+evAg8xiowZMRxcMETAHvfk0e6F+uYE54yq
         bem42WxFHQQBQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6BA45609E8;
        Mon, 29 Mar 2021 01:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers: net: smc91x: remove redundant initialization of
 pointer gpio
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161697961143.31306.10566372729407399026.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 01:00:11 +0000
References: <20210326192847.623376-1-colin.king@canonical.com>
In-Reply-To: <20210326192847.623376-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     nico@fluxnic.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 26 Mar 2021 19:28:47 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer gpio is being initialized with a value that is
> never read and it is being updated later with a new value. The
> initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - drivers: net: smc91x: remove redundant initialization of pointer gpio
    https://git.kernel.org/netdev/net-next/c/214037a146ff

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


