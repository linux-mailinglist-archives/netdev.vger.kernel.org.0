Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B423E92D3
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhHKNkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhHKNka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 09:40:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 493CE60FE6;
        Wed, 11 Aug 2021 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628689207;
        bh=IJaMgjE53BRCVC2INSvA22emIszu7E/N6SBSob5CYS4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TLTjKFa4tS8ohTItiqsrNjxQa0oVLUNoiLGS6HiUe1u5p6kE0sC6luXlThneUGEpA
         MgXwa7g8LQ1w3MT1N5fi4+RcE4PxwcNI0vX1B1S8Els10edChOIyw6+ZdtcoHjFoIT
         +jH8hBnYqTzh8i8c2Gw7lqf1gniesSHhLZa4464kTxybCyTwNbXIrJcaK1tBvJ3WRV
         8cqPmeTP9gcCwpjCy4qwyDzxUU88IyE5iOnGhasLV0Esqce6rD/I1OBsTXpSWgREFX
         QfHemuAasXdr+46qQ4nlmC6XUHK1Y/CTaE32+UylNpK746p7QMqzGIszRmKIBMED6A
         DmWhJVGN0wByQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D9F960A3B;
        Wed, 11 Aug 2021 13:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next 00/10] devlink: Control auxiliary devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162868920724.16245.8369444403907708271.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Aug 2021 13:40:07 +0000
References: <20210810132424.9129-1-parav@nvidia.com>
In-Reply-To: <20210810132424.9129-1-parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 10 Aug 2021 16:24:14 +0300 you wrote:
> (Resend to CC RDMA and vdpa mailing lists).
> 
> Hi Dave, Jakub,
> 
> Currently, for mlx5 multi-function device, a user is not able to control
> which functionality to enable/disable. For example, each PCI
> PF, VF, SF function by default has netdevice, RDMA and vdpa-net
> devices always enabled.
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,01/10] devlink: Add new "enable_eth" generic device param
    https://git.kernel.org/netdev/net-next/c/f13a5ad88186
  - [RESEND,net-next,02/10] devlink: Add new "enable_rdma" generic device param
    https://git.kernel.org/netdev/net-next/c/8ddaabee3c79
  - [RESEND,net-next,03/10] devlink: Add new "enable_vnet" generic device param
    https://git.kernel.org/netdev/net-next/c/076b2a9dbb28
  - [RESEND,net-next,04/10] devlink: Create a helper function for one parameter registration
    https://git.kernel.org/netdev/net-next/c/699784f7b728
  - [RESEND,net-next,05/10] devlink: Add API to register and unregister single parameter
    https://git.kernel.org/netdev/net-next/c/b40c51efefbc
  - [RESEND,net-next,06/10] devlink: Add APIs to publish, unpublish individual parameter
    https://git.kernel.org/netdev/net-next/c/9c4a7665b423
  - [RESEND,net-next,07/10] net/mlx5: Fix unpublish devlink parameters
    https://git.kernel.org/netdev/net-next/c/6f35723864b4
  - [RESEND,net-next,08/10] net/mlx5: Support enable_eth devlink dev param
    https://git.kernel.org/netdev/net-next/c/a17beb28ed9d
  - [RESEND,net-next,09/10] net/mlx5: Support enable_rdma devlink dev param
    https://git.kernel.org/netdev/net-next/c/87158cedf00e
  - [RESEND,net-next,10/10] net/mlx5: Support enable_vnet devlink dev param
    https://git.kernel.org/netdev/net-next/c/70862a5d609d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


