Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1284135E8D3
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348589AbhDMWKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232571AbhDMWKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 18:10:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 06C19613A9;
        Tue, 13 Apr 2021 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618351811;
        bh=oTMPpqfPySeCKkbVJhV/OppX7QlaL9r2eDwAXeT4CrY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hpannysb2557tHa1MqcDXhAi5gxwQT64l+xSqjJD9fkcv1KSV0SSpUDI03xjjkK83
         IoOt3x+kNBT+GZ4s8L6bVuDUa0OUXIcL7k+Ov3/pHkC64cXVT5a3b1tniy/4OWSamg
         g8cNXQYIAEdYj4jziDNzHw0ERJaYzw1a62RG+8h9N+0cA9Znft4iO+POl5lRlPSK6K
         k84ZTxbZNhjCENVwh3J/KIFMt5zEhL+5qXWwsPNMywFsTpmk2+X0WTQs90eKx6j1qM
         DVck9o+ngA0EisnzskctX2zFmO36eDHrWEdpe+4Pa2QfjlX9LvPqcSYVFm2wHHcs6z
         neAsU2aWqj2Jw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EDB4860CD2;
        Tue, 13 Apr 2021 22:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] ionic: git_ts_info bit shifters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835181096.31494.11515567869712501932.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 22:10:10 +0000
References: <20210413172216.59026-1-snelson@pensando.io>
In-Reply-To: <20210413172216.59026-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com, drivers@pensando.io,
        dan.carpenter@oracle.com, allenbh@pensando.io
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 13 Apr 2021 10:22:16 -0700 you wrote:
> All the uses of HWTSTAMP_FILTER_* values need to be
> bit shifters, not straight values.
> 
> v2: fixed subject and added Cc Dan and SoB Allen
> 
> Fixes: f8ba81da73fc ("ionic: add ethtool support for PTP")
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Signed-off-by: Allen Hubbe <allenbh@pensando.io>
> 
> [...]

Here is the summary with links:
  - [v2,net-next] ionic: git_ts_info bit shifters
    https://git.kernel.org/netdev/net-next/c/1da41aa110df

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


