Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8D93AA428
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbhFPTWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232626AbhFPTWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4B55461246;
        Wed, 16 Jun 2021 19:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623871204;
        bh=ZhJ6tGBWX3G9f9vOG1ff5pPXMgjnmdRUCgE8GT436Lg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aeWm7W/BAfR8MRrkt8J/uBusvfNM9U/Rgr4lqUgIAqUDaMVHLi+tWnLhtulkh+pM3
         gZ8RfNma2fnCGGHYP6YJ30LOCbxDChYSmH94rjq2u9o2YLUTpmZBWgbwN/3+pihzCF
         +K5pQX4vYj7eKMOBhc13r5tGf0HX7PuERdRy0vbqB2tSj6B+GSoQNKbUCo087Y7zeH
         sGT31kWqnrhtk4r0PSW8BZcihuSmUO7JtXVv+zgbmNC3vrmfzu5MiqVo+fGetJvCgt
         1tFXRtfyF+MndczjtUpMt49CLMdPcjLMkavaDm9+lueW37OHTWW0atBateKhL58XLN
         gGbgyUN1VhIVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3AEBD60953;
        Wed, 16 Jun 2021 19:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: hsr: don't check sequence number if tag removal
 is offloaded
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387120423.29488.741420966415811568.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 19:20:04 +0000
References: <20210615175037.19730-1-george.mccollister@gmail.com>
In-Reply-To: <20210615175037.19730-1-george.mccollister@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        m-karicheri2@ti.com, andrew@lunn.ch, marco.wenzel@a-eberle.de,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Jun 2021 12:50:37 -0500 you wrote:
> Don't check the sequence number when deciding when to update time_in in
> the node table if tag removal is offloaded since the sequence number is
> part of the tag. This fixes a problem where the times in the node table
> wouldn't update when 0 appeared to be before or equal to seq_out when
> tag removal was offloaded.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: hsr: don't check sequence number if tag removal is offloaded
    https://git.kernel.org/netdev/net-next/c/c2ae34a7deaf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


