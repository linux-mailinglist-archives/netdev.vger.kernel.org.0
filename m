Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3256E455B1D
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344437AbhKRMDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:03:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344416AbhKRMDL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 07:03:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1FAE8613AD;
        Thu, 18 Nov 2021 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637236811;
        bh=PQEtMFUPqFMRomvHCb/cxioO1uKugc1aZs4VEA+yAu0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U0SYnzzTurbild6zCc0ukDXo3LI/qVKOJCZ3qmRnaYR7GkEqMURs1ng3IhJPhssnZ
         vkDbfxn8HtdvhpFM0/YT1TEq/h9XIjF0PwOeSPV86D0o/49MBgEYY1JdQZDwwo1MOF
         bFfeYmktYdGXttuXrWRfWz4Y/NS9aOs/JdOxRtJdMDgV7ERWiqmocuoJqYcmReaWPh
         1R+bVxbWIL4pbVFeZ35hD4OVG0a4czmPOAILzZrFWwvMGVdwWbKQw1+mUwjA8pzN4/
         gPeRDm1yjtEKJyr0Y46+FC7hm/m9JB6wTE4bKC7NlVF475EYUsS70KvZu3lggnbyvX
         IA6JgJglOxg4g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 153A060A94;
        Thu, 18 Nov 2021 12:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] 10GbE Intel Wired LAN Driver
 Updates 2021-11-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723681108.21585.1111965067905985622.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 12:00:11 +0000
References: <20211118005832.245978-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211118005832.245978-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 17 Nov 2021 16:58:27 -0800 you wrote:
> Radoslaw Tyl says:
> 
> The change is a consequence of errors reported by the ixgbevf driver
> while starting several virtual guests at the same time on ESX host.
> During this, VF was not able to communicate correctly with the PF,
> as a result reported "PF still in reset state. Is the PF interface up?"
> and then goes to locked state. The only thing left was to reload
> the VF driver on the guest OS.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ixgbevf: Rename MSGTYPE to SUCCESS and FAILURE
    https://git.kernel.org/netdev/net-next/c/0edbecd57057
  - [net-next,2/5] ixgbevf: Improve error handling in mailbox
    https://git.kernel.org/netdev/net-next/c/887a32031a8a
  - [net-next,3/5] ixgbevf: Add legacy suffix to old API mailbox functions
    https://git.kernel.org/netdev/net-next/c/9c9463c29d1b
  - [net-next,4/5] ixgbevf: Mailbox improvements
    https://git.kernel.org/netdev/net-next/c/c869259881a3
  - [net-next,5/5] ixgbevf: Add support for new mailbox communication between PF and VF
    https://git.kernel.org/netdev/net-next/c/339f28964147

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


