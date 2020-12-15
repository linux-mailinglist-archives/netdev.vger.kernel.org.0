Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19C42DA6B7
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgLODVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:21:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbgLODUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:20:51 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608002410;
        bh=0x2Pohod51W61Rjy+Dz4zEVrJ+ZfDER/aAwgSvLYH0U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R9yEtqs32b7iHlmEYZK3bzB5qfYnR11X1sow9J5FnAZNzUwjmGTP04ekDUbw7zUjM
         15fKCG17hHzXwfUz7Db06MJnMCwUfdIqeinzKGV86xPtZeg4k8j4H9wUi35xcEihTo
         eeYgLt+mlsvdL0bnOmkHLk7uMw9mWHhdtngNhGKDngQGJWAw+asqsckcq3Ap1PaszO
         V2+5rBVS6OwzJd2LOItiVd2XzrmK+bHRE8uFpdTaqZAzMU4uMrFuMPfUxCCm0AoJZK
         X5o00+e2E6QIKLQGL7iQL63X0H748FXNDDIbGxPiXTaT81yTdLA4iZGiYRJquW75Nl
         JxNNPlGdhRA6g==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/15] mlxsw: Introduce initial XM router support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160800241085.26355.8053264577757887472.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 03:20:10 +0000
References: <20201214113041.2789043-1-idosch@idosch.org>
In-Reply-To: <20201214113041.2789043-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Dec 2020 13:30:26 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patch set implements initial eXtended Mezzanine (XM) router
> support.
> 
> The XM is an external device connected to the Spectrum-{2,3} ASICs using
> dedicated Ethernet ports. Its purpose is to increase the number of
> routes that can be offloaded to hardware. This is achieved by having the
> ASIC act as a cache that refers cache misses to the XM where the FIB is
> stored and LPM lookup is performed.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/15] mlxsw: reg: Add XM Direct Register
    https://git.kernel.org/netdev/net-next/c/be6ba3b61e20
  - [net-next,v2,02/15] mlxsw: reg: Add Router XLT Enable Register
    https://git.kernel.org/netdev/net-next/c/6100fbf13d2f
  - [net-next,v2,03/15] mlxsw: spectrum_router: Introduce XM implementation of router low-level ops
    https://git.kernel.org/netdev/net-next/c/ff462103ca4d
  - [net-next,v2,04/15] mlxsw: pci: Obtain info about ports used by eXtended mezanine
    https://git.kernel.org/netdev/net-next/c/2ea3f4c7fa7c
  - [net-next,v2,05/15] mlxsw: Ignore ports that are connected to eXtended mezanine
    https://git.kernel.org/netdev/net-next/c/50779c332556
  - [net-next,v2,06/15] mlxsw: reg: Add Router XLT M select Register
    https://git.kernel.org/netdev/net-next/c/087489dc2748
  - [net-next,v2,07/15] mlxsw: reg: Add XM Lookup Table Query Register
    https://git.kernel.org/netdev/net-next/c/ec54677e55bb
  - [net-next,v2,08/15] mlxsw: spectrum_router: Introduce per-ASIC XM initialization
    https://git.kernel.org/netdev/net-next/c/e0bc244dcf58
  - [net-next,v2,09/15] mlxsw: reg: Add XM Router M Table Register
    https://git.kernel.org/netdev/net-next/c/e35e80464896
  - [net-next,v2,10/15] mlxsw: spectrum_router_xm: Implement L-value tracking for M-index
    https://git.kernel.org/netdev/net-next/c/54ff9dbbb96f
  - [net-next,v2,11/15] mlxsw: reg: Add Router LPM Cache ML Delete Register
    https://git.kernel.org/netdev/net-next/c/edb47f3d2368
  - [net-next,v2,12/15] mlxsw: reg: Add Router LPM Cache Enable Register
    https://git.kernel.org/netdev/net-next/c/069254662b65
  - [net-next,v2,13/15] mlxsw: spectrum_router_xm: Introduce basic XM cache flushing
    https://git.kernel.org/netdev/net-next/c/2dfad87a24de
  - [net-next,v2,14/15] mlxsw: spectrum: Set KVH XLT cache mode for Spectrum2/3
    https://git.kernel.org/netdev/net-next/c/dffd566136d7
  - [net-next,v2,15/15] mlxsw: spectrum_router: Use eXtended mezzanine to offload IPv4 router
    https://git.kernel.org/netdev/net-next/c/88a31b18b6df

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


