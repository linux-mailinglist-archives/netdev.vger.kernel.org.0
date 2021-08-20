Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587623F2C7D
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 14:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240575AbhHTMxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 08:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237844AbhHTMxJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 08:53:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FDAF6101A;
        Fri, 20 Aug 2021 12:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629463951;
        bh=gZDXdebizfdYAWiWqH7MEOJ4S1ONVSU5aokxdq3Xwmo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lweFOBjY9mV5zM5pp8C5YRhUoJhSzYLuZJq/Zi8txQWNIkkVOdjSYfXBKE9pGuQET
         fp+dPuxU1YkTgYSP4t4WvsvNP+2F5pL2RZfSZ5yplk+2XD+QaV1zz0OWfx2pdRiL02
         2kkC9Ty9sb0FOTo4R9bKp2vV5TkdB9y/vu+oZqBkwPVpDFPpG+Mg23dU9z8d9uuZj1
         jomdhFiemZgcnhx9jdWfrGJZkqtsD8PpzGwGe63gO+o0Wu92DPpG4fNX4tND37Y4Ao
         dfC7HvNlDEN6IxjlNBwUrlorOsOdMHB5xKIKSyXf4XTNw+KRyh3EIcD9QMDpxB1q7C
         GMNk4hmvcnc7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8999160A89;
        Fri, 20 Aug 2021 12:52:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5e: Remove mlx5e dependency from E-Switch
 sample
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946395155.27725.11379956803224117097.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 12:52:31 +0000
References: <20210820045515.265297-2-saeed@kernel.org>
In-Reply-To: <20210820045515.265297-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com, roid@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Aug 2021 21:55:01 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> mlx5/esw/sample.c doesn't really need mlx5e_priv object, we can remove
> this redundant dependency by passing the eswitch object directly to
> the sample object constructor.
> 
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: Remove mlx5e dependency from E-Switch sample
    https://git.kernel.org/netdev/net-next/c/5024fa95a144
  - [net-next,02/15] net/mlx5e: Move esw/sample to en/tc/sample
    https://git.kernel.org/netdev/net-next/c/0027d70c73c9
  - [net-next,03/15] net/mlx5e: Move sample attribute to flow attribute
    https://git.kernel.org/netdev/net-next/c/bcd6740c6b6d
  - [net-next,04/15] net/mlx5e: CT, Use xarray to manage fte ids
    https://git.kernel.org/netdev/net-next/c/2799797845db
  - [net-next,05/15] net/mlx5e: Introduce post action infrastructure
    https://git.kernel.org/netdev/net-next/c/6f0b692a5aa9
  - [net-next,06/15] net/mlx5e: Refactor ct to use post action infrastructure
    https://git.kernel.org/netdev/net-next/c/f0da4daa3413
  - [net-next,07/15] net/mlx5e: TC, Remove CONFIG_NET_TC_SKB_EXT dependency when restoring tunnel
    https://git.kernel.org/netdev/net-next/c/d12e20ac0661
  - [net-next,08/15] net/mlx5e: TC, Restore tunnel info for sample offload
    https://git.kernel.org/netdev/net-next/c/ee950e5db1b9
  - [net-next,09/15] net/mlx5e: TC, Support sample offload action for tunneled traffic
    https://git.kernel.org/netdev/net-next/c/2741f2230905
  - [net-next,10/15] net/mlx5: E-switch, Move QoS related code to dedicated file
    https://git.kernel.org/netdev/net-next/c/2d116e3e7e49
  - [net-next,11/15] net/mlx5: E-switch, Enable devlink port tx_{share|max} rate control
    https://git.kernel.org/netdev/net-next/c/ad34f02fe2c9
  - [net-next,12/15] net/mlx5: E-switch, Introduce rate limiting groups API
    https://git.kernel.org/netdev/net-next/c/1ae258f8b343
  - [net-next,13/15] net/mlx5: E-switch, Allow setting share/max tx rate limits of rate groups
    https://git.kernel.org/netdev/net-next/c/f47e04eb96e0
  - [net-next,14/15] net/mlx5: E-switch, Allow to add vports to rate groups
    https://git.kernel.org/netdev/net-next/c/0fe132eac38c
  - [net-next,15/15] net/mlx5: E-switch, Add QoS tracepoints
    https://git.kernel.org/netdev/net-next/c/3202ea65f85c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


