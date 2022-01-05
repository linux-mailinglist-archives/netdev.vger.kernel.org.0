Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D494855B0
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237135AbiAEPUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:20:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34644 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241324AbiAEPUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:20:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 177FAB81C14
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 15:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB466C36AE9;
        Wed,  5 Jan 2022 15:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641396010;
        bh=Fj3pWyby23D8Jg2EV8Xh7S5qtpFqzTcVCvynUesrE1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mF1WXTPQ5aXy7j0zX3Sln6/X9bl24PE600Vt1Gc7vsKOKFJs6xqz7SgPaNYNFM9DH
         fe3W4+ginunkirtu6Lkg1wJvf9dNVRejIxghks1qPu7eblcPzz9ySEojmojRfo5RJV
         wHM2DwjufWb7PJSw6AIlzjubm5V+uSm7c2psh74QrhWJh+aW/XdKHQDs4Pz0Xbo1Yw
         2C4iyzrRPCLdv6e+CQbRiM1kqTUnYYQihAf5TqLwn7973apVhgoqtq6hfkUDh+CZmg
         3tUJf8ZhkcvbaN+M0xWRBOdcoDS8iJjxgS9G5teoBQOHg2HtvuQoEYaDaRQWuh7WMT
         kdGHFn7WT8EfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D9B5F7940B;
        Wed,  5 Jan 2022 15:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates
 2022-01-04
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164139601057.20548.10950305760112978069.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 15:20:10 +0000
References: <20220104223842.2325297-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220104223842.2325297-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue,  4 Jan 2022 14:38:37 -0800 you wrote:
> This series contains updates to i40e and iavf drivers.
> 
> Mateusz adjusts displaying of failed VF MAC message when the failure is
> expected as well as modifying an NVM info message to not confuse the user
> for i40e.
> 
> Di Zhu fixes a use-after-free issue MAC filters for i40e.
> 
> [...]

Here is the summary with links:
  - [net,1/5] i40e: Fix to not show opcode msg on unsuccessful VF MAC change
    https://git.kernel.org/netdev/net/c/01cbf50877e6
  - [net,2/5] i40e: fix use-after-free in i40e_sync_filters_subtask()
    https://git.kernel.org/netdev/net/c/3116f59c12bd
  - [net,3/5] i40e: Fix for displaying message regarding NVM version
    https://git.kernel.org/netdev/net/c/40feded8a247
  - [net,4/5] i40e: Fix incorrect netdev's real number of RX/TX queues
    https://git.kernel.org/netdev/net/c/e738451d78b2
  - [net,5/5] iavf: Fix limit of total number of queues to active queues of VF
    https://git.kernel.org/netdev/net/c/b712941c8085

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


