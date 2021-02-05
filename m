Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5DE310403
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 05:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhBEEUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 23:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhBEEUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 23:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3BBDE64FBC;
        Fri,  5 Feb 2021 04:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612498807;
        bh=RxszWBp2uBHUtJL+Bz+8WfUnBnz9Q25Y3Tb3e/Wav4A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bQVNQzq0/7CWZPLBOqRWU2pn7Vk5uWz6SAfF0CMhJIdDSTxs1PiAv+vfLhPtfkzE8
         pq1x9QIKqDp5MWnVk5pdGXcGaNwIU7kLFcSsUXFspN3fkeVp0WQHW6xKFdojypB/lA
         EH5HhPNFvcTP1d/hJahHSStUzv8J34HWYLkkYAvTAEwj+hAGcQVK3RQ3t2V0TfcHKk
         nIiOMkfG5bPmhFN00L4Ok0H+f3JOPuEiGilVkowq3jlatOWssL2EzDzL5mtWU72zeY
         4YIn1b8RvlrnrM5VEFWntoplTBcls2LXDYNaBKTAS+RZpjFsEfrCnYGxV93TyR0z4a
         3krygsH5m+xeQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3058C609F3;
        Fri,  5 Feb 2021 04:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] udp: fix skb_copy_and_csum_datagram with odd segment
 sizes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249880719.20393.11679190126322875011.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 04:20:07 +0000
References: <20210203192952.1849843-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20210203192952.1849843-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        oliver.graute@gmail.com, sagi@grimberg.me, viro@zeniv.linux.org.uk,
        hch@lst.de, alexander.duyck@gmail.com, eric.dumazet@gmail.com,
        willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  3 Feb 2021 14:29:52 -0500 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> When iteratively computing a checksum with csum_block_add, track the
> offset "pos" to correctly rotate in csum_block_add when offset is odd.
> 
> The open coded implementation of skb_copy_and_csum_datagram did this.
> With the switch to __skb_datagram_iter calling csum_and_copy_to_iter,
> pos was reinitialized to 0 on each call.
> 
> [...]

Here is the summary with links:
  - [net,v2] udp: fix skb_copy_and_csum_datagram with odd segment sizes
    https://git.kernel.org/netdev/net/c/52cbd23a119c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


