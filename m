Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12742B89BE
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgKSBuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:50:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgKSBuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 20:50:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605750605;
        bh=/L7LZ1eYlifUcEbUW7b/R6FRtA/yP2ZaCNWmB5MUD9M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZwI5G/fBz68ThsdQD3Skibt3oVMjQVUF4jhrFtBXSqy8nc5g1KGJOUNMXqDfwb0l8
         haTIU93THbTC6J2Wl4/AnyJkIdtUAwy/6Y0LUCwxtqNhc0Iu9udVdSCmy9DSyRVjts
         Kfao3FPcGa1jB4kX+jo6Jh7hqux49pZS+3oO2+0I=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx4_core: Fix init_hca fields offset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160575060511.14123.3846881104818682846.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Nov 2020 01:50:05 +0000
References: <20201118081922.553-1-tariqt@nvidia.com>
In-Reply-To: <20201118081922.553-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        moshe@nvidia.com, ttoukan.linux@gmail.com, ayal@nvidia.com,
        eranbe@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 18 Nov 2020 10:19:22 +0200 you wrote:
> From: Aya Levin <ayal@nvidia.com>
> 
> Slave function read the following capabilities from the wrong offset:
> 1. log_mc_entry_sz
> 2. fs_log_entry_sz
> 3. log_mc_hash_sz
> 
> [...]

Here is the summary with links:
  - [net] net/mlx4_core: Fix init_hca fields offset
    https://git.kernel.org/netdev/net/c/6d9c8d15af0e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


