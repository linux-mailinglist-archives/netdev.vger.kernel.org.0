Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CEE37B265
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhEKXVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhEKXVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 19:21:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1975161626;
        Tue, 11 May 2021 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620775210;
        bh=nfMzuofSLm0JhEChHSBbNSabgLwbNSxLTpGFl8QEia0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mFmn2jAGDoXBPXV11ofPdxBpZkQRsWybvqV46Dzn1uFdqrr2TG6tcBjd3MNQuyrsZ
         /TbcXvPf5T1AC389OTjMdmOZNSMEvUNSwioJMreR38/cWuBEIQinAXweg/hWHlpP4+
         9dFFuQJAzkuMxZVCeZ5DD6/YDsUB2ltwtI+siNNbaHIJmL/MGmYKDMAH8mmjeCnkID
         gXBtUHkGH41JRfVfETE93jt5VYfuzolg0nvJt2/1ilmKyY38S8llnmwmTmuejOMqIZ
         2uFmFCyxJ8SCVo2m617Fmh1UxM3wWrKfTbAzLN6hMWAAeAzabTTLwgc/CVDEpOBo/D
         eTfONtoutOMfA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0DAD360A71;
        Tue, 11 May 2021 23:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] atm: iphase: fix possible use-after-free in
 ia_module_exit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162077521005.13970.10505562362086012548.git-patchwork-notify@kernel.org>
Date:   Tue, 11 May 2021 23:20:10 +0000
References: <1620716016-107941-1-git-send-email-zou_wei@huawei.com>
In-Reply-To: <1620716016-107941-1-git-send-email-zou_wei@huawei.com>
To:     Zou Wei <zou_wei@huawei.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 11 May 2021 14:53:36 +0800 you wrote:
> This module's remove path calls del_timer(). However, that function
> does not wait until the timer handler finishes. This means that the
> timer handler may still be running after the driver's remove function
> has finished, which would result in a use-after-free.
> 
> Fix by calling del_timer_sync(), which makes sure the timer handler
> has finished, and unable to re-schedule itself.
> 
> [...]

Here is the summary with links:
  - [-next] atm: iphase: fix possible use-after-free in ia_module_exit()
    https://git.kernel.org/netdev/net-next/c/1c72e6ab66b9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


