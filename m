Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDCC2DC73F
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388819AbgLPTdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:33:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388788AbgLPTdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:33:11 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608145806;
        bh=S3HjTUK6YPots1UJyM5B4BkMcpmM8WF54XX1TOAGor4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PdLd+2gMpB3dT0pBOfZLYxukVGXXFY7tHsO0/7BOz9ZbwhbNbsoebGdF0UFKgj2G5
         vdHAnTpdJBsmu/gG5CBQdkGIhGaKJewAM3/qBBB7LyYCR63Vrjr3erxHrdUBNh5vdR
         Y7DWD3JJ1QRbiKsa+CpERNRIflM/5S1JdvFGcbetDndzbKa9zLpqWTgtXDI37WL5Do
         GIO1TXkodhI65OY0L3bv4w7W2aaWImtEyBXTB+hj+efZS85Ft11Vr+WWMXl2ICcPGi
         U2nXdWd3EwQmp0O9IFoV+Wv3uQmldHyKYpJRNYdaY6BMS95UrDm0o7PKtB8inTW9e5
         GvFHvApHxWPOg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bcmgenet: Fix a resource leak in an error handling path
 in the probe functin
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160814580681.32605.12840907282791661711.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Dec 2020 19:10:06 +0000
References: <20201212182005.120437-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20201212182005.120437-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        kuba@kernel.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 12 Dec 2020 19:20:05 +0100 you wrote:
> If the 'register_netdev()' call fails, we must undo a previous
> 'bcmgenet_mii_init()' call.
> 
> Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> The missing 'bcmgenet_mii_exit()' call is added here, instead of in the
> error handling path in order to avoid some goto spaghetti code.
> 
> [...]

Here is the summary with links:
  - net: bcmgenet: Fix a resource leak in an error handling path in the probe functin
    https://git.kernel.org/netdev/net/c/4375ada01963

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


