Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97483A7028
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbhFNUWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:22:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234505AbhFNUWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 16:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 65103613B9;
        Mon, 14 Jun 2021 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623702006;
        bh=aQ86z2xEHi28Zm1jTu12JfIdNNmh/bdWvZi1N0iq4ak=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k3M05tApP70dRbX2OvSqsWDNeeYnwrBpaVU8i9ecK/hudLR2gsf1VR65kUiG2AVbd
         cMRQ5I6O4y4mOEe6tHwGah2mDWufCkNCitvMQQHrTfFCqKa+OQdJnH779bdh2igIa0
         PP+OftsZ30WNI8YjteErQPA5zbTDx9yuxaVQiMNisMmATJNbReujv8oO6EkIBSxzYJ
         4UYoHcSQ9qKevlAhO+/21Y51agHoqOEAtTJ1GN3uishO1geligSRb2ZfVfMXbbdJjg
         uYSCunXhBkpyV/+LUpSv4/L60aDS9vgl72UC13+k+RB5b+aKaIzNllwLhnZxCz+uxu
         IDCrmOAuM5GWw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5D80560953;
        Mon, 14 Jun 2021 20:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wwan: Fix WWAN config symbols
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370200637.25455.17316488762841330599.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 20:20:06 +0000
References: <1623689796-8740-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1623689796-8740-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ryazanov.s.a@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Jun 2021 18:56:36 +0200 you wrote:
> There is not strong reason to have both WWAN and WWAN_CORE symbols,
> Let's build the WWAN core framework when WWAN is selected, in the
> same way as for other subsystems.
> 
> This fixes issue with mhi_net selecting WWAN_CORE without WWAN and
> reported by kernel test robot:
> 
> [...]

Here is the summary with links:
  - [net-next] net: wwan: Fix WWAN config symbols
    https://git.kernel.org/netdev/net-next/c/89212e160b81

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


