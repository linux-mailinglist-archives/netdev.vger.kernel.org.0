Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7E9386CF4
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343840AbhEQWbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343727AbhEQWb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 18:31:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A951161350;
        Mon, 17 May 2021 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621290611;
        bh=zMM9l49Mp8yYCEeg9oaBiRQ5Z7RnG3WX+DWNxKTUQZU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ufa0HYj4JD3lEwxMFh44S/8X1yuHeAMPN2R5aGlHMfg2hu4Ws+HJ84gK+emvYJcwf
         q1uQPxri8JYGxhKYu0LvV1EzxRRFxOu3qEIvqABwvbhjDMqQqkV34a/uW/TpRan1CC
         5zvhlmuzwNji0ZHg3siEQ9nR0+F6QraJuj/jedV3mz6MM15mM4GpaMCcM+IiQeHTgA
         8ps3K8eJH7spjeBv8pmBtgTyZEAshkIXr1wSDCEdKtydoHglOqjLbSBKV21ZfllbTf
         FAfSewZpkzMFEheN8Aj/MFqbFeMPwryMHRT7KYlO2Klmd+kfkkfMd4VCBJaP9kJQV8
         czHcIGe3UN99Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A3F1D60A4F;
        Mon, 17 May 2021 22:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] mlxsw: Various updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162129061166.6973.3193679041843622426.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 22:30:11 +0000
References: <20210517170401.188563-1-idosch@nvidia.com>
In-Reply-To: <20210517170401.188563-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@OSS.NVIDIA.COM>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@OSS.NVIDIA.COM, petrm@OSS.NVIDIA.COM,
        danieller@OSS.NVIDIA.COM, amcohen@OSS.NVIDIA.COM,
        mlxsw@OSS.NVIDIA.COM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 17 May 2021 20:03:50 +0300 you wrote:
> This patchset contains various updates to the mlxsw driver and related
> selftests.
> 
> Patches #1-#5 contain various updates to mlxsw selftests. The most
> significant change is the conversion of the DCB selftests to use the new
> iproute2 DCB support.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] selftests: mlxsw: Make the unsplit array global in port_scale test
    https://git.kernel.org/netdev/net-next/c/5d01071e64b6
  - [net-next,02/11] selftests: mlxsw: Make sampling test more robust
    https://git.kernel.org/netdev/net-next/c/16355c0b101e
  - [net-next,03/11] selftests: mlxsw: qos_headroom: Convert to iproute2 dcb
    https://git.kernel.org/netdev/net-next/c/9a1cac062d3e
  - [net-next,04/11] selftests: mlxsw: qos_pfc: Convert to iproute2 dcb
    https://git.kernel.org/netdev/net-next/c/b0bab2298ec9
  - [net-next,05/11] selftests: mlxsw: qos_lib: Drop __mlnx_qos
    https://git.kernel.org/netdev/net-next/c/b4d786941b58
  - [net-next,06/11] mlxsw: spectrum_buffers: Switch function arguments
    https://git.kernel.org/netdev/net-next/c/ece5df874d3a
  - [net-next,07/11] mlxsw: Verify the accessed index doesn't exceed the array length
    https://git.kernel.org/netdev/net-next/c/837ec05cfea0
  - [net-next,08/11] mlxsw: core: Avoid unnecessary EMAD buffer copy
    https://git.kernel.org/netdev/net-next/c/8c2b58e65d01
  - [net-next,09/11] mlxsw: spectrum_router: Avoid missing error code warning
    https://git.kernel.org/netdev/net-next/c/51746a353b44
  - [net-next,10/11] mlxsw: Remove Mellanox SwitchIB ASIC support
    https://git.kernel.org/netdev/net-next/c/9b43fbb8ce24
  - [net-next,11/11] mlxsw: Remove Mellanox SwitchX-2 ASIC support
    https://git.kernel.org/netdev/net-next/c/b0d80c013b04

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


