Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FB2362C63
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 02:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbhDQAUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 20:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235010AbhDQAUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 20:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DD2946115B;
        Sat, 17 Apr 2021 00:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618618813;
        bh=Q69n5b50QGBfz7wkoWYqyolXH9DGqJK9VR+VvdeXtss=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ahfFcyWDXStmVjGpti1yEv/6xP7N7hw9OL8NCiFpgL6WBkMjW1OdeThEv/RU8DPdf
         wiBj3DEV5OMpYLJlZrS6XeEIzTTnygdmrn5F9P2nf8xs08hNTLfyOfqqNlb1jwURC4
         v3/5Soo5khZ+Lu+1G4qBTqe0iQ0nXR1lBbcMPmE9c2hkrElgjgplyKrn/kakhS/qfa
         /AYEpw3JwfiZXVyikjl3YGazblMsTnnflRRFfk5hdDnrAYiDqoLjqHnJrshCkK0wsJ
         hD8fi/WKroPTZqgS6y74Xn2kTPLUHWTh6eTOe49Zfsmlisf5awSCc1vc3iDx6kUPFk
         Q0nsPl8ni0y0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD65560A15;
        Sat, 17 Apr 2021 00:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-04-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861881383.3813.17257033588191776171.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Apr 2021 00:20:13 +0000
References: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Apr 2021 13:44:54 -0700 you wrote:
> This series contains updates to igb and igc drivers.
> 
> Ederson adjusts Tx buffer distributions in Qav mode to improve
> TSN-aware traffic for igb. He also enable PPS support and auxiliary PHC
> functions for igc.
> 
> Grzegorz checks that the MTA register was properly written and
> retries if not for igb.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] igb: Redistribute memory for transmit packet buffers when in Qav mode
    https://git.kernel.org/netdev/net-next/c/26b67f5a1e06
  - [net-next,2/6] igb: Add double-check MTA_REGISTER for i210 and i211
    https://git.kernel.org/netdev/net-next/c/1d3cb90cb010
  - [net-next,3/6] igc: Enable internal i225 PPS
    https://git.kernel.org/netdev/net-next/c/64433e5bf40a
  - [net-next,4/6] igc: enable auxiliary PHC functions for the i225
    https://git.kernel.org/netdev/net-next/c/87938851b6ef
  - [net-next,5/6] igc: Fix overwrites return value
    https://git.kernel.org/netdev/net-next/c/b3d4f405620a
  - [net-next,6/6] igc: Expose LPI counters
    https://git.kernel.org/netdev/net-next/c/1feaf60ff260

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


