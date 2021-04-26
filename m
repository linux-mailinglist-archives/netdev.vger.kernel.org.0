Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292ED36AA7B
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhDZCAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbhDZCAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 22:00:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B7022611ED;
        Mon, 26 Apr 2021 02:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619402410;
        bh=73tgeenLnKeIHXmSB4PFSkGwpwU2HANJH30Gp6g5hSE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jxRi+OOZA3gJPXqawLJjAID8Zctkz310Urxfk2nHtNsqECoSGtiRNSMv9DKiolbSn
         OETerdGepDo0gpD2RpIr/hQGAIiRRb0RlsRvbsAt78HTEqveG1aFOutV3mUOnC4+98
         82frmMzlkLHJlhUFzagFJP4gVgr/bjeLqfOQZgAHd5ehhU+WDm1e382uL7lRS796mR
         Ik4GpZMWAqZDy6K27CaCP9rNpkUHE1FKsyALuolvJisIiVl91vquFM5xMvgIF87xQs
         +dKATEgbVQf8o9qF9fyf0pgAmG4a6Mi3rLT1ZduLrSnHWLxQFIAyrwF58ZoJJXrSM4
         +OQSxWD9TdExQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ADDBF60CE0;
        Mon, 26 Apr 2021 02:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/10] bnxt_en: Updates for net-next.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161940241070.19812.12866967625242130678.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 02:00:10 +0000
References: <1619372727-19187-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1619372727-19187-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 25 Apr 2021 13:45:17 -0400 you wrote:
> This series includes these main enhancements:
> 
> 1. Link related changes
>     - add NRZ/PAM4 link signal mode to the link up message if known
>     - rely on firmware to bring down the link during ifdown
> 
> 2. SRIOV related changes
>     - allow VF promiscuous mode if the VF is trusted
>     - allow ndo operations to configure VF when the PF is ifdown
>     - fix the scenario of the VF taking back control of it's MAC address
>     - add Hyper-V VF device IDs
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/10] bnxt_en: report signal mode in link up messages
    https://git.kernel.org/netdev/net-next/c/1d2deb61f095
  - [net-next,v2,02/10] bnxt_en: Add a new phy_flags field to the main driver structure.
    https://git.kernel.org/netdev/net-next/c/b0d28207ced8
  - [net-next,v2,03/10] bnxt_en: Add support for fw managed link down feature.
    https://git.kernel.org/netdev/net-next/c/d5ca99054f8e
  - [net-next,v2,04/10] bnxt_en: allow promiscuous mode for trusted VFs
    https://git.kernel.org/netdev/net-next/c/dd85fc0ab5b4
  - [net-next,v2,05/10] bnxt_en: allow VF config ops when PF is closed
    https://git.kernel.org/netdev/net-next/c/6b7027689890
  - [net-next,v2,06/10] bnxt_en: Move bnxt_approve_mac().
    https://git.kernel.org/netdev/net-next/c/7b3c8e27d67e
  - [net-next,v2,07/10] bnxt_en: Call bnxt_approve_mac() after the PF gives up control of the VF MAC.
    https://git.kernel.org/netdev/net-next/c/92923cc71012
  - [net-next,v2,08/10] bnxt_en: Add PCI IDs for Hyper-V VF devices.
    https://git.kernel.org/netdev/net-next/c/7fbf359bb2c1
  - [net-next,v2,09/10] bnxt_en: Support IFF_SUPP_NOFCS feature to transmit without ethernet FCS.
    https://git.kernel.org/netdev/net-next/c/dade5e15fade
  - [net-next,v2,10/10] bnxt_en: Implement .ndo_features_check().
    https://git.kernel.org/netdev/net-next/c/1698d600b361

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


