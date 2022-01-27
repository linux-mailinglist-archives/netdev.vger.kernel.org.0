Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A76A49D8EE
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 04:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235620AbiA0DKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 22:10:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52540 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbiA0DKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 22:10:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6290B820FC;
        Thu, 27 Jan 2022 03:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 629C7C340ED;
        Thu, 27 Jan 2022 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643253010;
        bh=v/dTHMX988OcbB6E6Rua80u2dmTmT+ss0IUEzszMnfY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JhSZQ4I9G5Sj74jH6d+ikDHdqMKk/jqkDtc2N0pJQu3z2io0WyrDRx0ZACvysfZoY
         5gjb+Hcj1HfrcSxvqsPiWvJr6f8ul9RFwLRocR5fZymv7NZGBAwyhsNPulm6bVNSNJ
         yWkW1FQjR4GYpZyZMXXGv7ZExMuColn0RqIWlaUaE/cHMtEdgIg8xF53toJ8VZbaOc
         hkuY5BsH7Uxg3xOyZZ2tCYSs4X6vYMdHBZugQh5wOLtLog3pih5a6KGtY3vNT+YMLp
         dbrMC5mMpN+hNrCT4+JVcJxY4AZhWWKuQFkwekrc/3xpMaWXj+CdBZylWF+cpysCCa
         5QAlks2v1zXzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B8CCF6079F;
        Thu, 27 Jan 2022 03:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/2] pid: Introduce helper task_is_in_root_ns()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164325301030.26280.5565890231201781170.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 03:10:10 +0000
References: <20220126050427.605628-1-leo.yan@linaro.org>
In-Reply-To: <20220126050427.605628-1-leo.yan@linaro.org>
To:     Leo Yan <leo.yan@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, suzuki.poulose@arm.com,
        leon@kernel.org, bsingharora@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 26 Jan 2022 13:04:25 +0800 you wrote:
> This patch series introduces a helper function task_is_in_init_pid_ns()
> to replace open code.  The two patches are extracted from the original
> series [1] for network subsystem.
> 
> As a plan, we can firstly land this patch set into kernel 5.18; there
> have 5 patches are left out from original series [1], as a next step,
> I will resend them for appropriate linux-next merging.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] pid: Introduce helper task_is_in_init_pid_ns()
    https://git.kernel.org/netdev/net/c/d7e4f8545b49
  - [net,v3,2/2] connector/cn_proc: Use task_is_in_init_pid_ns()
    https://git.kernel.org/netdev/net/c/42c66d167564

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


