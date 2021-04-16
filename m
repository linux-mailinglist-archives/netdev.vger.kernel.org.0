Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50252362B9D
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbhDPWug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230432AbhDPWuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CA915610CD;
        Fri, 16 Apr 2021 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618613409;
        bh=oGA9b/am8idc6a70H66OfjahSEfuNXtc71twJLWqEoU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rMxYcIZ9epReTZQ0jv7W+2r4hrVv7TEmvFUVkjObh6qiZmQ3an5poTGH2hctzL2Xu
         zWnFir0SotCCmkpizpiyrj2g/4uvgmDfWbq3nT2/92EKUGwEpcmzYv1n9d8ivbskmI
         aXtUDb/ZL6Ca3pns06ieDMZjLnAgr2n9nRjYltArpixUgKNQ45Joj5UOvDnZWfFYz3
         iHXCnyR7LmygpAU8pikWApaSuwnDTs5w03qA+qlC8bHloas+CvcCcikZ8T0zhP6w7g
         z+14r8XQMsrJwQJtajWDcENiMZqxbWA6iGa1kyYnadc+ZC6GVvie644gPrwuB6j8iR
         oq7fiEVPbYifA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C055D60CD4;
        Fri, 16 Apr 2021 22:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] veth: check for NAPI instead of xdp_prog before xmit
 of XDP frame
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861340978.29090.2271798719941906376.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 22:50:09 +0000
References: <20210416154745.238804-1-toke@redhat.com>
In-Reply-To: <20210416154745.238804-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        pabeni@redhat.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Apr 2021 17:47:45 +0200 you wrote:
> The recent patch that tied enabling of veth NAPI to the GRO flag also has
> the nice side effect that a veth device can be the target of an
> XDP_REDIRECT without an XDP program needing to be loaded on the peer
> device. However, the patch adding this extra NAPI mode didn't actually
> change the check in veth_xdp_xmit() to also look at the new NAPI pointer,
> so let's fix that.
> 
> [...]

Here is the summary with links:
  - [net-next] veth: check for NAPI instead of xdp_prog before xmit of XDP frame
    https://git.kernel.org/netdev/net-next/c/0e672f306a28

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


