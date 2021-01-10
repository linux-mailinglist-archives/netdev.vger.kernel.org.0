Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92DB2F047F
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 01:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbhAJAKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 19:10:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbhAJAKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 19:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A22C82388A;
        Sun, 10 Jan 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610237408;
        bh=rRGUA48gVjP0LhsXnNN0E1CWztFKmH6VxlSOlbqYgUU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AhFP9fODJuIHj/0nh16tKFvANxPdqxKFBITwdsSdPTQAazIvMQCVGTWUIxH/xrwTK
         oXsB6p1fjXBkhqqkpCuBbuXngPHt3q8Hw9QhLk0vjFMzE/1IV7WqStVxEPw6wU3iqf
         0xJvLzgBhJ0kT6g9HOcMtOUA0nrnqpvEgkYruDBwFVELpA+dnCGySru94CsaKxl4m1
         5H5qv7Zg2AcfET34jCKZ2kS5VAOoTg1MqWrVaK9H+rdnYvEOi+2kjzYsJPw9jk3WXe
         v7hc7+mJNptdw/v98xDwQDBqr3GWclOLcPOigFkEZxlW2l7Jppr7dqddhtXaKoW1Jx
         fxf93At5+StrQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 91AE760188;
        Sun, 10 Jan 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net-gro: GRO_DROP deprecation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161023740859.12553.10714223338943728983.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Jan 2021 00:10:08 +0000
References: <20210108113903.3779510-1-eric.dumazet@gmail.com>
In-Reply-To: <20210108113903.3779510-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, jesse.brandeburg@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  8 Jan 2021 03:39:01 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> GRO_DROP has no practical use and can be removed,
> once ice driver is cleaned up.
> 
> This removes one useless conditionel test in napi_gro_frags()
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] ice: drop dead code in ice_receive_skb()
    https://git.kernel.org/netdev/net-next/c/f73fc40327c0
  - [net-next,2/2] net-gro: remove GRO_DROP
    https://git.kernel.org/netdev/net-next/c/1d11fa696733

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


