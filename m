Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01184650AE
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 16:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244738AbhLAPDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 10:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245597AbhLAPDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 10:03:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F35C061748
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 07:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 87BE9CE1E66
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 15:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B771AC53FCD;
        Wed,  1 Dec 2021 15:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638370816;
        bh=lwpABV+8ivoPJCm3yDJlFE2a7GhvRSbLCJnuu9L3VgQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oIr+1vFNrDaKfuh6s1f/ajnSipXdDAyXwoRg0Y/MXqwmesEytqRdPsVF07p47RT53
         dDcHtZGOxs9xkVxk4yC6T7MLRE/+8WCJjUzo3GmuY++31H0BDxqh4b87kLxuxJgFnQ
         cYTpiBn6e3ONW18zL5WCTXkVySCaP4hdr3KpxYscPLb8s0xhPqcI+iFVVBuLki/m9f
         gHfkg9hjmaU6BKG+GYGURfAcmMjhfwao4b2C4qSsnRNJrbSdYVBew+0Y2rpL0iHVQw
         PA7i19iXbpLxJI58ggUhoKOy9P8JjyLcAXLV1Yh1b2OKsY0ZvV7MAVoBVgUzQLogFq
         0eU7xm0fd6Zfg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A2AD4609EF;
        Wed,  1 Dec 2021 15:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/10][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-11-30
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163837081666.15182.1986279159744817517.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Dec 2021 15:00:16 +0000
References: <20211130212004.198898-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211130212004.198898-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 30 Nov 2021 13:19:54 -0800 you wrote:
> This series contains updates to iavf driver only.
> 
> Patryk adds a debug message when MTU is changed.
> 
> Grzegorz adds messaging when transitioning in and out of multicast
> promiscuous mode.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/10] iavf: Add change MTU message
    https://git.kernel.org/netdev/net-next/c/aeb5d11fd1ef
  - [net-next,v2,02/10] iavf: Log info when VF is entering and leaving Allmulti mode
    https://git.kernel.org/netdev/net-next/c/f1db020ba4ef
  - [net-next,v2,03/10] iavf: return errno code instead of status code
    https://git.kernel.org/netdev/net-next/c/9f4651ea3e07
  - [net-next,v2,04/10] iavf: Add trace while removing device
    https://git.kernel.org/netdev/net-next/c/bdb9e5c7aec7
  - [net-next,v2,05/10] iavf: Enable setting RSS hash key
    https://git.kernel.org/netdev/net-next/c/b231b59a2f96
  - [net-next,v2,06/10] iavf: Refactor iavf_mac_filter struct memory usage
    https://git.kernel.org/netdev/net-next/c/4d0dbd9678ad
  - [net-next,v2,07/10] iavf: Fix static code analysis warning
    https://git.kernel.org/netdev/net-next/c/349181b7b863
  - [net-next,v2,08/10] iavf: Refactor text of informational message
    https://git.kernel.org/netdev/net-next/c/fbe66f57d371
  - [net-next,v2,09/10] iavf: Refactor string format to avoid static analysis warnings
    https://git.kernel.org/netdev/net-next/c/c2fbcc94d511
  - [net-next,v2,10/10] iavf: Fix displaying queue statistics shown by ethtool
    https://git.kernel.org/netdev/net-next/c/64430f70ba6f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


