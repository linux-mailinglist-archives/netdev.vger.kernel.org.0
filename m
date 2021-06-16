Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D888E3AA4FC
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 22:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhFPUMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 16:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233202AbhFPUMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 16:12:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 99349613BF;
        Wed, 16 Jun 2021 20:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623874210;
        bh=dp1JbF5spmd4DWGu0qehInvE6vR88NpAL5KG99Ph82o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n25OACMJWShh0D1YSfiUlL+KnG/zUp/GF5BvH3WjPpi/0+nMJuCilxrfdo3BvbKc8
         UXqIdBnPS2ok4MFNmImaUabx61R3491zoCViyqPiA3n7NmizILmMYhu8JeSa+WKD17
         EcqweF9p+lwt1KztgfL/YfX8Vn5APIvRS+nisdru2hTPuYSvqKyH1asbGVjhQybzSv
         d60PS7uYUptXJmZF1OdmXo1skUAzoWFXNBKBbQ6CuWYsLZL/lxHrqBitO6nnPZdPiI
         J34Tqs5Fsa+hYXzyf6Nw8cF81EADB2I4mLcyX0saSwb3QnYf/T0xSzik9i+907N63S
         H332WeoOOR76g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 93D5960C29;
        Wed, 16 Jun 2021 20:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] net/smc: Add SMC statistic support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387421060.22643.2650018672021576779.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 20:10:10 +0000
References: <20210616145258.2381446-1-kgraul@linux.ibm.com>
In-Reply-To: <20210616145258.2381446-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hca@linux.ibm.com,
        raspl@linux.ibm.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, guvenc@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 16 Jun 2021 16:52:54 +0200 you wrote:
> Please apply the following patch series for smc to netdev's net-next tree.
> 
> This v2 is a resend of the code contained in v1 but with an updated
> cover letter to describe why we have chosen to use the generic netlink
> mechanism to access the smc protocol's statistic data.
> 
> The patchset adds statistic support to the SMC protocol. Per-cpu
> variables are used to collect the statistic information for better
> performance and for reducing concurrency pitfalls. The code that is
> collecting statistic data is implemented in macros to increase code
> reuse and readability.
> The generic netlink mechanism in SMC is extended to provide the
> collected statistics to userspace.
> Network namespace awareness is also part of the statistics
> implementation.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] net/smc: Add SMC statistics support
    https://git.kernel.org/netdev/net-next/c/e0e4b8fa5338
  - [net-next,v2,2/4] net/smc: Add netlink support for SMC statistics
    https://git.kernel.org/netdev/net-next/c/8c40602b4be1
  - [net-next,v2,3/4] net/smc: Add netlink support for SMC fallback statistics
    https://git.kernel.org/netdev/net-next/c/f0dd7bf5e330
  - [net-next,v2,4/4] net/smc: Make SMC statistics network namespace aware
    https://git.kernel.org/netdev/net-next/c/194730a9beb5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


