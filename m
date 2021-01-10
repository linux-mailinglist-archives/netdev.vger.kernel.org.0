Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FDC2F04C9
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 03:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbhAJCKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 21:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:58612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbhAJCKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 21:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 22282225AC;
        Sun, 10 Jan 2021 02:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610244609;
        bh=ja3ysbxpi6JK0eeA6+1NJWaQGI+UuXJ8ARkyxukksic=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SIl1oKSgpsvsoXRzjrWHUmNGKetlMpcFHG6CRegKb2MM/pAHUu2Xq0iO3Ii0OuJxc
         HtJeHPnngZsb2R0fQj3r8WDhfl7CgWShAhrJ0j7dwU5LlsqL1MknG8cWgXvYbUSV1e
         /oQVNAbNC1uQ/KuVuK1STSJYNXaVs6FZAT2kd8dpz379N2XzB7kUY59942Ww7CirFS
         /lQhJaDLAUujk+vcTdilhmbqgH6xG+vafeqj6qBXHUYEaHjAHjS54fYhqHH1dGUW2o
         w+pkTUpNaKDSj6LxKRb8xUQBlEad/6uDWiRGoYdG5/8ChMLHGOFyU9yIf0I+qXoKYm
         LjXzszvr8cibA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 13A3160661;
        Sun, 10 Jan 2021 02:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] r8169: small improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161024460907.25502.4587254752697626083.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Jan 2021 02:10:09 +0000
References: <938caef4-8a0b-bbbd-66aa-76f758ff877a@gmail.com>
In-Reply-To: <938caef4-8a0b-bbbd-66aa-76f758ff877a@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 8 Jan 2021 12:55:32 +0100 you wrote:
> This series includes a number of smaller improvements.
> 
> v2:
> - return on WARN in patch 1
> 
> Heiner Kallweit (3):
>   r8169: replace BUG_ON with WARN in _rtl_eri_write
>   r8169: improve rtl_ocp_reg_failure
>   r8169: don't wakeup-enable device on shutdown if WOL is disabled
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] r8169: replace BUG_ON with WARN in _rtl_eri_write
    https://git.kernel.org/netdev/net-next/c/5f1e1224d660
  - [net-next,v2,2/3] r8169: improve rtl_ocp_reg_failure
    https://git.kernel.org/netdev/net-next/c/a46604d7ce49
  - [net-next,v2,3/3] r8169: don't wakeup-enable device on shutdown if WOL is disabled
    https://git.kernel.org/netdev/net-next/c/bb703e5781d6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


