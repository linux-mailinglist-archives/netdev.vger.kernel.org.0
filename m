Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B76637EE85
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhELVv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1389571AbhELVBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 17:01:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 760FC613D6;
        Wed, 12 May 2021 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620853209;
        bh=MTp/KUNwct/d9iOHm61Rs5K5dgKlpQPmKNjrOiGyMB4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VBnU9Ec5kdepVOOnC8uhOBACxT4r6LNvIqS0gjg/7iozcpmp3xL6kyXU3BNRP3GwQ
         Qe/9bh+ORuP7nriDzad0MzVBr7FLw2G9tNm0au+4L8/tVLPayv+lKvkOOFRV6cho0+
         9hkifu+nAtYQqnm/2cg9J7LbUzeKiDAVAr9SSI92wNypPjAflV9F/c0MWKgMs2oiRV
         LYQOaKTiMjvnF/TAFyoVwGvb5FgMyeIRUHLYj/5EDgwq7hFp2BYWOVikZrViX3wYqR
         PAGfGrDFFCTHcJroXRovgFgredCmu+s5EMimYRCrA3oPpFfWri4TyievRi8NdCTXph
         vh2xI7/DEb9UQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 65FD5609D8;
        Wed, 12 May 2021 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: really orphan skbs tied to closing sk
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162085320941.1484.16949140490975844651.git-patchwork-notify@kernel.org>
Date:   Wed, 12 May 2021 21:00:09 +0000
References: <b634d7aa85404b892a6199542c396b8ce4f94221.1620722065.git.pabeni@redhat.com>
In-Reply-To: <b634d7aa85404b892a6199542c396b8ce4f94221.1620722065.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 11 May 2021 10:35:21 +0200 you wrote:
> If the owing socket is shutting down - e.g. the sock reference
> count already dropped to 0 and only sk_wmem_alloc is keeping
> the sock alive, skb_orphan_partial() becomes a no-op.
> 
> When forwarding packets over veth with GRO enabled, the above
> causes refcount errors.
> 
> [...]

Here is the summary with links:
  - [net] net: really orphan skbs tied to closing sk
    https://git.kernel.org/netdev/net/c/098116e7e640

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


