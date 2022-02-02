Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19794A6AE8
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244155AbiBBEaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244210AbiBBEaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 23:30:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A294C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 20:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15DDA616E4
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 04:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68386C340EB;
        Wed,  2 Feb 2022 04:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643776211;
        bh=XKq12r3D6Dq30fkJPtO4nzR9v6AXrRH8zFRrVpvBzd4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H5phcSPJBzDucH8BDJ2MYI+/BHCCjrbwvh87qAimO0sIDH2bPX2SIfJIhz1xZyeT5
         XcUOQ4QZuGRe7v9E+fSSgOudf3My4liGfeHSkRWuEgZwfn+FttYevpAVOMKcv9+YMw
         8P1Jp3v2cQrgxCk9MQnS57XzqiVwSWLe4jE0cx+C+VyepD4+yGgJiDZZlhxKSQ5pWV
         GwjFStXdzFeVeeNydrJJ6Pry90XCEMBJ78aEiZjJXXX3oDXKlIpo2WLgQg9H4R4o30
         JIhKUTZAD2JD+a9TOJPpYlxy2YWjQqFc/oeiZeq3zilMqtiVRkWxtc+3muZe7M6Wns
         RuR9kijhiPbog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B12BE5D09D;
        Wed,  2 Feb 2022 04:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rtnetlink: make sure to refresh master_dev/m_ops in
 __rtnl_newlink()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164377621129.13473.12174245140420855168.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 04:30:11 +0000
References: <20220201012106.216495-1-eric.dumazet@gmail.com>
In-Reply-To: <20220201012106.216495-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, jiri@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 31 Jan 2022 17:21:06 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While looking at one unrelated syzbot bug, I found the replay logic
> in __rtnl_newlink() to potentially trigger use-after-free.
> 
> It is better to clear master_dev and m_ops inside the loop,
> in case we have to replay it.
> 
> [...]

Here is the summary with links:
  - [net] rtnetlink: make sure to refresh master_dev/m_ops in __rtnl_newlink()
    https://git.kernel.org/netdev/net/c/c6f6f2444bdb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


