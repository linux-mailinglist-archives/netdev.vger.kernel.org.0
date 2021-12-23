Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DFA47DD5F
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238160AbhLWBaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:30:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56270 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhLWBaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:30:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58FEAB81F4C
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 01:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0236CC36AEB;
        Thu, 23 Dec 2021 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640223014;
        bh=ju7+eXK0UlK1ukVnstEVDckJjjqSsqhXDu4C+9tGqzs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pMYyIsejR2gu+IJx7b5MYSeFgvqJypfBpqDWb9tDwbSBfFzLuZxeAlqc+xpkxVWui
         YN8BCx7DEDGD73i296v1mwOHhxn/as8x8pJNb5YO2oU2yEtV91o/iRSBtPYi32e9+X
         jCNmeEWstb3gBpWS0jspau4gTCQvsGBnGCRydnj1rccQ+stSLi5HB/NbUAMb3qW1SH
         OVjYbqnpvnZeN9XEg47LRB0ahTqSLX3QVluqqTj00vq4x00UkFAg0F3LXZ0H81ezfi
         ggbtKhdTCwXHB1hz4R/uhRq9XLF3cgfRs16rbTwpQez8PGBldw7NxeDKM53y+X3Wh/
         VIfhkycFynhPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB645FE55BD;
        Thu, 23 Dec 2021 01:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v0 01/14] devlink: Add new "io_eq_size" generic device
 param
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164022301389.9224.3690440369480515941.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 01:30:13 +0000
References: <20211222031604.14540-2-saeed@kernel.org>
In-Reply-To: <20211222031604.14540-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        shayd@nvidia.com, moshe@nvidia.com, jiri@nvidia.com,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 21 Dec 2021 19:15:51 -0800 you wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> Add new device generic parameter to determine the size of the
> I/O completion EQs.
> 
> For example, to reduce I/O EQ size to 64, execute:
> $ devlink dev param set pci/0000:06:00.0 \
>               name io_eq_size value 64 cmode driverinit
> $ devlink dev reload pci/0000:06:00.0
> 
> [...]

Here is the summary with links:
  - [net-next,v0,01/14] devlink: Add new "io_eq_size" generic device param
    https://git.kernel.org/netdev/net-next/c/47402385d0b1
  - [net-next,v0,02/14] net/mlx5: Let user configure io_eq_size param
    https://git.kernel.org/netdev/net-next/c/0844fa5f7b89
  - [net-next,v0,03/14] devlink: Add new "event_eq_size" generic device param
    https://git.kernel.org/netdev/net-next/c/0b5705ebc355
  - [net-next,v0,04/14] net/mlx5: Let user configure event_eq_size param
    https://git.kernel.org/netdev/net-next/c/57ca767820ad
  - [net-next,v0,05/14] devlink: Clarifies max_macs generic devlink param
    https://git.kernel.org/netdev/net-next/c/0ad598d0be22
  - [net-next,v0,06/14] net/mlx5: Let user configure max_macs generic param
    https://git.kernel.org/netdev/net-next/c/8680a60fc1fc
  - [net-next,v0,07/14] net/mlx5: Remove the repeated declaration
    https://git.kernel.org/netdev/net-next/c/08ab0ff47bf7
  - [net-next,v0,08/14] net/mlx5e: Use bitmap field for profile features
    https://git.kernel.org/netdev/net-next/c/6c72cb05d4b8
  - [net-next,v0,09/14] net/mlx5e: Add profile indications for PTP and QOS HTB features
    https://git.kernel.org/netdev/net-next/c/1958c2bddfa2
  - [net-next,v0,10/14] net/mlx5e: Save memory by using dynamic allocation in netdev priv
    https://git.kernel.org/netdev/net-next/c/0246a57ab517
  - [net-next,v0,11/14] net/mlx5e: Allow profile-specific limitation on max num of channels
    https://git.kernel.org/netdev/net-next/c/473baf2e9e8c
  - [net-next,v0,12/14] net/mlx5e: Use dynamic per-channel allocations in stats
    https://git.kernel.org/netdev/net-next/c/be98737a4faa
  - [net-next,v0,13/14] net/mlx5e: Allocate per-channel stats dynamically at first usage
    https://git.kernel.org/netdev/net-next/c/fa691d0c9c08
  - [net-next,v0,14/14] net/mlx5e: Take packet_merge params directly from the RX res struct
    https://git.kernel.org/netdev/net-next/c/1f08917ab929

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


