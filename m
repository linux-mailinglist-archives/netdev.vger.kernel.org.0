Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225FF4619E0
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378715AbhK2Om0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379018AbhK2OkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDD7C08ED7C;
        Mon, 29 Nov 2021 05:10:13 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34A24B81135;
        Mon, 29 Nov 2021 13:10:12 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id E384360E92;
        Mon, 29 Nov 2021 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638191410;
        bh=7Hj74nheowp4ciRWkGklKqvWkQVJ89Ooc5h5UfcuYBM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fRHoLCNswiFv59k1AW5iqrC3x+5k0MKz4B585EtViCRV/mEllIR1cWh6j4ahYv/Wo
         Hj/E7WRHfrW/WNiuVoJ6loTCwArEJBUJZl4qfYg+0CDbUtuGUE8aWq0adAiwzs5muR
         YSBF+YT6cGSnHpW3kQS3qrlcwYyJ99W063zbohFT7Q+wbbaIqlfl8XM/JzK5ZhTaCs
         DW5x6XAhB9xC8C4HNyUiDBCXyDIpMxnbL0SOn19Ptaoyitd8hgyE2c6IztdGOgl7oN
         h3RVpFjNZdnPkr4qogjTB8olk5ILnD6DBiKodppcviBBydbf71SOuSKZG8onWZno4W
         iadGbENRFCxGA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DCE1860A4D;
        Mon, 29 Nov 2021 13:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] devlink: Remove misleading internal_flags from
 health reporter dump
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819141090.10588.4054297154663803863.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 13:10:10 +0000
References: <f85ab0a57f0206e9452c32ab28dc81e1b2aae3d4.1638101585.git.leonro@nvidia.com>
In-Reply-To: <f85ab0a57f0206e9452c32ab28dc81e1b2aae3d4.1638101585.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        ayal@mellanox.com, jiri@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, saeedm@mellanox.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 28 Nov 2021 14:14:46 +0200 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET command doesn't have .doit callback
> and has no use in internal_flags at all. Remove this misleading assignment.
> 
> Fixes: e44ef4e4516c ("devlink: Hang reporter's dump method on a dumpit cb")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v1] devlink: Remove misleading internal_flags from health reporter dump
    https://git.kernel.org/netdev/net-next/c/e9538f8270db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


