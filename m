Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A0E35487A
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 00:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242686AbhDEWKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 18:10:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232628AbhDEWKP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 18:10:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 14643613D4;
        Mon,  5 Apr 2021 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617660609;
        bh=z28x4DHRRmuF6Tht7yn/Q8NaIZ/Q/w1JgBUS/5pRB6Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X0cB4e4qvSmoqlD8j2SgEVxPjfyJuAnzwMKN1rG9tTWbvuw5RNTP8dDTDfv77Qsdh
         R5ijZ+1t1b0mo8MpQ8KppfCwxmzDwk6haVtPaxQXB/DwzuVyo7JbLmz56fF7NXLY3u
         mGlI6XzZSyhDsgBu/i0BRqcWf7fmebJJ/14aAETJJV3cZXDwathxOVH9mK477yz8Pa
         5wRJrt1PCmBp8o4/t7xlhJpYNJ611St7nKLHTeFITBTgE3/NyM8EueodNBZH30tbKV
         MPN5b0qgPuvqqEmF9RahdEgUA3d2kMnxDizL4Qs8BGqjvkKPi9ZrZ2FuLV359xA5TR
         XrghdFZ0tI3EA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 054A760A00;
        Mon,  5 Apr 2021 22:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] openvswitch: fix send of uninitialized stack memory in ct
 limit reply
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161766060901.24414.14462323309343322855.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 22:10:09 +0000
References: <20210404175031.3834734-1-i.maximets@ovn.org>
In-Reply-To: <20210404175031.3834734-1-i.maximets@ovn.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        yihung.wei@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  4 Apr 2021 19:50:31 +0200 you wrote:
> 'struct ovs_zone_limit' has more members than initialized in
> ovs_ct_limit_get_default_limit().  The rest of the memory is a random
> kernel stack content that ends up being sent to userspace.
> 
> Fix that by using designated initializer that will clear all
> non-specified fields.
> 
> [...]

Here is the summary with links:
  - [net] openvswitch: fix send of uninitialized stack memory in ct limit reply
    https://git.kernel.org/netdev/net/c/4d51419d4993

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


