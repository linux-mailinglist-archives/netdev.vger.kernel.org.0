Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DF233F934
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 20:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhCQTal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 15:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233238AbhCQTaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 15:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8059764E77;
        Wed, 17 Mar 2021 19:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616009410;
        bh=o+YKFdtUOs+RbpEUBJ7NxIf9+m3v74GjRHLZj6EKm/w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aN2HaxT0nwmkpdBbQlOHXHdFdu5iP84bkiZbZlvX5zQAq1vjmKmIKeun73pYYLx3o
         5BE+ucpTEC+67blFV80nRY0gk7/6B9FRlo61iumdYuRdT6Cxgkx/vS6cOtvooE1ctG
         BXtiNyXM6SIGNjlCJeLDNDSQ84v1Wuy0TR4QYi4b/u+oLlEl49Lq7qzSuGSC9zc1Kl
         N23EkzNy/uZQZyu7qEQqlDxYXn6/zNhcWOg/FADMjB+7xVMI701Zn/wHT45kuy0VC/
         GA09ZiPgzEJ3Lj/ANohhj/I+HaiDh/VQ2a9s3nK0G/05h34ttptFw3amEgWE+gTagI
         7+9kvS1sGVy0g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6B67960A45;
        Wed, 17 Mar 2021 19:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] mlxsw: Allow 802.1d and .1ad VxLAN bridges to
 coexist on Spectrum>=2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161600941043.18835.5149148812107351959.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 19:30:10 +0000
References: <20210317103529.2903172-1-idosch@idosch.org>
In-Reply-To: <20210317103529.2903172-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, amcohen@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Mar 2021 12:35:22 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset allows user space to simultaneously configure both 802.1d
> and 802.1ad VxLAN bridges on Spectrum-2 and later ASICs. 802.1ad VxLAN
> bridges are still forbidden on Spectrum-1.
> 
> The reason for the current limitation is that up until now the EtherType
> that was pushed to decapsulated VxLAN packets was a property of the
> tunnel port, of which there is only one. This meant that a 802.1ad VxLAN
> bridge could not be configured if the tunnel port was already configured
> to push a 802.1q tag.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] mlxsw: reg: Add egr_et_set field to SPVID
    https://git.kernel.org/netdev/net-next/c/1b35293b7afc
  - [net-next,2/7] mlxsw: reg: Add Switch Port Egress VLAN EtherType Register
    https://git.kernel.org/netdev/net-next/c/d8f4da73cea7
  - [net-next,3/7] mlxsw: spectrum: Add mlxsw_sp_port_egress_ethtype_set()
    https://git.kernel.org/netdev/net-next/c/114a465d890a
  - [net-next,4/7] mlxsw: Add struct mlxsw_sp_switchdev_ops per ASIC
    https://git.kernel.org/netdev/net-next/c/0f74fa561730
  - [net-next,5/7] mlxsw: Allow 802.1d and .1ad VxLAN bridges to coexist on Spectrum>=2
    https://git.kernel.org/netdev/net-next/c/bf677bd25a99
  - [net-next,6/7] selftests: forwarding: Add test for dual VxLAN bridge
    https://git.kernel.org/netdev/net-next/c/35f15ab378fa
  - [net-next,7/7] selftests: mlxsw: spectrum-2: Remove q_in_vni_veto test
    https://git.kernel.org/netdev/net-next/c/1724c97d2f9d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


