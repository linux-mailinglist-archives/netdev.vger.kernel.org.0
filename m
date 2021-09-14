Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501E440ACC2
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 13:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhINLv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 07:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232147AbhINLv0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 07:51:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B7EF2610F9;
        Tue, 14 Sep 2021 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631620208;
        bh=rBzPAy1cHKgolrqrI3tDDOUExDdh2q+SVORmwOio65o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cWxE/wohYV+MDhRBQWs3XXYUyNNQxowbJgz5pnBnakoMhBF0xXyuSenONjdDOmi6Y
         LS69BOVV4jG7wIgi+p/Hcl83zlVOQ3FbvRnieHtnwwYs+s/YydvL6zxKQjj/7aDwSz
         LjxINYRj/lw0oS6ZTF8GaUtwYXHRc1DRT4Ba0TNT6FD8kjKn69MZYZAdOvDjlfw+3d
         jy2kNqFDjNHa7QU/leLraxAvPr+O34v/qL4o7A1GjUQkjp8hgCbup51bw8gqH4o7HF
         O7eASyHZ8P+8ZkuKMtYdQ5BwngAod6oLlGGb4Ys7sm4F3wmMsc5a51Yi4XJzic6CTu
         tKlvy7dcOu/uw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC1D3609E4;
        Tue, 14 Sep 2021 11:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mlxsw: spectrum: Adjustments to port split and
 label port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163162020869.1096.4681209780402863159.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Sep 2021 11:50:08 +0000
References: <20210914061330.226000-1-idosch@idosch.org>
In-Reply-To: <20210914061330.226000-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 14 Sep 2021 09:13:22 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Jiri says:
> 
> This patchset includes patches that prepare the driver to support modular
> systems.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mlxsw: spectrum: Bump minimum FW version to xx.2008.3326
    https://git.kernel.org/netdev/net-next/c/847371ce049b
  - [net-next,2/8] mlxsw: spectrum: Move port module mapping before core port init
    https://git.kernel.org/netdev/net-next/c/13eb056ee58b
  - [net-next,3/8] mlxsw: spectrum: Move port SWID set before core port init
    https://git.kernel.org/netdev/net-next/c/fec2386162d1
  - [net-next,4/8] mlxsw: reg: Add Port Local port to Label Port mapping Register
    https://git.kernel.org/netdev/net-next/c/ed403777f653
  - [net-next,5/8] mlxsw: spectrum: Use PLLP to get front panel number and split number
    https://git.kernel.org/netdev/net-next/c/1dbfc9d76551
  - [net-next,6/8] mlxsw: reg: Add Port Module To local DataBase Register
    https://git.kernel.org/netdev/net-next/c/78f824b33530
  - [net-next,7/8] mlxsw: spectrum: Use PMTDB register to obtain split info
    https://git.kernel.org/netdev/net-next/c/32ada69bba7e
  - [net-next,8/8] mlxsw: reg: Remove PMTM register
    https://git.kernel.org/netdev/net-next/c/cd92d79d5fdb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


