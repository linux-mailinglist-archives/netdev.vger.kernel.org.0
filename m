Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565A23D4CB0
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 10:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhGYHts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 03:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhGYHtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 03:49:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3FF7960F36;
        Sun, 25 Jul 2021 08:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627201807;
        bh=kWq+odkjUKr//WsfcVOjmRqt7NylznG1toenFU/dwqc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jcnybYhFO5FAbtyth/iTC4MIldHyv4WZG49R4/Slq2q+yhXOssx+8p+zy+CGj/Vvi
         vp93CqFxwtU2Ia2gt9w6l9EQZNz5plgOPsv0lY9GKhmf7nek6u5MpG6rjj2oWAMzMs
         wBbmfbLeT2jE+8E6ZEl/l6IWC1X+vdbyNaW4KGryAhXzJlpzyOTiKUgr1fmb6xFIr4
         iQNXkA2c4LE8t3aWTho0K6f0BMuTVpmm0KjEK+LCd/OKYG6FMZX3JkyNAtt9XpOKTX
         A6KtFUclIAM+q+gP2p6QxnuegY5y4PQ5nxJlD70Grv2IoEniLbX4CD0Ju1SM/2JQxD
         uiNJav8VoJDsQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 395AB60A39;
        Sun, 25 Jul 2021 08:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/12] nfc: constify data structures
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162720180723.26018.5160938905220111429.git-patchwork-notify@kernel.org>
Date:   Sun, 25 Jul 2021 08:30:07 +0000
References: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     charles.gorand@effinnov.com, k.opasiak@samsung.com,
        mgreer@animalcreek.com, bongsu.jeon@samsung.com,
        davem@davemloft.net, kuba@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 24 Jul 2021 23:47:31 +0200 you wrote:
> Hi,
> 
> Constify pointers to several data structures which are not modified by
> NFC core or by drivers to make it slightly safer.  No functional impact
> expected.
> 
> Best regards,
> Krzysztof
> 
> [...]

Here is the summary with links:
  - [01/12] nfc: constify payload argument in nci_send_cmd()
    https://git.kernel.org/netdev/net-next/c/48d5440393d3
  - [02/12] nfc: constify nci_ops
    https://git.kernel.org/netdev/net-next/c/b9c28286d8f1
  - [03/12] nfc: s3fwrn5: constify nci_ops
    https://git.kernel.org/netdev/net-next/c/d08ba0fdeaba
  - [04/12] nfc: constify nci_driver_ops (prop_ops and core_ops)
    https://git.kernel.org/netdev/net-next/c/cb8caa3c6c04
  - [05/12] nfc: constify nfc_phy_ops
    https://git.kernel.org/netdev/net-next/c/7a5e98daf6bd
  - [06/12] nfc: st21nfca: constify file-scope arrays
    https://git.kernel.org/netdev/net-next/c/0f20ae9bb96b
  - [07/12] nfc: constify pointer to nfc_vendor_cmd
    https://git.kernel.org/netdev/net-next/c/15944ad2e5a1
  - [08/12] nfc: constify nfc_hci_gate
    https://git.kernel.org/netdev/net-next/c/5f3e63933793
  - [09/12] nfc: constify nfc_ops
    https://git.kernel.org/netdev/net-next/c/f6c802a726ae
  - [10/12] nfc: constify nfc_hci_ops
    https://git.kernel.org/netdev/net-next/c/094c45c84d79
  - [11/12] nfc: constify nfc_llc_ops
    https://git.kernel.org/netdev/net-next/c/49545357bf7e
  - [12/12] nfc: constify nfc_digital_ops
    https://git.kernel.org/netdev/net-next/c/7186aac9c22d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


