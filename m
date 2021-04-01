Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA53735231E
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbhDAXAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234043AbhDAXAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7800861103;
        Thu,  1 Apr 2021 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617318008;
        bh=lWptgok4IUA8E+fiJ3AoApa/DeUWaH+zVu1U5CgK/rY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uJO2z0kbljIsPQXySoz5y5le90/nUIg3o/uNNpHUeEK/hs+TBm/wR4afuuwh8z5TZ
         qW6uQjZ4pLNXi/QSPtWpX7YYktKpZw6w5nDjfpN7xVFujk6XNj17Gxr1YiMnV9AV+7
         BuRfYKe2NmqSQWnd1RODeFPwcMJ+kFNAA7zj4+uXNNDUIZSURAzKUTr37/NcifG0lg
         i1WiuQ0q47yuJTHxgL3zCTwUEPw4Ccf+NZCSNOMYD8ifXB+cKxvHDXS7kg7y+Mqq7F
         t05oo48YB9hyBOuMMarqaFm93zvSo3+vEqY0L0E2aXnA7KYvjUlsQ+ggqC9HHhtFg2
         3Xan0RsVWGh3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 68F77609D2;
        Thu,  1 Apr 2021 23:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: udp: Add support for getsockopt(..., ..., UDP_GRO,
 ..., ...);
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731800842.8028.10788470037981900309.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 23:00:08 +0000
References: <20210401065917.78025-1-norman_maurer@apple.com>
In-Reply-To: <20210401065917.78025-1-norman_maurer@apple.com>
To:     Norman Maurer <norman.maurer@googlemail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org, pabeni@redhat.com,
        norman_maurer@apple.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  1 Apr 2021 08:59:17 +0200 you wrote:
> From: Norman Maurer <norman_maurer@apple.com>
> 
> Support for UDP_GRO was added in the past but the implementation for
> getsockopt was missed which did lead to an error when we tried to
> retrieve the setting for UDP_GRO. This patch adds the missing switch
> case for UDP_GRO
> 
> [...]

Here is the summary with links:
  - [net] net: udp: Add support for getsockopt(..., ..., UDP_GRO, ..., ...);
    https://git.kernel.org/netdev/net/c/98184612aca0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


