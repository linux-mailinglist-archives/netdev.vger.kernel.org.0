Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3554836627E
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 01:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhDTXar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 19:30:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234280AbhDTXao (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 19:30:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DADD361417;
        Tue, 20 Apr 2021 23:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618961411;
        bh=Xz6skijjHdyeohLPt7Ono/+ExdaZ6PPxbl6FspJFvgY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M6E1Fup35ffzBNRRCc3nRFRvk0q/rtgQkmOlNAnXhsRJ1XLnN1C4IFJ1BWYIXAsvm
         1FNXK68hM28zh/5/3TEerT0YJ6+DXWaAzQcwmEMixwwWhKYxAHKty7yQVsP17Bh0L2
         h46OUMaYyemc5LMVtkFszJ2ERvxtGIqBzkPBSRjwsvWgZs7lP4eyRKr8EOsTQ0LXSI
         bs0K7JY4mo2C/04uUYb7A6aIFK+GlxqLRfr4zwhFx+0oXoxhY7EtSsV11dkf+lGyR6
         mehvFfKP5F42z0NoQOblWRIJL+hCZ2vNLDAGPQSC7CqYuwiF1cq/21KgaBvIRivDf1
         +nJcL3Sg6dgOQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D148960A37;
        Tue, 20 Apr 2021 23:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5e: Fix lost changes during code movements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896141185.22203.6994210435596099737.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Apr 2021 23:30:11 +0000
References: <20210420032018.58639-2-saeed@kernel.org>
In-Reply-To: <20210420032018.58639-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, ayal@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Apr 2021 20:20:04 -0700 you wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> The changes done in commit [1] were missed by the code movements
> done in [2], as they were developed in ~parallel.
> Here we re-apply them.
> 
> [1] commit e4484d9df500 ("net/mlx5e: Enable striding RQ for Connect-X IPsec capable devices")
> [2] commit b3a131c2a160 ("net/mlx5e: Move params logic into its dedicated file")
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: Fix lost changes during code movements
    https://git.kernel.org/netdev/net-next/c/d408c01caef4
  - [net-next,02/15] net/mlx5e: Fix possible non-initialized struct usage
    https://git.kernel.org/netdev/net-next/c/6a5689ba0259
  - [net-next,03/15] net/mlx5e: RX, Add checks for calculated Striding RQ attributes
    https://git.kernel.org/netdev/net-next/c/6980ffa0c5a8
  - [net-next,04/15] net/mlx5: DR, Rename an argument in dr_rdma_segments
    https://git.kernel.org/netdev/net-next/c/7d22ad732d15
  - [net-next,05/15] net/mlx5: DR, Fix SQ/RQ in doorbell bitmask
    https://git.kernel.org/netdev/net-next/c/ff1925bb0de4
  - [net-next,06/15] net/mlx5: E-Switch, Improve error messages in term table creation
    https://git.kernel.org/netdev/net-next/c/25cb31768042
  - [net-next,07/15] net/mlx5: mlx5_ifc updates for flex parser
    https://git.kernel.org/netdev/net-next/c/704cfecdd03d
  - [net-next,08/15] net/mlx5: DR, Remove protocol-specific flex_parser_3 definitions
    https://git.kernel.org/netdev/net-next/c/323b91acc189
  - [net-next,09/15] net/mlx5: DR, Add support for dynamic flex parser
    https://git.kernel.org/netdev/net-next/c/160e9cb37a84
  - [net-next,10/15] net/mlx5: DR, Set STEv0 ICMP flex parser dynamically
    https://git.kernel.org/netdev/net-next/c/4923938d2fb5
  - [net-next,11/15] net/mlx5: DR, Add support for matching on geneve TLV option
    https://git.kernel.org/netdev/net-next/c/3442e0335e70
  - [net-next,12/15] net/mlx5: DR, Set flex parser for TNL_MPLS dynamically
    https://git.kernel.org/netdev/net-next/c/35ba005d820b
  - [net-next,13/15] net/mlx5: DR, Add support for matching tunnel GTP-U
    https://git.kernel.org/netdev/net-next/c/df9dd15ae118
  - [net-next,14/15] net/mlx5: DR, Add support for force-loopback QP
    https://git.kernel.org/netdev/net-next/c/7304d603a57a
  - [net-next,15/15] net/mlx5: DR, Add support for isolate_vl_tc QP
    https://git.kernel.org/netdev/net-next/c/aeacb52a8de7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


