Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5A33D11D4
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239449AbhGUOXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239442AbhGUOTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 10:19:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2F06660FF1;
        Wed, 21 Jul 2021 15:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626879604;
        bh=5TcyXITY13mlEpb9N11XNbpiRnui8Alq6NyhR8Fbot0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W4o/j7QO/LnjGD+BxIQk7sa4kS5myfRzqYV14JbVHInaJMzY80Z9hW/DRHrNdr2WL
         lhttSO+NKOurziU0St8IBRX/DjxQ3Xy/YRsUrAtd3HhqpSAUI7ah3TPH9fiih9uq/O
         JNDY/oc8YhymI38OXTebQRdQVlcbyGlXMwqIYBKk8mduRFLOqg7uDanvyRXhk5OfTm
         D6KxU1D9YDnpua4NL/fbDw3Sw0yu9TsGroXXR9rTLvi7H6D+tq3RyY7Z1Qrt0jMBw2
         jHEdJrVa4/T/N1hH590oxrIv3r9bKVtVLtugTR6DaK9IeUZXJfVoXlZnRpAoQc2erZ
         sIRCiUS+Oku0g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 203FB60CD3;
        Wed, 21 Jul 2021 15:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] r8169: Avoid duplicate sysfs entry creation error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162687960412.27043.13400437965163469138.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 15:00:04 +0000
References: <20210720161740.5214-1-andre.przywara@arm.com>
In-Reply-To: <20210720161740.5214-1-andre.przywara@arm.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     hkallweit1@gmail.com, nic_swsd@realtek.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sayanta.pattanayak@arm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 20 Jul 2021 17:17:40 +0100 you wrote:
> From: Sayanta Pattanayak <sayanta.pattanayak@arm.com>
> 
> When registering the MDIO bus for a r8169 device, we use the PCI
> bus/device specifier as a (seemingly) unique device identifier.
> However the very same BDF number can be used on another PCI segment,
> which makes the driver fail probing:
> 
> [...]

Here is the summary with links:
  - [net,v3] r8169: Avoid duplicate sysfs entry creation error
    https://git.kernel.org/netdev/net/c/e9a72f874d5b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


