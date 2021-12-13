Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD2E472F92
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 15:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239656AbhLMOkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 09:40:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45146 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239631AbhLMOkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 09:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58A53B8110B
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F66AC34605;
        Mon, 13 Dec 2021 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639406410;
        bh=f7qYwd0VXEAVV9JqdFm3mJ6PUIkNAuymJn0SoacA0E0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AC0JXAYITSv+Ha0wDIrSP9HWv0SWsR26HzY58pLKS92nypx0OQC+SDiX0w4q3LSde
         gQequdpyzK8Q+WVpkpCT/dWnIJSQXZIGshZhFnPbHiFbPXqUEX5+4IHDC59St5pcAp
         HxW6Nus2mnw43sTYu9BdjYgP/2QS5gpZbvXJfwQCQNqh+iPyxSP4E07Eix3T/n7wZI
         uYB0scXEym3/AmPwPHEtGct7tmVw56BylQXCVi++goYaqOSsQlVKciBMITV7Z3AeNn
         kco/ws2DH1w/WUOQ2CQMXYb8Hbqe1tfQZpuf3CDborz303gXVeTTCn0hTHM9KXXpbS
         yZhFqCB6ErZbQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F38AA60A00;
        Mon, 13 Dec 2021 14:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests/net: expand gro with two machine test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940640999.17097.7896474860603607781.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 14:40:09 +0000
References: <20211211200457.2243386-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20211211200457.2243386-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 11 Dec 2021 15:04:57 -0500 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> The test is currently run on a single host with private addresses,
> either over veth or by setting a nic in loopback mode with macvlan.
> 
> Support running between two real devices. Allow overriding addresses.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests/net: expand gro with two machine test
    https://git.kernel.org/netdev/net-next/c/87f7282e76be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


