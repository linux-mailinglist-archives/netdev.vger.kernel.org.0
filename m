Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548E3379956
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 23:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhEJVlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 17:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231434AbhEJVlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 17:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C80EB6146E;
        Mon, 10 May 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620682809;
        bh=7w6LtCA14rkOX1xwVHQIOynkbcCsleSsShxFVokVaKE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fy3jI6Vnl+/VFoHIssrXYoaf5it8BtLEgYEQJonmn8QNYWeGmUKzxAqClVMzmc//R
         edCH+4jaVWeYOWLb9uj1yUPkCgI1YZnkk0Ud8xft0D+TN2M8ShubQHhNUP0ErEsw+6
         6eIKsFb41SJfnz214CmoLqPGMLjLfQaNjlBMkIZeafQsGncI1JChsrM8EKG0WmTVBU
         k2ALSoudSGJ/cC0Vzx/otWCbBqrBzUNtfQq4KdN2qXAA4bkAPhrEqW0gSdeeYHljzu
         nJ8VmDMwyAL8aPWlsB97Pi9sSlZKZWsWQZw+WPpg1QrzXaYPuImj1i42QhHjQkAz+L
         h0LWZV0t9109A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B981C609AC;
        Mon, 10 May 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: dsa: fix error code getting shifted with 4 in
 dsa_slave_get_sset_count
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068280975.31911.13664351402322744930.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 21:40:09 +0000
References: <20210509193338.451174-1-olteanv@gmail.com>
In-Reply-To: <20210509193338.451174-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        dan.carpenter@oracle.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  9 May 2021 22:33:38 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> DSA implements a bunch of 'standardized' ethtool statistics counters,
> namely tx_packets, tx_bytes, rx_packets, rx_bytes. So whatever the
> hardware driver returns in .get_sset_count(), we need to add 4 to that.
> 
> That is ok, except that .get_sset_count() can return a negative error
> code, for example:
> 
> [...]

Here is the summary with links:
  - [v2,net] net: dsa: fix error code getting shifted with 4 in dsa_slave_get_sset_count
    https://git.kernel.org/netdev/net/c/b94cbc909f1d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


