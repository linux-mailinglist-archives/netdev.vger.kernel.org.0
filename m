Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3752035E8B2
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348569AbhDMWAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347036AbhDMWAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 18:00:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ECCC3613B6;
        Tue, 13 Apr 2021 22:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618351212;
        bh=P50trFH6sCceVOyT1M7EE2vhfO8i6ZC674ilaKHmcgM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EOE7FvFpD7qvhtsRQHAztz8RvQK6SFfmoMV5zJEuGCrPZvethnExO3vTtwr4bDCUi
         c9S8keb2NxKFkf5K4mAZ/YBB5PIzmiagQzGbW9RE+VbSSLbgXrA20LtdgMCn5gnbtI
         jhz0XmaoqdgR8MWfzvEGcci3vEymWKmfJI0ORcS5rCbZZDyicFIQENlfaEKV8GqTxJ
         AD4ZOPXr8mwuKktgAv02BU91s3HTQnC/iaJB9r4246DLUmrdtpigW4RHCI8zhCo+bJ
         KWdJ/IkT9QECtffFK0hjvofxRV/3a1aViX3kG0f8F5ZiZwA/ekg/tn43DMrteTu+C9
         /pNCVqwckoLAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E6D2A60CCF;
        Tue, 13 Apr 2021 22:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] ibmvnic: queue reset work in system_long_wq
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835121194.27588.11209178114900858574.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 22:00:11 +0000
References: <20210413193339.11050-1-lijunp213@gmail.com>
In-Reply-To: <20210413193339.11050-1-lijunp213@gmail.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org, nathanl@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 13 Apr 2021 14:33:39 -0500 you wrote:
> The reset process for ibmvnic commonly takes multiple seconds, clearly
> making it inappropriate for schedule_work/system_wq. The reason to make
> this change is that ibmvnic's use of the default system-wide workqueue
> for a relatively long-running work item can negatively affect other
> workqueue users. So, queue the relatively slow reset job to the
> system_long_wq.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] ibmvnic: queue reset work in system_long_wq
    https://git.kernel.org/netdev/net-next/c/870e04ae45ea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


