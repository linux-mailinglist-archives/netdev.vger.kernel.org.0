Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2BE403800
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 12:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344311AbhIHKlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 06:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241826AbhIHKlQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 06:41:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4880F61168;
        Wed,  8 Sep 2021 10:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631097608;
        bh=cXnHErUYWS82pv+8Bsa/y3/MiuTmFtfyiDCvBOq2E6I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bdGFXaYB3s9DB88vI2Df+L3PCSnobl9S+v7PVbP/ot2ZhWW9VCoaVR2M3jE2MOUtU
         Yiy3ihmZFV3YzD0BhI1QHnf97D5JCuZRU92YakIRWdWqw/UuDFCPckur4x4KYFkm5Y
         U0nGDCs3Qu5mGX+DH6pwlbvTZ5fL8KOg8d0RD6/+hcxJl9M7YU5Rp+y3e8WnLOJYBV
         yTNirZ+JtIldgaY+ntBYIrHdbqBiJDLMD/VF/dLzWJm+Oi432vLwVx5/fx99wIHqqr
         vdHBo5Vss+6MVRMBR29MQf9nJHOoeT5HEySdcyHAn63S9Li7N1y+Yd1R3y4mQn6559
         97Xw+/caB03aw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4268E60A24;
        Wed,  8 Sep 2021 10:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mctp: perform route destruction under RCU read lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163109760826.16056.8641773139555261021.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Sep 2021 10:40:08 +0000
References: <20210908041310.4014458-1-jk@codeconstruct.com.au>
In-Reply-To: <20210908041310.4014458-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, lkp@lists.01.org, lkp@intel.com,
        kuba@kernel.org, matt@codeconstruct.com.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  8 Sep 2021 12:13:10 +0800 you wrote:
> The kernel test robot reports:
> 
>   [  843.509974][  T345] =============================
>   [  843.524220][  T345] WARNING: suspicious RCU usage
>   [  843.538791][  T345] 5.14.0-rc2-00606-g889b7da23abf #1 Not tainted
>   [  843.553617][  T345] -----------------------------
>   [  843.567412][  T345] net/mctp/route.c:310 RCU-list traversed in non-reader section!!
> 
> [...]

Here is the summary with links:
  - [net] mctp: perform route destruction under RCU read lock
    https://git.kernel.org/netdev/net/c/581edcd0c8a0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


