Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DA1418116
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 12:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244425AbhIYKlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 06:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233380AbhIYKln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 06:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 588A961279;
        Sat, 25 Sep 2021 10:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632566409;
        bh=XSr3OeJVNocSOlMuGHHphfgD0NDMtlmWaiZFFrVIa/U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GejpC7iFHuZG1DJX/L25IVIKjH4QvVBwy1PCJTK3gwj1ANNEfp9gXttmj9wpYOo9E
         ZyGn3dZ1drValAeeNw1rCcG3plofDeP4oVgoboDiVSxrVGoU3ajs69lWazHMwzqtP6
         vmcsgeUIfcoQSgulpypO/LkwgHpnTEZc03MRyfzqoBSrCLOOe5fHxQXCzq62DTnKj8
         LgTNSrea4//Qomu0D2uPoCVXOsIAG5tXp8v13YBhG5PV4JuP0VaGkuxz63620knK3d
         kg+DPKGzD3dXby2dPhbpGa0WVLoxYYe1+2f+jqNt97ovmP7hbypvdxaifWKOf/6I3O
         JP4NahhvhP4pw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4FA85600E8;
        Sat, 25 Sep 2021 10:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/12] net/mlx5: DR, Fix code indentation in dr_ste_v1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163256640932.24365.15348244365644360246.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Sep 2021 10:40:09 +0000
References: <20210924184808.796968-2-saeed@kernel.org>
In-Reply-To: <20210924184808.796968-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kliteyn@nvidia.com, lkp@intel.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 24 Sep 2021 11:47:57 -0700 you wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next,01/12] net/mlx5: DR, Fix code indentation in dr_ste_v1
    https://git.kernel.org/netdev/net-next/c/c228dce26222
  - [net-next,02/12] net/mlx5e: Add error flow for ethtool -X command
    https://git.kernel.org/netdev/net-next/c/6c2509d44636
  - [net-next,03/12] net/mlx5e: Use correct return type
    https://git.kernel.org/netdev/net-next/c/1836d78015b4
  - [net-next,04/12] net/mlx5e: Remove incorrect addition of action fwd flag
    https://git.kernel.org/netdev/net-next/c/475fb86ac941
  - [net-next,05/12] net/mlx5e: Set action fwd flag when parsing tc action goto
    https://git.kernel.org/netdev/net-next/c/7f8770c71646
  - [net-next,06/12] net/mlx5e: Check action fwd/drop flag exists also for nic flows
    https://git.kernel.org/netdev/net-next/c/6b50cf45b6a0
  - [net-next,07/12] net/mlx5e: Remove redundant priv arg from parse_pedit_to_reformat()
    https://git.kernel.org/netdev/net-next/c/1cc35b707ced
  - [net-next,08/12] net/mlx5e: Use tc sample stubs instead of ifdefs in source file
    https://git.kernel.org/netdev/net-next/c/f3e02e479deb
  - [net-next,09/12] net/mlx5e: Use NL_SET_ERR_MSG_MOD() for errors parsing tunnel attributes
    https://git.kernel.org/netdev/net-next/c/c50775d0e226
  - [net-next,10/12] net/mlx5e: loopback test is not supported in switchdev mode
    https://git.kernel.org/netdev/net-next/c/7990b1b5e8bd
  - [net-next,11/12] net/mlx5e: Enable TC offload for egress MACVLAN
    https://git.kernel.org/netdev/net-next/c/fca572f2bcdd
  - [net-next,12/12] net/mlx5e: Enable TC offload for ingress MACVLAN
    https://git.kernel.org/netdev/net-next/c/05000bbba1e9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


