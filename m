Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD9A3D1F4D
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhGVHJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230048AbhGVHJ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:09:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5C89160249;
        Thu, 22 Jul 2021 07:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626940204;
        bh=paLpUY0CBBLjwgIhOCWYALXEdHsl6TrbrxuVHhLB9BQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RpyF6CVy0uui7psxBBa0mBH0gwwQVr5G36+z8pie4OK5Cpdxtp/XrJsIVO4bdfr88
         VNmBwfX625hdCEyxbdYeGjU1y7XI0rdAmG1KEBGC8uKXKk3ZkcQfp+NHJmaTT5LZpK
         n8JkX8Ly1+2wytdpaA4S1+dvog2m5lNJjWsSiIgFqKAXWt0N/QFBLuts3/+r01YSQn
         Em9KAeVemAfD3w3hZ924iYfaVliu5uQmrs4eiN23iX5peCLx9XLCx2zhbPY1s08wzA
         cAv4qk3oYd1gUhn/qxv/5gfCbuY7Ec/JoEmBGft56Ytt8+/v1nIVzgVr/FoeCNAe5k
         /hzyD/Cj+VmDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 52E9160C09;
        Thu, 22 Jul 2021 07:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sparx5: fix unmet dependencies warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162694020433.16794.14008241696442999766.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 07:50:04 +0000
References: <20210721223337.25722-1-rdunlap@infradead.org>
In-Reply-To: <20210721223337.25722-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 21 Jul 2021 15:33:36 -0700 you wrote:
> WARNING: unmet direct dependencies detected for PHY_SPARX5_SERDES
>   Depends on [n]: (ARCH_SPARX5 || COMPILE_TEST [=n]) && OF [=y] && HAS_IOMEM [=y]
>   Selected by [y]:
>   - SPARX5_SWITCH [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_MICROCHIP [=y] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y] && OF [=y]
> 
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Lars Povlsen <lars.povlsen@microchip.com>
> Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
> Cc: UNGLinuxDriver@microchip.com
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - net: sparx5: fix unmet dependencies warning
    https://git.kernel.org/netdev/net/c/98c5b13f3a87

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


