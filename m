Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC723ED1D9
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbhHPKVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230419AbhHPKUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 73ACD61BA7;
        Mon, 16 Aug 2021 10:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629109206;
        bh=ZhMpZlZuUp3lqX5QVdMCtlmEDMD0uM7929Dxr/inNzA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yv9DNbw6rCAlgQIloA7b/BmCb0xtpPJWi0a23z67Cm2pMzqFlYkyLbjAXg+g1lqTr
         LnmQ8YizgmZ5bQfHIahKKyCZWGuoSidSgfJpa9rkYHD1CukAcwqGBFopPogL8FmC+N
         Avay22qoMD7DcbkY95wVDmjM8CAKGRD9Yz9Pdbh8h8p353y8ajrAArFx0U/yGl2vKV
         +NhQhdTn8kGdb/mvu38EYe9LW61XYJOBhJNT+P6BazPozY+rnEdbiugtijJZgQfcSH
         i+nq/j1AotaFWXOfiWfq5V7+z6irp62tIvynvUdcXGn14nWOzgmJGon7C73t89sJwp
         q2lokfnFRjiRQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 694A2609CF;
        Mon, 16 Aug 2021 10:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910920642.28018.877742106714632032.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:20:06 +0000
References: <20210813203026.27687-1-rdunlap@infradead.org>
In-Reply-To: <20210813203026.27687-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        jonathan.lemon@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 13 Aug 2021 13:30:26 -0700 you wrote:
> Fix kconfig warning on arch/s390/:
> 
> WARNING: unmet direct dependencies detected for SERIAL_8250
>   Depends on [n]: TTY [=y] && HAS_IOMEM [=y] && !S390 [=y]
>   Selected by [m]:
>   - PTP_1588_CLOCK_OCP [=m] && PTP_1588_CLOCK [=m] && HAS_IOMEM [=y] && PCI [=y] && SPI [=y] && I2C [=m] && MTD [=m]
> 
> [...]

Here is the summary with links:
  - ptp: ocp: don't allow on S390
    https://git.kernel.org/netdev/net-next/c/944f510176eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


