Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1942D3CC08E
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 03:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238132AbhGQBnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 21:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233418AbhGQBnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 21:43:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E50C9613E7;
        Sat, 17 Jul 2021 01:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626486005;
        bh=VmPD4VCnTGcI/KQ6Ooa+3kL4WHvnMkvF5xAw57E7e+U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LPWRJ0JWXdLR2QxWH6N2VSPxNyLCsdNwNLSWaRsi97F5I+cCBBmDEyEpCcbG/378m
         3589hdRV1CPoWSxQ+suhjwc+ucoQ2q8sIz4C6u/wEjpv0jQByytABxPEqDnOyc/IPr
         pRb8jlKcUAdiQwP2kNFimMooUPTNorSV7XmiV5VfsMiCXI4Spdgz4t78rbQsDH8b63
         PDzQvctjZH4LhBfE11+irbVUjvCisaiiTfE5p0kz7Bp3RLzdekyFMH79zOc6+jqk0G
         EOWRnhI8FXYPtLwvQvp0eq9exMNNu0hQ3GsgL1tFOrhal6OZz9L3UkktiJYTMWBCtw
         Rge2gwPdzapYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D7BBB60A23;
        Sat, 17 Jul 2021 01:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] vmxnet3: upgrade to version 6
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162648600587.17582.8823440401089158287.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Jul 2021 01:40:05 +0000
References: <20210716223626.18928-1-doshir@vmware.com>
In-Reply-To: <20210716223626.18928-1-doshir@vmware.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org, pv-drivers@vmware.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Jul 2021 15:36:19 -0700 you wrote:
> vmxnet3 emulation has recently added several new features which includes
> increase in queues supported, remove power of 2 limitation on queues,
> add RSS for ESP IPv6, etc. This patch series extends the vmxnet3 driver
> to leverage these new features.
> 
> Compatibility is maintained using existing vmxnet3 versioning mechanism as
> follows:
> - new features added to vmxnet3 emulation are associated with new vmxnet3
>    version viz. vmxnet3 version 6.
> - emulation advertises all the versions it supports to the driver.
> - during initialization, vmxnet3 driver picks the highest version number
> supported by both the emulation and the driver and configures emulation
> to run at that version.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] vmxnet3: prepare for version 6 changes
    https://git.kernel.org/netdev/net-next/c/69dbef0d1c22
  - [net-next,2/7] vmxnet3: add support for 32 Tx/Rx queues
    https://git.kernel.org/netdev/net-next/c/39f9895a00f4
  - [net-next,3/7] vmxnet3: remove power of 2 limitation on the queues
    https://git.kernel.org/netdev/net-next/c/15ccf2f4b09c
  - [net-next,4/7] vmxnet3: add support for ESP IPv6 RSS
    https://git.kernel.org/netdev/net-next/c/79d124bb36c0
  - [net-next,5/7] vmxnet3: set correct hash type based on rss information
    https://git.kernel.org/netdev/net-next/c/b3973bb40041
  - [net-next,6/7] vmxnet3: increase maximum configurable mtu to 9190
    https://git.kernel.org/netdev/net-next/c/8c5663e461e6
  - [net-next,7/7] vmxnet3: update to version 6
    https://git.kernel.org/netdev/net-next/c/ce2639ad6921

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


