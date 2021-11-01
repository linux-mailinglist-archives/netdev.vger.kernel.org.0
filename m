Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B61441B80
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhKANMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231794AbhKANMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 09:12:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CEA7360E52;
        Mon,  1 Nov 2021 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635772209;
        bh=VmibXRp55tMAXzhIL03U2nIRczdDl13YHiASYNCoKWg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R1AfDnf/GV6gHT5vJyfqO5rfhgnhPbipZkuuxioMY59A50NhpX9kQKhn1SqDtHVii
         9/IfcMeBez2AdxVZlzcpA9fZkDnNageZyhuaAojcomK7jZqBx6yoXW3I+8YYaEozaq
         ssjxjaz+qBi4+//nQFMbN2E2WoUq5PDIE8goLnomFPOuvlz5s5x69Z5wX1xl9U5di2
         EoMCv7USCzIJEpsCxtFkvNEqTfLi6BztstgvgjDaxtYit3Z4K1wzCNmIoHDyrb1nBM
         UZlydMN/N1V4gwtEd9P4QM+DRLeJKzcUGmmjBtW/F3sDTPE5ctZeINT43DZb4eq5Wl
         ggLoo0jMJrRrg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C342D60A0F;
        Mon,  1 Nov 2021 13:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: populate supported_interfaces member
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163577220979.25752.6333632475669892432.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 13:10:09 +0000
References: <E1mg8lC-0020Yn-DA@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mg8lC-0020Yn-DA@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 18:00:14 +0100 you wrote:
> From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
> 
> Add a new DSA switch operation, phylink_get_interfaces, which should
> fill in which PHY_INTERFACE_MODE_* are supported by given port.
> 
> Use this before phylink_create() to fill phylinks supported_interfaces
> member, allowing phylink to determine which PHY_INTERFACE_MODEs are
> supported.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: populate supported_interfaces member
    https://git.kernel.org/netdev/net-next/c/c07c6e8eb4b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


