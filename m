Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC8C32323A
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbhBWUla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:41:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233000AbhBWUl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 15:41:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9D17A601FF;
        Tue, 23 Feb 2021 20:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614112847;
        bh=EhsjYflepxvLPaDKg0JeKxmmcf4dLCs3KSfAzkJsDag=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kgkxaskucG5+1PhbJaqRGCR2SQc4tgrSC347tCkxVw13pS93ZMDVg39o4iCMwGL1R
         hvV5P69RUNschpznfQWCbtmObmF1RF8Qv4fK5xk9eiNFuYLsV0vOZYIl3i8t1ko7ms
         DA0ofpsC1y6UFPBbm+vCw2bYAog3+caMrt6PiRd4OVZgDwGJmYaRDBdNPd1b8lI8Pf
         VYpK0yskE/tnZNIEeezK3NMeGx7fTFFO2TXJyVfg9JtIv0ZFGYFu4j0uzO1Gnk0EL0
         iqvM4q5vmuGH1pWKX3cUp0isabJRUq5sJWZAhWCy4dny89zIGoUoVOf/Nr7gPuQ6DP
         dpjWRvoTVgPTA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 958946096F;
        Tue, 23 Feb 2021 20:40:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] r8152: minor adjustments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161411284760.849.519084672823492074.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Feb 2021 20:40:47 +0000
References: <1394712342-15778-341-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-341-Taiwan-albertk@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 19 Feb 2021 17:04:39 +0800 you wrote:
> These patches are used to adjust the code.
> 
> Hayes Wang (4):
>   r8152: enable U1/U2 for USB_SPEED_SUPER
>   r8152: check if the pointer of the function exists
>   r8152: replace netif_err with dev_err
>   r8152: spilt rtl_set_eee_plus and r8153b_green_en
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] r8152: enable U1/U2 for USB_SPEED_SUPER
    https://git.kernel.org/netdev/net/c/7a0ae61acde2
  - [net-next,2/4] r8152: check if the pointer of the function exists
    https://git.kernel.org/netdev/net/c/c79515e47935
  - [net-next,3/4] r8152: replace netif_err with dev_err
    https://git.kernel.org/netdev/net/c/156c32076112
  - [net-next,4/4] r8152: spilt rtl_set_eee_plus and r8153b_green_en
    https://git.kernel.org/netdev/net/c/40fa7568ac23

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


