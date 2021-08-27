Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046233F96AB
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244591AbhH0JLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232048AbhH0JLQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 05:11:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CF63F60F92;
        Fri, 27 Aug 2021 09:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630055427;
        bh=WxwnX9IVXDE1fFnvmWDfRHsn2fD28WEi+ksrXzYwg4w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VxkVUYbu1zHSvwCacwNliptO4kDDMcdnGGXMwBRHrr3iRjO0fTO8+teLqkKkCTN8l
         FLqauOvtf8f1kURS2TrrEtlyaEwZtzjPluFeWXMlyawg2l2az/qBRv2gaQD9rXPZqy
         oLfre2pbJ+k8muePj4B3U+p0HLj7iB4HO7ANiP5CpW3Y7aeFHO90UdP4WMIr/p1Sri
         5FBtlGLtwouWFhJfZ65lxsJH7RIdSD1uWSzOqGq2yos1gqxVyVFbTqaQd3pLdTbag+
         1JpAqynA/0zMUEVkRWacHhZSujtYNqVmBMKsMCOLAOmPFqyFO7OX7dOkeVxtOtUh7j
         BjzKKql0kufrQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C98EF60972;
        Fri, 27 Aug 2021 09:10:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/17] net/mlx5: DR,
 Added support for REMOVE_HEADER packet reformat
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163005542782.19735.394321879807219573.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Aug 2021 09:10:27 +0000
References: <20210827005802.236119-2-saeed@kernel.org>
In-Reply-To: <20210827005802.236119-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kliteyn@nvidia.com, valex@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 26 Aug 2021 17:57:46 -0700 you wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> 
> ConnectX supports offloading of various encapsulations and decapsulations
> (e.g. VXLAN), which are performed by 'Packet Reformat' action. Starting
> with ConnectX-6 DX, a new reformat type is supported - REMOVE_HEADER, which
> allows deleting an arbitrary size chunk at the selected position in the packet.
> 
> [...]

Here is the summary with links:
  - [net-next,01/17] net/mlx5: DR, Added support for REMOVE_HEADER packet reformat
    https://git.kernel.org/netdev/net-next/c/0139145fb8d8
  - [net-next,02/17] net/mlx5: DR, Split modify VLAN state to separate pop/push states
    https://git.kernel.org/netdev/net-next/c/f5e22be534e0
  - [net-next,03/17] net/mlx5: DR, Enable VLAN pop on TX and VLAN push on RX
    https://git.kernel.org/netdev/net-next/c/2de40f68cf76
  - [net-next,04/17] net/mlx5: DR, Enable QP retransmission
    https://git.kernel.org/netdev/net-next/c/ec449ed8230c
  - [net-next,05/17] net/mlx5: DR, Improve error flow in actions_build_ste_arr
    https://git.kernel.org/netdev/net-next/c/f35715a65747
  - [net-next,06/17] net/mlx5: DR, Warn and ignore SW steering rule insertion on QP err
    https://git.kernel.org/netdev/net-next/c/d5a84e968f3d
  - [net-next,07/17] net/mlx5: DR, Reduce print level for FT chaining level check
    https://git.kernel.org/netdev/net-next/c/d7d0b2450e93
  - [net-next,08/17] net/mlx5: DR, Support IPv6 matching on flow label for STEv0
    https://git.kernel.org/netdev/net-next/c/0733535d59e1
  - [net-next,09/17] net/mlx5: DR, replace uintN_t with kernel-style types
    https://git.kernel.org/netdev/net-next/c/ae3eddcff7aa
  - [net-next,10/17] net/mlx5: DR, Use FW API when updating FW-owned flow table
    https://git.kernel.org/netdev/net-next/c/a01a43fa16e1
  - [net-next,11/17] net/mlx5: DR, Add ignore_flow_level support for multi-dest flow tables
    https://git.kernel.org/netdev/net-next/c/63b85f49c05a
  - [net-next,12/17] net/mlx5: DR, Skip source port matching on FDB RX domain
    https://git.kernel.org/netdev/net-next/c/990467f8afde
  - [net-next,13/17] net/mlx5: DR, Merge DR_STE_SIZE enums
    https://git.kernel.org/netdev/net-next/c/ab9d1f96120b
  - [net-next,14/17] net/mlx5: DR, Remove HW specific STE type from nic domain
    https://git.kernel.org/netdev/net-next/c/46f2a8ae8a70
  - [net-next,15/17] net/mlx5: DR, Remove rehash ctrl struct from dr_htbl
    https://git.kernel.org/netdev/net-next/c/32c8e3b23020
  - [net-next,16/17] net/mlx5: DR, Improve rule tracking memory consumption
    https://git.kernel.org/netdev/net-next/c/8a015baef50a
  - [net-next,17/17] net/mlx5: DR, Add support for update FTE
    https://git.kernel.org/netdev/net-next/c/a2ebfbb7b181

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


