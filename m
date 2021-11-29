Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AE24617A8
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244407AbhK2OQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbhK2OOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:14:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E36C08EAE0
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 04:50:11 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D86DB81082
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 12:50:10 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 1B54860184;
        Mon, 29 Nov 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638190209;
        bh=0MZSOwf4nxCWdMHkCbriEMvcwGXKfySnoAj/XJX7uK0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DFz3r/yLtKfqTXAK0aMBNBWs/8MRu9UaoB7/jr5YbEgzijhG2J8MX6j6XXF72OpE7
         GG4T8l0YCcwjNSCsQp+U1HiWuLjHedIxTYXPlVBUfMQ9A5NCfMwrOgMO/KDomJ0K42
         5wG+JQRVuvDrHEbvh8UavhlAKxExhUbwFau8rUMGzCm9zyPE0a6LIoGTutaxjwWIWK
         jf0OIzyhfEbnCnuwCG973fWjnr3MUKeCofeY7A4B7hNxn0zeK19E2poBm59IkVb5Zo
         LayzN85qbtFsMgkW4+vx5feWBuZ1cgdXJnT9yVafcWxdit0nli8QkWWlwuxLmrhRMi
         qAnUac0b1NbXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0C4B5609D5;
        Mon, 29 Nov 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: mpls: Netlink notification fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819020904.1533.11218370817272182184.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 12:50:09 +0000
References: <20211129061506.221430-1-bpoirier@nvidia.com>
In-Reply-To: <20211129061506.221430-1-bpoirier@nvidia.com>
To:     Benjamin Poirier <bpoirier@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        jiapeng.chong@linux.alibaba.com, l4stpr0gr4m@gmail.com,
        roopa@cumulusnetworks.com, rshearma@brocade.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 15:15:04 +0900 you wrote:
> From: Benjamin Poirier <benjamin.poirier@gmail.com>
> 
> fix missing or inaccurate route notifications when devices used in
> nexthops are deleted.
> 
> Benjamin Poirier (2):
>   net: mpls: Fix notifications when deleting a device
>   net: mpls: Remove rcu protection from nh_dev
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: mpls: Fix notifications when deleting a device
    https://git.kernel.org/netdev/net/c/7d4741eacdef
  - [net,2/2] net: mpls: Remove rcu protection from nh_dev
    https://git.kernel.org/netdev/net/c/189168181bb6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


