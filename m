Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6A549E3BA
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238015AbiA0NkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:40:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44618 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236993AbiA0NkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 08:40:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A83CF61C3F;
        Thu, 27 Jan 2022 13:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1721CC340EE;
        Thu, 27 Jan 2022 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643290811;
        bh=b+OFj1/WSKrOIbpsXtEbDy9nMLToWSoegv5zebPHMmI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jb83ubKc7kE9tDtlvh+qIuPqKk6xBYHaGY90+5Zh7LZQL3oqfPb+J98jlWlBjkQ77
         m1Wfnbc2LVGy+uKh9iLbsyioeuU6tIgalr1m2qVz70N9VyHer7Pczk5VQ9mjz0gzIP
         PtR8opxVjxw0vuObXM2rxhcMCdFdB0Vgw0yliU3T3VOxywnIUxlIHxW4X020mki34e
         ZMBwZ77wvVteMCvBfHs7KZUNDqNcccH+A3tRQDkpzLIsQio7IW2Lu6GI4VW59qZ9pN
         K4/jUa+sECzPKBjxe3ZuCb0Axpz5wJkG5NUpCwi0Y3BXWsE4MAW0t54sVz5H8Ce54W
         jFOmkoLaIPx+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE2B4E5D08C;
        Thu, 27 Jan 2022 13:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH resend] ipv4: Namespaceify min_adv_mss sysctl knob
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329081096.3515.3479311562867643415.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 13:40:10 +0000
References: <20220126071058.1168074-1-xu.xin16@zte.com.cn>
In-Reply-To: <20220126071058.1168074-1-xu.xin16@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.xin16@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Jan 2022 07:10:58 +0000 you wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Different netns has different requirement on the setting of min_adv_mss
> sysctl which the advertised MSS will be never lower than.
> 
> Enable min_adv_mss to be configured per network namespace.
> 
> [...]

Here is the summary with links:
  - [resend] ipv4: Namespaceify min_adv_mss sysctl knob
    https://git.kernel.org/netdev/net-next/c/2e9589ff809e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


