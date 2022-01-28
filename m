Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF7649F1E1
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 04:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345794AbiA1DaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 22:30:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37862 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345589AbiA1DaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 22:30:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BB9261E13
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 03:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96127C340EA;
        Fri, 28 Jan 2022 03:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643340612;
        bh=x7oFbEMXpQ0PjkL9yFLnFYTPqV0WhG3fLhcoslwt7NI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ceQqL3Jf4dkxfjenWZrIPAPbfFbWsh1gg5LUr03nKOllS3ADn/YUuocAqgnKPiAd6
         HuFZRB4CAf61byRAtP1/wI8j6GbT5PNtHaU+lY3ky6xCQewATDRQhIRrHgMo3ZCczm
         Lwg3aIDDQ01mwp0swBldt3YYB2Ire+AUyWr9HISQU8bYscJJOIo1LD/g059DvYqf9d
         5SZznFc8cCejjlSif6LvqQ7RartDcDPaV70Z59X2IQSTClprg7Xp53BNwuWj9FAXIh
         3rTeo1k5VFFTE7z29P7oerdcnl56J1U0296N2kqTFlkM0FMZXTBLtMvS8/1wwmz7Rz
         BFGrySy7+59Ew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79DE9E5D07D;
        Fri, 28 Jan 2022 03:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] mlxsw: Various updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164334061249.5963.14021766704763689043.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 03:30:12 +0000
References: <20220127090226.283442-1-idosch@nvidia.com>
In-Reply-To: <20220127090226.283442-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, jiri@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Jan 2022 11:02:19 +0200 you wrote:
> This patchset contains miscellaneous updates for mlxsw. No user visible
> changes that I am aware of.
> 
> Patches #1-#5 rework registration of internal traps in preparation of
> line cards support.
> 
> Patch #6 improves driver resilience against a misbehaving device.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] mlxsw: spectrum: Set basic trap groups from an array
    https://git.kernel.org/netdev/net-next/c/7aad5244f000
  - [net-next,2/7] mlxsw: core: Move basic_trap_groups_set() call out of EMAD init code
    https://git.kernel.org/netdev/net-next/c/74e0494d35ac
  - [net-next,3/7] mlxsw: core: Move basic trap group initialization from spectrum.c
    https://git.kernel.org/netdev/net-next/c/8ae89cf454b0
  - [net-next,4/7] mlxsw: core: Move functions to register/unregister array of traps to core.c
    https://git.kernel.org/netdev/net-next/c/981f1d18be40
  - [net-next,5/7] mlxsw: core: Consolidate trap groups to a single event group
    https://git.kernel.org/netdev/net-next/c/636d3ad23890
  - [net-next,6/7] mlxsw: spectrum: Guard against invalid local ports
    https://git.kernel.org/netdev/net-next/c/bcdfd615f83b
  - [net-next,7/7] mlxsw: spectrum_acl: Allocate default actions for internal TCAM regions
    https://git.kernel.org/netdev/net-next/c/ef14c298b5b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


