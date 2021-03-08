Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D073C331830
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 21:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhCHUKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 15:10:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231877AbhCHUKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 15:10:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7AA4B65268;
        Mon,  8 Mar 2021 20:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615234208;
        bh=AV3+nIv0sMZvuZgFrXPxb8Y5CZAM7XZr/UwG2xegoac=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kwKy0inigudlECCZYgf8kCMfUNkUpMfvhQKO+pCkPtspC/2aVLFAxPFXNroIi2Yq+
         5JnBlEFk1sk/U7OahVsjoqYhB5DuTQWxkJ/MNxcKtmlbF3aUYEWJnCnezIPGo/Pv7m
         751/ED/A53K8rJiiwGnxZ2jF9V3ENvRiXAugBp0prU0t5F36MSnLy8dEtRos27nn77
         v18NkWYgNQ5csHZ58ZjyhAZmA3x+9RD6H/vp42HNzZ9OpVPEB32YZbDLfqUenx8dXn
         DwaHtKL/OMwItnxCRmayM/wReF0yhsdCKI4Mk0+w4PHcQ+5mtQ3fdc5wpCdiIQuC9L
         HXr74jPeQnB4w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6AA43609E6;
        Mon,  8 Mar 2021 20:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] net: davicom: Fix regulator not turned off on failed
 probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161523420843.27243.17192886779484123674.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Mar 2021 20:10:08 +0000
References: <20210307131749.14960-1-paul@crapouillou.net>
In-Reply-To: <20210307131749.14960-1-paul@crapouillou.net>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     davem@davemloft.net, kuba@kernel.org, od@zcrc.me,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sun,  7 Mar 2021 13:17:47 +0000 you wrote:
> When the probe fails or requests to be defered, we must disable the
> regulator that was previously enabled.
> 
> Fixes: 7994fe55a4a2 ("dm9000: Add regulator and reset support to dm9000")
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  drivers/net/ethernet/davicom/dm9000.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [1/3] net: davicom: Fix regulator not turned off on failed probe
    https://git.kernel.org/netdev/net/c/ac88c531a5b3
  - [2/3] net: davicom: Fix regulator not turned off on driver removal
    https://git.kernel.org/netdev/net/c/cf9e60aa69ae
  - [3/3] net: davicom: Use platform_get_irq_optional()
    https://git.kernel.org/netdev/net/c/2e2696223676

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


