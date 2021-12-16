Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8832C477DDA
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241474AbhLPUvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:51:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57506 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhLPUvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:51:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D6DD61F01;
        Thu, 16 Dec 2021 20:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AAF15C36AE8;
        Thu, 16 Dec 2021 20:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639687900;
        bh=xgfkq1w8c1YOzR5X2976lmrvszDuIwiOSRZfEkOqMA0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SuC7DKUyADwZHGyuOdTDGKBM5cvMXq70+/UkwcGL7l6XRtt9obMQK323UMLwGo0VT
         YDCfFqBq9kFw6Xcm1dPVuz14DfsodaVrbop+3rd3k/hGhzT6OP6J6Sg8M9oL6oonQc
         azRS77FxXTslAWJfj7SuVw/XCJP0u0kc+RO9KeZcqi59hk8DNRf8g/+hsBwP8d/u8A
         XqV3NbgfUVLBKyznCobJHbCCN82da4ylSWUIxODmvxci83P8V0rgOK/3ZIaLtvqVRT
         BIR8tFy8jWqXjKSeLVODUAc1AqAdxL1nrLat5jY9BimkpJYAq4NFbeT2eZINN2hzmz
         nI6BUO/g+EPcw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 91EB360A3C;
        Thu, 16 Dec 2021 20:51:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: systemport: Add global locking for descriptor
 lifecycle
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163968790059.17466.6119317742011162239.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 20:51:40 +0000
References: <20211215202450.4086240-1-f.fainelli@gmail.com>
In-Reply-To: <20211215202450.4086240-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Dec 2021 12:24:49 -0800 you wrote:
> The descriptor list is a shared resource across all of the transmit queues, and
> the locking mechanism used today only protects concurrency across a given
> transmit queue between the transmit and reclaiming. This creates an opportunity
> for the SYSTEMPORT hardware to work on corrupted descriptors if we have
> multiple producers at once which is the case when using multiple transmit
> queues.
> 
> [...]

Here is the summary with links:
  - [net] net: systemport: Add global locking for descriptor lifecycle
    https://git.kernel.org/netdev/net/c/8b8e6e782456

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


