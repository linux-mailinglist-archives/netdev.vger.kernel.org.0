Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201AC3ED1D3
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhHPKU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232180AbhHPKUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7AD2761BB3;
        Mon, 16 Aug 2021 10:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629109206;
        bh=96y3ZhLtpQMFPCRNhDj7LTtyOOg+YLI6O1peZ6VVNlU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ho3hTBgu2Q8DnrCgwS0dGjbcmf8odu4ujkvLdDd6HijOHcj0sb3UQXxYuGOLx0/WS
         pOS12wZFmqMBdbeszAb41F+7G4bwPLNq2F1o8rT2zo8OvnJPZA1MjG0CpldPdG0c9w
         egVXyNKMPOw1RoGG+HDWGFu17KrWAKPajyXtbaqXtSp0n4C6Sy+KShS6cNQLRL36Hn
         9kt8KAk3cm2eOKcWTh8hi7WunOnkiE+eXeIGuOFoaE1K3cW791wGfuKDaLU77NXMvX
         NV4y2+1YZ0PZikDkALZrn4lxP5i3Cu8Vq/SiRq6uyKi4FBT4lFDJDeJ1rS3FV8TBc7
         BAXkln3iKJyCA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7517960976;
        Mon, 16 Aug 2021 10:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: tag_8021q: fix notifiers broadcast when
 they shouldn't, and vice versa
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910920647.28018.16840913786834493735.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:20:06 +0000
References: <20210813230422.111175-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210813230422.111175-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 14 Aug 2021 02:04:22 +0300 you wrote:
> During the development of the blamed patch, the "bool broadcast"
> argument of dsa_port_tag_8021q_vlan_{add,del} was originally called
> "bool local", and the meaning was the exact opposite.
> 
> Due to a rookie mistake where the patch was modified at the last minute
> without retesting, the instances of dsa_port_tag_8021q_vlan_{add,del}
> are called with the wrong values. During setup and teardown, cross-chip
> notifiers should not be broadcast to all DSA trees, while during
> bridging, they should.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: tag_8021q: fix notifiers broadcast when they shouldn't, and vice versa
    https://git.kernel.org/netdev/net-next/c/b2b891334111

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


