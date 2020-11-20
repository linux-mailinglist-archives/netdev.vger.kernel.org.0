Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3355B2BB4DC
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730714AbgKTTKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 14:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729108AbgKTTKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 14:10:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605899406;
        bh=aV21fefekKqyHcWGuRf5MR1pSMfH3djPgHlJ8QrJHaI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jr4FvV+zu3kQBWypshMsWNlEkPd7fiJopmM7DWKmJxCCzMYakMJCvRf9FbM9A8JHN
         Jeh2uqzAGDhj2kPzK5IqnHrQkh9iRr727Mqjtduipbrf6UR3YJN1JP9k+GyRq0Gh+x
         K0hURys4ETBkNDXB2Ezee2aXmbOlDYJxlx1XlLUo=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx4_en: Remove unused performance counters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160589940686.22082.1626234227790460572.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Nov 2020 19:10:06 +0000
References: <20201118103427.4314-1-tariqt@nvidia.com>
In-Reply-To: <20201118103427.4314-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        moshe@nvidia.com, ttoukan.linux@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 18 Nov 2020 12:34:27 +0200 you wrote:
> Performance analysis counters are maintained under the MLX4_EN_PERF_STAT
> definition, which is never set.
> Clean them up, with all related structures and logic.
> 
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx4_en: Remove unused performance counters
    https://git.kernel.org/netdev/net-next/c/1a0058cf0c8f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


