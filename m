Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A33319660
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 00:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhBKXLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 18:11:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229997AbhBKXK4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 18:10:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 791BE64DFF;
        Thu, 11 Feb 2021 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613085015;
        bh=hCLyUZbsNpnyDEkMy8y+vxPQWhHD/lh8S3pd0CdsZGI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lVaIPX8NockC5O25q0p4d/jHAEghS3qACYByM+4B7C372ccUnb2es4FGpxTMHptmB
         KC4Hljpm6Vpa8KlYzDGjubmU5JBAtmMaK1Dfu8mgCQaRqs2UCAZySnMot5oCDh6Dc8
         OH+tukIhBoJizWomzQsakgCP1Ttz47EYi4mZXE8CVjzFKV7Mc3mhbry6dOv7a58z/B
         NK+oJcWq5TaMyZZQSaejFXJ85NxPdM+XfpWJRQMVqEcxHMadjzg/5AZlIWd+nFl1bt
         g6LDQD1SZxeePCyZnuTQuy/ez67P+0ZqBPnfMoccO/281HJRWeEppU6NVbxotmHJCk
         XoZFBauUkYsLg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 60ECE60A0F;
        Thu, 11 Feb 2021 23:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v6 00/14] Add Marvell CN10K support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308501539.27196.9695165685515441633.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 23:10:15 +0000
References: <20210211155834.31874-1-gakula@marvell.com>
In-Reply-To: <20210211155834.31874-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        sgoutham@marvell.com, lcherian@marvell.com, hkelam@marvell.com,
        sbhatta@marvell.com, jerinj@marvell.com, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Feb 2021 21:28:20 +0530 you wrote:
> The current admin function (AF) driver and the netdev driver supports
> OcteonTx2 silicon variants. The same OcteonTx2's
> Resource Virtualization Unit (RVU) is carried forward to the next-gen
> silicon ie OcteonTx3, with some changes and feature enhancements.
> 
> This patch set adds support for OcteonTx3 (CN10K) silicon and gets
> the drivers to the same level as OcteonTx2. No new OcteonTx3 specific
> features are added.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,01/14] octeontx2-af: cn10k: Add mbox support for CN10K platform
    https://git.kernel.org/netdev/net-next/c/98c561116360
  - [net-next,v6,02/14] octeontx2-pf: cn10k: Add mbox support for CN10K
    https://git.kernel.org/netdev/net-next/c/facede8209ef
  - [net-next,v6,03/14] octeontx2-af: cn10k: Update NIX/NPA context structure
    https://git.kernel.org/netdev/net-next/c/30077d210c83
  - [net-next,v6,04/14] octeontx2-af: cn10k: Update NIX and NPA context in debugfs
    https://git.kernel.org/netdev/net-next/c/3feac505fb31
  - [net-next,v6,05/14] octeontx2-pf: cn10k: Initialise NIX context
    https://git.kernel.org/netdev/net-next/c/d21a857562ad
  - [net-next,v6,06/14] octeontx2-pf: cn10k: Map LMTST region
    https://git.kernel.org/netdev/net-next/c/6e8ad4387da5
  - [net-next,v6,07/14] octeontx2-pf: cn10k: Use LMTST lines for NPA/NIX operations
    https://git.kernel.org/netdev/net-next/c/4c236d5dc8b8
  - [net-next,v6,08/14] octeontx2-af: cn10k: Add RPM MAC support
    https://git.kernel.org/netdev/net-next/c/91c6945ea1f9
  - [net-next,v6,09/14] octeontx2-af: cn10k: Add support for programmable channels
    https://git.kernel.org/netdev/net-next/c/242da439214b
  - [net-next,v6,10/14] octeontx2-af: cn10K: Add MTU configuration
    https://git.kernel.org/netdev/net-next/c/6e54e1c5399a
  - [net-next,v6,11/14] octeontx2-pf: cn10k: Get max mtu supported from admin function
    https://git.kernel.org/netdev/net-next/c/ab58a416c93f
  - [net-next,v6,12/14] octeontx2-af: cn10k: Add RPM LMAC pause frame support
    https://git.kernel.org/netdev/net-next/c/1845ada47f6d
  - [net-next,v6,13/14] octeontx2-af: cn10k: Add RPM Rx/Tx stats support
    https://git.kernel.org/netdev/net-next/c/ce7a6c3106de
  - [net-next,v6,14/14] octeontx2-af: cn10k: MAC internal loopback support
    https://git.kernel.org/netdev/net-next/c/3ad3f8f93c81

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


