Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7A634B267
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhCZXAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230026AbhCZXAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 19:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8BDFC61A2A;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616799612;
        bh=5GrpVsEaWdZ/ZBtaKyb4XXVvS5lm7Sb2LhJu3XeZekc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jiumHMzyZ1G/76cmcaB5hC1HMUDDm13dA0W45QskOiwfniKXn/Q7tgN4CRz3gGB7V
         mad+g7Mifbmxk0LAZi4m0+t2xkUFzyp+terT2qU51n4W2vY8aso2ljMb/MeLW43mQD
         9CanxCLN9ucv8csrYwTpentNZSPtQbP7y8UJbtlqwFS4KJVKNe+ttptrTH+DQ2EBj1
         iC85oFWbU3SJTdiH2XEb8Eptdi+64CMV6AOfuEcE40xgxMvRbM/ZPgYAw9hErrBW2w
         xAx79cUu660D0umXhlX7i8K1nCFF/DPJ2gvi9jEUia8Z1jG71MJVhnNkz++ssJni20
         7liD5zyMnp/yg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6CF036096E;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/2] axienet clock additions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161679961244.14639.14545749027851847457.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 23:00:12 +0000
References: <20210326000438.2292548-1-robert.hancock@calian.com>
In-Reply-To: <20210326000438.2292548-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        radhey.shyam.pandey@xilinx.com, robh@kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 18:04:36 -0600 you wrote:
> Add support to the axienet driver for controlling all of the clocks that
> the logic core may utilize.
> 
> Changed since v3:
> -Added Acked-by to patch 1
> -Now applies to net-next tree after earlier patches merged in - code
> unchanged from v3
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/2] dt-bindings: net: xilinx_axienet: Document additional clocks
    https://git.kernel.org/netdev/net-next/c/a0e55dcd2fa9
  - [net-next,v4,2/2] net: axienet: Enable more clocks
    https://git.kernel.org/netdev/net-next/c/b11bfb9a19f9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


