Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FD43EE16A
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235519AbhHQAkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236822AbhHQAki (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 20:40:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9682B60FD8;
        Tue, 17 Aug 2021 00:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160806;
        bh=i67YtqiO1pFWDbxFHpH3AMMJIK0zNt+MyOgyR9wwBK4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TLEaLtBIztngTA9TOipbB2uW5942/KqWfj3GuLfKIqO0iQrj9BoPV4DK0//vhkC97
         8zevePS5WLxFds7wU182ETd2Vx2dJqbx/zQRGkuN1ofkCNYiNIHflxMd8i+wBhhP3u
         urGR2qQlMx59KIO85r6/qgUVt9oRfjxG7cxuqURFS8CqfZztKf8px4A+OyrqP+h438
         /Yh1nd39U53mrvzzk9KTc5HR2blWYPmU965vy35VixzKq8OMwNYFhLvC0bSh8fiBWl
         uGR7KeOx1X8Hz58zopEzybsdV6DyWNuTWB7Khx+mPzXMQyI6jRdVjCNizBMayQ2TBF
         vkPmstGqqjRmQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 90C95609CF;
        Tue, 17 Aug 2021 00:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] ptp: ocp: minor updates and fixes.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162916080658.22028.9137113301006426368.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Aug 2021 00:40:06 +0000
References: <20210816221337.390645-1-jonathan.lemon@gmail.com>
In-Reply-To: <20210816221337.390645-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        kernel-team@fb.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 16 Aug 2021 15:13:33 -0700 you wrote:
> Fix errors spotted by automated tools.
> 
> Add myself to the MAINTAINERS for the ptp_ocp driver.
> --
> v2: Add Fixes tags, fix NET_DEVLINK
> 
> Jonathan Lemon (4):
>   ptp: ocp: Fix uninitialized variable warning spotted by clang.
>   ptp: ocp: Fix error path for pci_ocp_device_init()
>   ptp: ocp: Have Kconfig select NET_DEVLINK
>   MAINTAINERS: Update for ptp_ocp driver.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] ptp: ocp: Fix uninitialized variable warning spotted by clang.
    https://git.kernel.org/netdev/net-next/c/7c8075728f4d
  - [net-next,v2,2/4] ptp: ocp: Fix error path for pci_ocp_device_init()
    https://git.kernel.org/netdev/net-next/c/d9fdbf132dab
  - [net-next,v2,3/4] ptp: ocp: Have Kconfig select NET_DEVLINK
    https://git.kernel.org/netdev/net-next/c/d79500e66a52
  - [net-next,v2,4/4] MAINTAINERS: Update for ptp_ocp driver.
    https://git.kernel.org/netdev/net-next/c/b40fb16df9f4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


