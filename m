Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FB43F5B7D
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 12:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbhHXKAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 06:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235566AbhHXKAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 06:00:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CB45F6120A;
        Tue, 24 Aug 2021 10:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629799205;
        bh=tHFUKjFqZ7E2mDVE+0zwyOBR9bU05URCQe731eiQFvo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nOczNv8wGk3lxGkYMJlsHXHCg/MxTXxHAwe0BJzdDSzp8tTmw9d3jDzP48B2Nwz1Z
         56HrF4bGMUaDliSThgDxYQgh9ljufZ0a7tkIxNdWMoch7QeJfe0XKXCSXQmtjNxp5j
         fh5bYaBjsuWSc1sQ1KdxPaYZtQaqUgiydc8/F9xU83DQTYVOSG8BEr0rFhq01HwLHc
         25KUVoEHG+A0LxbEJXOt/3wxnDH2vXBa6QiPf3LSpe14sgiZpmcCYIuhXfq1hOGBvB
         FNrJPP9XKyaaaWcrtz8xw+QHy1N1MxbVDFPCP9wzFHcZBT+yXEqO7hunruH7QhrFBM
         ym7arfkaxQw5w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C035760978;
        Tue, 24 Aug 2021 10:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: enable ASPM L0s state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162979920578.20108.1098485712755805990.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Aug 2021 10:00:05 +0000
References: <f159f2ba-d88e-aaa3-3409-ba831de55f1d@gmail.com>
In-Reply-To: <f159f2ba-d88e-aaa3-3409-ba831de55f1d@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 24 Aug 2021 08:23:20 +0200 you wrote:
> ASPM is disabled completely because we've seen different types of
> problems in the past. However it seems these problems occurred with
> L1 or L1 sub-states only. On all the chip versions I've seen the
> acceptable L0s exit latency is 512ns. This should be short enough not
> to cause problems. If the actual L0s exit latency of the PCIe link
> is bigger than 512ns then the PCI core will disable L0s anyway.
> So let's give it a try and disable L1 and L1 sub-states only.
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: enable ASPM L0s state
    https://git.kernel.org/netdev/net-next/c/18a9eae240cb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


