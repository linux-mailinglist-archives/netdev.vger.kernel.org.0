Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D80D3A6F47
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234780AbhFNTmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234356AbhFNTmH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E53E76128C;
        Mon, 14 Jun 2021 19:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623699603;
        bh=Vqgiitol+ay00A4H8C4zsJ6wNrzjTaDEOUKq/jI1BW4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fRFAT94dyywL+ehV0wbTTOdFlnUumf2Qck+3mouq/0xzdyj9Zpi8KUUoB75a5TNVj
         nOKhJ0n81hcaT98Mo8bocFNqHulwiTwWHV2bJDVIOEA84+AfVU5zPIU2kXO18YmTL+
         UF+NmWE0aU02aYvyqZ0uXI8xlgJ5zjUHjcLP8OG/l17l/v+3DiZkFA9OxLP0B5kGhB
         SyUyKl8HtcvVw4PUIzLpBdUmKDe0fY8b9UpCJHs1MdcVM2eQ1XAerhtVmloKMTQdNC
         Aat5gZaTjL1kiVZW+8JriNhQNRQXD31llQNx8SnaUY6/BzHbm4qtiHf47KRFG10Bco
         1W+aldIHFMVrw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DF8AA60977;
        Mon, 14 Jun 2021 19:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-pf: Cleanup flow rule management
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162369960391.4485.17348216188310185132.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 19:40:03 +0000
References: <1623581585-1416-1-git-send-email-sgoutham@marvell.com>
In-Reply-To: <1623581585-1416-1-git-send-email-sgoutham@marvell.com>
To:     Sunil Kovvuri Goutham <sgoutham@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 13 Jun 2021 16:23:05 +0530 you wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> Current MCAM allocation scheme allocates a single lot of
> MCAM entries for ntuple filters, unicast filters and VF VLAN
> rules. This patch attempts to cleanup this logic by segregating
> MCAM rule allocation and management for Ntuple rules and unicast,
> VF VLAN rules. This segregation will result in reusing most of
> the logic for supporting ntuple filters for VF devices.
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-pf: Cleanup flow rule management
    https://git.kernel.org/netdev/net-next/c/9917060fc30a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


