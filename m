Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2CD426F01
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 18:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbhJHQcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 12:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230287AbhJHQcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 12:32:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 324E260FDC;
        Fri,  8 Oct 2021 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633710609;
        bh=LiQfhiRN34Q8sJiPuk9zpALVex9Gt+ZGdZM30Hn43+w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BPUn4eq56q3MvMVsn7IMASjhf9nuXsAVw7P0EKEAm9rOzjyvIThgMIWorgYOlCZY5
         JSkRojAJk3fH2uoAP3YNkM+UtsOd+jBopOoVOIDznMC5A/YIaEg+wOPrv2WI7pVkhI
         Kf2G/9HNAdxYzbnm4+BZJo3p4FgZQXttdl2GAnwCDT5I+dAUolAOXPYVU72KHlHFBr
         2WRfwK9waaz1vgFe5oYMmbN2pHB4gYN+N+8ofAqn6LNOvcWZ2Cfmh1HPRtOToPxckW
         pouoFOxJU3BWbfU7t14Q0KN5UrFmWOI2kNVLw3pjNuDwP5sz397NMeVoHG/fiykK88
         iZ/os/3B+1gOg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2AF3C60985;
        Fri,  8 Oct 2021 16:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: introduce a function to check if a netdev
 name is in use
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163371060917.30754.1813039576071539612.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 16:30:09 +0000
References: <20211007161652.374597-1-atenart@kernel.org>
In-Reply-To: <20211007161652.374597-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        juri.lelli@redhat.com, mhocko@suse.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Oct 2021 18:16:49 +0200 you wrote:
> Hello,
> 
> This was initially part of an RFC series[1] but has value on its own;
> hence the standalone report. (It will also help in not having a series
> too large).
> 
> From patch 1:
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: introduce a function to check if a netdev name is in use
    https://git.kernel.org/netdev/net-next/c/75ea27d0d622
  - [net-next,2/3] bonding: use the correct function to check for netdev name collision
    https://git.kernel.org/netdev/net-next/c/caa9b35fadff
  - [net-next,3/3] ppp: use the correct function to check if a netdev name is in use
    https://git.kernel.org/netdev/net-next/c/d03eb9787d3a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


