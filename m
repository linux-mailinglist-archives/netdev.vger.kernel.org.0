Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10538376D2C
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 01:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhEGXLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 19:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhEGXLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 19:11:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 66965613C8;
        Fri,  7 May 2021 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620429011;
        bh=eeRbFAxY8+Lr0x3OBZAkV+mO/VChjxYBWqhJVDTMI64=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kEYhMfA/hvVzqr/9wyBiP2KDGnriDXBtz3R8m1Na2GQQ4y5xqKbcLfWBmQhNtDqw1
         YQU/74GLtSxdENXwI+dsiYctl9rpMXw3Ox/WEp3eSRpBJwzxjvm6lIgIch6s6fvdEJ
         ZC9ahqA1yDS5ZsXMAy6Tvcpgm3iT5PzSCQ4tnzznj7JNyJNek2ssiJtiHclck+rd4e
         2lOaHnYI1ev5VOvxH7PWHOYaJiKNJ+GoVS2u28gb/QDyPBwzR3Pe4GT9A/sI+opX6a
         rGUbLpk4zgKWB+ZCJFh/82hxIV6o9ZE4V4RHqFy4sy6Ao08mueFQHIznNsVC3TMwPv
         kbRYQ5CzCRAVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 572FD60A0C;
        Fri,  7 May 2021 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates
 2021-05-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162042901135.19618.1179897448859246653.git-patchwork-notify@kernel.org>
Date:   Fri, 07 May 2021 23:10:11 +0000
References: <20210507164151.2878147-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210507164151.2878147-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri,  7 May 2021 09:41:46 -0700 you wrote:
> This series contains updates to i40e driver only.
> 
> Magnus fixes XDP by adding and correcting checks that were caused by a
> previous commit which introduced a new variable but did not account for
> it in all paths.
> 
> Yunjian Wang adds a return in an error path to prevent reading a freed
> pointer.
> 
> [...]

Here is the summary with links:
  - [net,1/5] i40e: fix broken XDP support
    https://git.kernel.org/netdev/net/c/ae4393dfd472
  - [net,2/5] i40e: Fix use-after-free in i40e_client_subtask()
    https://git.kernel.org/netdev/net/c/38318f23a7ef
  - [net,3/5] i40e: fix the restart auto-negotiation after FEC modified
    https://git.kernel.org/netdev/net/c/61343e6da781
  - [net,4/5] i40e: Fix PHY type identifiers for 2.5G and 5G adapters
    https://git.kernel.org/netdev/net/c/15395ec4685b
  - [net,5/5] i40e: Remove LLDP frame filters
    https://git.kernel.org/netdev/net/c/8085a36db71f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


