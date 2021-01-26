Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF52D303533
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387886AbhAZFhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:37:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730795AbhAZCUw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 21:20:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8707622ADF;
        Tue, 26 Jan 2021 02:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611627609;
        bh=pV+6/LpM7O4L57wBQTFhxpMKCKSBS488ybzH5ZYCaLQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FNk1TlvH4Z8I27FPgQKS39F6Y9r6m4Wl7OYg1DsvsXw5VqPW9ZgPdlba/nOrqklEe
         0vUS4Oj3LMwHNNTpyY4S0MHzq0EfcbgJBCepWkIn0GqQAhOFtb4cmO8mrZ0vkGTdhU
         N/jLSd9g6mWJuopsWfYS5rtcv8eyuO0IOQFuEdm7H6bs1+PeaNsPkEjvnHtv9xZy5T
         hhS7CwN2nVjB6YYZzuLLfeVuujvZuWZK7l1bo1ySrN/03iufe82Yh6t6rlPlPYAZKF
         wiGsBkAEeBdFsRcXkLzjGaxoUElNNPczIvnFv1kflpW3kkg3AY2rb6V0cB3Ze45O1N
         JlZjrzGdogHmg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 775D761FBF;
        Tue, 26 Jan 2021 02:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-af: Support ESP/AH RSS hashing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161162760948.14358.3890752127422248287.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jan 2021 02:20:09 +0000
References: <1611378552-13288-1-git-send-email-sundeep.lkml@gmail.com>
In-Reply-To: <1611378552-13288-1-git-send-email-sundeep.lkml@gmail.com>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        gakula@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        sgoutham@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 23 Jan 2021 10:39:12 +0530 you wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> Support SPI and sequence number fields of
> ESP/AH header to be hashed for RSS. By default
> ESP/AH fields are not considered for RSS and
> needs to be set explicitly as below:
> ethtool -U eth0 rx-flow-hash esp4 sdfn
> or
> ethtool -U eth0 rx-flow-hash ah4 sdfn
> or
> ethtool -U eth0 rx-flow-hash esp6 sdfn
> or
> ethtool -U eth0 rx-flow-hash ah6 sdfn
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-af: Support ESP/AH RSS hashing
    https://git.kernel.org/netdev/net-next/c/b9b7421a01d8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


