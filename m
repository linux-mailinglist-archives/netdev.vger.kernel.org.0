Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF83301386
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 07:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbhAWGLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 01:11:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbhAWGLQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 01:11:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DBCAF23B08;
        Sat, 23 Jan 2021 06:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611382223;
        bh=IJGCJIOiy+Vq3ntuYjU9PBUfLior1uJyFKQOK091cbA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CIjr2fQ1tFM268LUVLKssZeF5A2+QSvw86St3IqRjMY/93wg06LWzJi4vsmq+BlPn
         xSPnpD/aZVRxf4n5A1cQoITmAdT1aWuQsevxIXb2jg8mUw4zplIgRkJLpeXZa23GeH
         A0rav94kNoWBEUa8sptq4xnvx7Oi3nIAyUYo1mayZMrLbVY5PkjGwoDXMDSv/zKyXq
         2tEHldN97d8cF8nJuo8rT1BNvqz7mX2ltz8AaBn0aH4jqFriF0c6aUaz1UKA8xmx5D
         D4eF6Rtjpf6kECSYl4OcOW1CgUYdPyMkMaIiZNUsvJXa8j9SXGFt2LbJDy/TAnFtE+
         diR7dEnh1YLoA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BC6C7652E4;
        Sat, 23 Jan 2021 06:10:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] mlxsw: Expose number of physical ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161138222376.25900.4792043766515391595.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 06:10:23 +0000
References: <20210121131024.2656154-1-idosch@idosch.org>
In-Reply-To: <20210121131024.2656154-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 21 Jan 2021 15:10:22 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The switch ASIC has a limited capacity of physical ports that it can
> support. While each system is brought up with a different number of
> ports, this number can be increased via splitting up to the ASIC's
> limit.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] mlxsw: Register physical ports as a devlink resource
    https://git.kernel.org/netdev/net-next/c/321f7ab0d458
  - [net-next,v2,2/2] selftests: mlxsw: Add a scale test for physical ports
    https://git.kernel.org/netdev/net-next/c/5154b1b826d9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


