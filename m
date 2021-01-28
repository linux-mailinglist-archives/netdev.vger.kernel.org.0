Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC47306969
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhA1BFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:05:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:34734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231529AbhA1BAx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 20:00:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B18E164DD7;
        Thu, 28 Jan 2021 01:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611795611;
        bh=m8JVpZPVaJfXv56uYEizRBaRMKf2mVcWnwdS3R7Pz+w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i5ym+bRVFUYo3wzzqKU7sl1kBht36W2WaGj6Otrbw047SESj8arC/RXxb3C4Jb7XE
         bg9RxJNu33fpUHgwL4aOJ0YWRr9ZDxR5FSV7pIm5T8SN6eTUeuw5WKi49ATJHab5vI
         QQ01CnvUiKvIoCHIl60nOFZdQBKG3sKFQCnjb2368Tzc4V5eS1uyUH6D+Eai+eV6op
         e0wjTyvpfSQztsTgUwdFGvdjTXTkvT26rmONa1/0dHsd5oguGMFwBVnpqSWfuXqd/9
         sKOJBJobD3C5VppPHUHZp17uhJWQreZ4xtTxaJIha8Lxh/wTLQoNSFGsKXC8awQI2H
         WPAH479hqfXqg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9FC3E6531F;
        Thu, 28 Jan 2021 01:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: remove not needed call to rtl_wol_enable_rx
 from rtl_shutdown
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179561164.17796.16312897164694910279.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 01:00:11 +0000
References: <34ce78e2-596c-e2ac-16aa-c550fa624c22@gmail.com>
In-Reply-To: <34ce78e2-596c-e2ac-16aa-c550fa624c22@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 25 Jan 2021 17:55:12 +0100 you wrote:
> rtl_wol_enable_rx() is called via the following call chain if WoL
> is enabled:
> rtl8169_down()
> -> rtl_prepare_power_down()
>    -> rtl_wol_enable_rx()
> Therefore we don't have to call this function here.
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: remove not needed call to rtl_wol_enable_rx from rtl_shutdown
    https://git.kernel.org/netdev/net-next/c/17ce76c4985f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


