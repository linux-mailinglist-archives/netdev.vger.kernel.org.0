Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCD23080C3
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhA1Vvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:51:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231560AbhA1Vvb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 16:51:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AFBD364E1A;
        Thu, 28 Jan 2021 21:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611870631;
        bh=yalg/+xRAqkkwOEvg5VpG5q6CVWWGQLEncu3cRBOyrA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CQZ4FpiVuptWgAtmRAnmGmsbf1psLjG9dbBC81mtzrgVFLFOoS1qhYmWSH1JVdfnj
         x5KhzVIfafhhkatRAdJbpQ7Te5cc4GIX+6gm/zufU4RtMeDvamMyZBH3S67DDi53Hq
         DPzARGMihwpLjkXY99l37DcIJxbySPzHL+MbSSVYKNG/PcUmpluC6gKSFEY6t27oYQ
         Qmhu8k+4zMW3OxOZOv6fSC+9xZxj2Izu0invq5rEWjBTOt+ohestOoT95h3bS5qQ1N
         kiN0qGdQ/cQD+4qEOfdEZaCxzV1AWsmjNJflnURq9t5CMVVUsrrjfE5OsCpz9J94b1
         PdgMi9nJkjmHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A24186530E;
        Thu, 28 Jan 2021 21:50:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/2] net: sfp: add support for GPON RTL8672/RTL9601C and
 Ubiquiti U-Fiber
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161187063165.5341.15728485271338369992.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 21:50:31 +0000
References: <20210125150228.8523-1-pali@kernel.org>
In-Reply-To: <20210125150228.8523-1-pali@kernel.org>
To:     =?utf-8?b?UGFsaSBSb2jDoXIgPHBhbGlAa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, davem@davemloft.net,
        kuba@kernel.org, tschreibe@gmail.com, hkallweit1@gmail.com,
        kabel@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 25 Jan 2021 16:02:26 +0100 you wrote:
> This is fourth version of patches which add workarounds for
> RTL8672/RTL9601C EEPROMs and Ubiquiti U-Fiber Instant SFP.
> 
> The only change since third version is modification of commit messages.
> 
> Pali Rohár (2):
>   net: sfp: add workaround for Realtek RTL8672 and RTL9601C chips
>   net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant
> 
> [...]

Here is the summary with links:
  - [v4,1/2] net: sfp: add workaround for Realtek RTL8672 and RTL9601C chips
    https://git.kernel.org/netdev/net-next/c/426c6cbc409c
  - [v4,2/2] net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant
    https://git.kernel.org/netdev/net-next/c/f0b4f8476732

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


