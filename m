Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0115B44C330
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhKJOnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:43:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232266AbhKJOm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 09:42:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 773806124D;
        Wed, 10 Nov 2021 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636555208;
        bh=+5kIuX5BaNGMDp4ytDWsd3Am94GlKQUxJ9QwAGV4R2U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nsw35ltWMC2vvK4yGyCtUf0NICeZJ7neko6efyJPM7ZI5NJK/Zu8gPAK2nGYw07he
         oOGDIxsy6OoIIVn9ds+l/26tzFW/UT1O3T0tHauAfIQiQAKFm/tVygq0jpjvXhB93g
         h4X34vs7XBFVu81XydCuSngKDfoYjiMPNkHuaus9bOp7rP3e+wfPPFyDKGqnSGdmWY
         WH0IJDW48IvXnb4s3EfxU6x5eMx9Dzj5T9paa0MvQg36wLyVzbkS0qZzUIU1rCpCAw
         PNBDhaWEazE404xMRuO8WZC3HXI9n0KTQEnCkmXzYt8cwnT7Ap0bYa0YjedhKkKzO3
         y1kgPJrfiLm+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5E98E60BE1;
        Wed, 10 Nov 2021 14:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: net: test_vxlan_under_vrf: fix HV connectivity
 test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163655520838.19242.13394995592460073330.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 14:40:08 +0000
References: <20211105155529.105545-1-andrea.righi@canonical.com>
In-Reply-To: <20211105155529.105545-1-andrea.righi@canonical.com>
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     davem@davemloft.net, abauvin@scaleway.com, kuba@kernel.org,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  5 Nov 2021 16:55:29 +0100 you wrote:
> It looks like test_vxlan_under_vrf.sh is always failing to verify the
> connectivity test during the ping between the two simulated VMs.
> 
> This is due to the fact that veth-hv in each VM should have a distinct
> MAC address.
> 
> Fix by setting a unique MAC address on each simulated VM interface.
> 
> [...]

Here is the summary with links:
  - selftests: net: test_vxlan_under_vrf: fix HV connectivity test
    https://git.kernel.org/netdev/net/c/e7e4785fa30f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


