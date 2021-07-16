Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22CB3CBDD0
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 22:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhGPUdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 16:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229896AbhGPUdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 16:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EEC96613D0;
        Fri, 16 Jul 2021 20:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626467405;
        bh=5vz4OE2lxmunVEJ0iRMslkulT3lfhyspHouxFSewe24=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EeJcC6N0Wmxlp5m10D6Uf4TErhuwrZDW3RedDr4KU5n0x7Xvi2R7KqDBBCUAiVWrD
         lNKOTnBVSO5vGKuxYAQa/KNVHCLa5+08AziTcMJ/UkKZhlsDhSD+F2Q3VcjPTRSOpP
         DJ0O3n0m0myDB9StUKWSjB/2429cNySdw0nOjlkAbPS2MUTh8cXjJC8B5GBF5A+JSt
         35ZdTlMygWQerXD/1b+qC0aPzfLWUQp62GMlmVeDxQxO5DrhMhNK+kTLQpvp3jEADu
         4cR3ZzTyhTtKVR/GMcAbD+8xv48lg8JnTY2FojeVQ3pQNRYSV/wNtTzmUrJ1cgo7l8
         IiX86Zgz5T7ww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E0A9E60A4E;
        Fri, 16 Jul 2021 20:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mt7530 fix mt7530_fdb_write vid missing ivl bit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162646740491.5067.9662963030907857977.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Jul 2021 20:30:04 +0000
References: <20210716153641.4678-1-ericwouds@gmail.com>
In-Reply-To: <20210716153641.4678-1-ericwouds@gmail.com>
To:     Eric Woudstra <ericwouds@gmail.com>
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 16 Jul 2021 17:36:39 +0200 you wrote:
> From: Eric Woudstra <ericwouds@gmail.com>
> 
> According to reference guides mt7530 (mt7620) and mt7531:
> 
> NOTE: When IVL is reset, MAC[47:0] and FID[2:0] will be used to
> read/write the address table. When IVL is set, MAC[47:0] and CVID[11:0]
> will be used to read/write the address table.
> 
> [...]

Here is the summary with links:
  - mt7530 fix mt7530_fdb_write vid missing ivl bit
    https://git.kernel.org/netdev/net/c/11d8d98cbeef

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


