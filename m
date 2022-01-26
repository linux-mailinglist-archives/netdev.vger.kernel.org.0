Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C644949C882
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 12:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240604AbiAZLUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 06:20:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39218 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240588AbiAZLUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 06:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0C05618EF
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29D79C340E5;
        Wed, 26 Jan 2022 11:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643196011;
        bh=rsOJjhkVUTRAy+En+yY/RjCem+EbMJNAqa2yRAJljqo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vm0s/4aOtbjoP0NwQcMrygEdyD3NUXeGggSE2WakmW0wByd5QTCZnuIPr3LbjoEe2
         Pff7BLX5n2Q9KFV0OnoGAs5dlooB+ymVMsrPrXVat51PftM9n+nHYewDpHbTlbJ7Du
         pnp0aHBl/f0SlXx8mF136a/w92ISzwsqb+zGyJOHapJh4/qK59Mme+mW8MoySwNAW1
         WpHdoxNF++RIVJKTC0T20ZC8tOqY4vKNJ8PVdIbXkxun3AvD9feV9VUJLmIp8UeWgC
         Z1Z7FUv4vwjk6tPaz8qsDNZxx5CmxhD2oN6MvmhfSMQaip2Ni+1GErzK+Ymgl+IuaL
         h8aM1JtHtudxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0FCB4E5D07D;
        Wed, 26 Jan 2022 11:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] mlxsw: Add RJ45 ports support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164319601105.29999.18362500970321068775.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Jan 2022 11:20:11 +0000
References: <20220126103037.234986-1-idosch@nvidia.com>
In-Reply-To: <20220126103037.234986-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Jan 2022 12:30:28 +0200 you wrote:
> We are in the process of qualifying a new system that has RJ45 ports as
> opposed to the transceiver modules (e.g., SFP, QSFP) present on all
> existing systems.
> 
> This patchset adds support for these ports in mlxsw by adding a couple of
> missing BaseT link modes and rejecting ethtool operations that are
> specific to transceiver modules.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] mlxsw: spectrum_ethtool: Remove redundant variable
    https://git.kernel.org/netdev/net-next/c/5c759fe24cdb
  - [net-next,2/9] mlxsw: core_env: Do not pass number of modules as argument
    https://git.kernel.org/netdev/net-next/c/6af5f7b674e4
  - [net-next,3/9] mlxsw: Add netdev argument to mlxsw_env_get_module_info()
    https://git.kernel.org/netdev/net-next/c/5eaec6d86805
  - [net-next,4/9] mlxsw: spectrum_ethtool: Add support for two new link modes
    https://git.kernel.org/netdev/net-next/c/78cf4b92218b
  - [net-next,5/9] mlxsw: reg: Add Port Module Type Mapping register
    https://git.kernel.org/netdev/net-next/c/0d31441e8793
  - [net-next,6/9] mlxsw: core_env: Query and store port module's type during initialization
    https://git.kernel.org/netdev/net-next/c/e62f5b0e3faa
  - [net-next,7/9] mlxsw: core_env: Forbid getting module EEPROM on RJ45 ports
    https://git.kernel.org/netdev/net-next/c/615ebb8cc4e2
  - [net-next,8/9] mlxsw: core_env: Forbid power mode set and get on RJ45 ports
    https://git.kernel.org/netdev/net-next/c/c8f994ccdd9a
  - [net-next,9/9] mlxsw: core_env: Forbid module reset on RJ45 ports
    https://git.kernel.org/netdev/net-next/c/b7347cdf10fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


