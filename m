Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E0440C851
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbhIOPb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:31:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234041AbhIOPb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 11:31:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 45C0160F6D;
        Wed, 15 Sep 2021 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631719809;
        bh=HXio21AH13IKhGfp+Ia6zP8AmBe7/BAlBbAGqOUFakM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pZTom2iOId+UmVihg8UFVqCPBqSvSdZvc+/gDjiNikuXzpbqoEOCsOKVNCK+PXK/c
         NKzLmTsLazhmu+b4QfL5m0Qg7lYDQpeSZql26u4Srmyk/tZRsMVFdGuW8VykZ+GMrE
         NQqVMKadPcEviGV2abXbOT1r5ut+XGA4kEH2Yi1+kZPUcLUDnSPAp1Cl1t/+EVgSq/
         2a7gDnHjU8y16TcSg16IMj1fQPHisZCp5YD/LoxIcT4j2TrQtua73mIv1k+0ULycmM
         4GJyn0hglgJuoy3+kOis+76pXOpD3tmQh8kp2lQJM5bIGWpr1Hb5EQj6SXd0xbsZSN
         1TfezaV6v3MmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 33FFB60A9E;
        Wed, 15 Sep 2021 15:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] mlxsw: Add support for transceiver modules
 reset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163171980920.25861.1579195351317049267.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Sep 2021 15:30:09 +0000
References: <20210915101314.407476-1-idosch@idosch.org>
In-Reply-To: <20210915101314.407476-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 15 Sep 2021 13:13:04 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset prepares mlxsw for future transceiver modules related [1]
> changes and adds reset support via the existing 'ETHTOOL_RESET'
> interface.
> 
> Patches #1-#6 are relatively straightforward preparations.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] mlxsw: core: Initialize switch driver last
    https://git.kernel.org/netdev/net-next/c/3d7a6f677905
  - [net-next,02/10] mlxsw: core: Remove mlxsw_core_is_initialized()
    https://git.kernel.org/netdev/net-next/c/25a91f835a7b
  - [net-next,03/10] mlxsw: core_env: Defer handling of module temperature warning events
    https://git.kernel.org/netdev/net-next/c/163f3d2dd01c
  - [net-next,04/10] mlxsw: core_env: Convert 'module_info_lock' to a mutex
    https://git.kernel.org/netdev/net-next/c/bd6e43f5953d
  - [net-next,05/10] mlxsw: spectrum: Do not return an error in ndo_stop()
    https://git.kernel.org/netdev/net-next/c/06277ca23868
  - [net-next,06/10] mlxsw: spectrum: Do not return an error in mlxsw_sp_port_module_unmap()
    https://git.kernel.org/netdev/net-next/c/196bff2927a7
  - [net-next,07/10] mlxsw: Track per-module port status
    https://git.kernel.org/netdev/net-next/c/896f399be078
  - [net-next,08/10] mlxsw: reg: Add fields to PMAOS register
    https://git.kernel.org/netdev/net-next/c/ef23841bb94a
  - [net-next,09/10] mlxsw: Make PMAOS pack function more generic
    https://git.kernel.org/netdev/net-next/c/8f4ebdb0a274
  - [net-next,10/10] mlxsw: Add support for transceiver modules reset
    https://git.kernel.org/netdev/net-next/c/49fd3b645de8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


