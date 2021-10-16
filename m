Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C839743010D
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239870AbhJPIFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239866AbhJPICc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Oct 2021 04:02:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 16D3361242;
        Sat, 16 Oct 2021 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634371215;
        bh=3Jmht32j/5SNE/+y7WKMJLlCO/sVKxOH+AOIUpuSkGA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XupZAy5no4Gkp9lhFF8+GV3UErrudxjHZuhqeH5v5aEWI8eTk9NSGuAlP753m3byU
         s+2HKCDyVQlBcDsz84quxIZUS8R8d5qYKG91ArF/SobgWRKQOzBy7kptxF3qUQN10F
         NdGg0GeUZ/4GwvPUO27fcUYt1DdNEEkAnPFiCjYS//5dRHDns87ilz7bThJU1F9j91
         bk5rWSji8juuD9pLCh6ews+16mlIB/Mo2BRvkHSCPpkm6RUcgeemF0xmKtFjqolVA+
         MTNtU2k9REqAN/So6fSVgAbuboPHmDmvyBjUzNB9JIX7fdeXcJPyU/2Tx3iX5lugrh
         tYBHvxDFzImmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 02DB160A44;
        Sat, 16 Oct 2021 08:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/13] net/mlx5: Add layout to support default timeouts
 register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163437121500.28528.12494239407753342994.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Oct 2021 08:00:15 +0000
References: <20211016003902.57116-2-saeed@kernel.org>
In-Reply-To: <20211016003902.57116-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        amirtz@nvidia.com, moshe@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Fri, 15 Oct 2021 17:38:50 -0700 you wrote:
> From: Amir Tzin <amirtz@nvidia.com>
> 
> Add needed structures and defines for DTOR (default timeouts register).
> This will be used to get timeouts values from FW instead of hard coded
> values in the driver code thus enabling support for slower devices which
> need longer timeouts.
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] net/mlx5: Add layout to support default timeouts register
    https://git.kernel.org/netdev/net-next/c/4b2c5fa9c990
  - [net-next,02/13] net/mlx5: Read timeout values from init segment
    https://git.kernel.org/netdev/net-next/c/5945e1adeab5
  - [net-next,03/13] net/mlx5: Read timeout values from DTOR
    https://git.kernel.org/netdev/net-next/c/32def4120e48
  - [net-next,04/13] net/mlx5: Bridge, provide flow source hints
    https://git.kernel.org/netdev/net-next/c/17ac528d8868
  - [net-next,05/13] net/mlx5i: Enable Rx steering for IPoIB via ethtool
    https://git.kernel.org/netdev/net-next/c/9fbe1c25ecca
  - [net-next,06/13] net/mlx5: Disable roce at HCA level
    https://git.kernel.org/netdev/net-next/c/fbfa97b4d79f
  - [net-next,07/13] net/mlx5: CT: Fix missing cleanup of ct nat table on init failure
    https://git.kernel.org/netdev/net-next/c/88594d83314a
  - [net-next,08/13] net/mlx5e: Add extack msgs related to TC for better debug
    https://git.kernel.org/netdev/net-next/c/0885ae1a9d34
  - [net-next,09/13] net/mlx5: DR, Prefer kcalloc over open coded arithmetic
    https://git.kernel.org/netdev/net-next/c/0e6f3ef469bb
  - [net-next,10/13] net/mlx5: Check return status first when querying system_image_guid
    https://git.kernel.org/netdev/net-next/c/7b1b6d35f045
  - [net-next,11/13] net/mlx5: Introduce new device index wrapper
    https://git.kernel.org/netdev/net-next/c/2ec16ddde1fa
  - [net-next,12/13] net/mlx5: Use native_port_num as 1st option of device index
    https://git.kernel.org/netdev/net-next/c/1021d0645d59
  - [net-next,13/13] net/mlx5: Use system_image_guid to determine bonding
    https://git.kernel.org/netdev/net-next/c/8a543184d79c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


