Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C962CDEB0
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 20:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgLCTUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 14:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbgLCTUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 14:20:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607023206;
        bh=ev02Cctz9esirir+W21KbZd/cCprPr/x5pScIA+V158=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p0irKyEMCD4cn27naV8WqdpRClkC7FGy0MJ1WJCJ1d1SQ8uXpYtJAejaTRV5qqttz
         CjIGQM8E3pWvDPLMHuMTmUQX+0tVPTkLUawIi3wBVQAY1UMBBi76hYOud8lue1EZ0a
         YNKGEQ2BjJdr/EnNiI1aKdRHsMZYhei/OBYWb1j9Ipbi1F8/HRwyvlCuJQl0m80ITK
         D3ZKjTqwh0KAWjL0Ct9jKJbBpXCMpMUcRiF7gdt+BdUVdApxopLcqes1Ztt14s1+Cd
         jyZLOAB2Cyf+8SfG6NCWxm3+fDcGiBg+qJe5ujvu3Jz9R54w5aD1kqdKN64GLS7fxD
         YB8Wp605tuV7A==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: openvswitch: ensure LSE is pullable before reading
 it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160702320649.13599.3465260513720749559.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Dec 2020 19:20:06 +0000
References: <aa099f245d93218b84b5c056b67b6058ccf81a66.1606987185.git.dcaratti@redhat.com>
In-Reply-To: <aa099f245d93218b84b5c056b67b6058ccf81a66.1606987185.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     pshelar@ovn.org, kuba@kernel.org, john.hurley@netronome.com,
        gnault@redhat.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  3 Dec 2020 10:46:06 +0100 you wrote:
> when openvswitch is configured to mangle the LSE, the current value is
> read from the packet dereferencing 4 bytes at mpls_hdr(): ensure that
> the label is contained in the skb "linear" area.
> 
> Found by code inspection.
> 
> Fixes: d27cf5c59a12 ("net: core: add MPLS update core helper and use in OvS")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] net: openvswitch: ensure LSE is pullable before reading it
    https://git.kernel.org/netdev/net/c/43c13605bad4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


