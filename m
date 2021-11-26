Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0AC45F565
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238209AbhKZTvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236913AbhKZTs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:48:59 -0500
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 26 Nov 2021 11:30:12 PST
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D041C061761;
        Fri, 26 Nov 2021 11:30:12 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12779B82860;
        Fri, 26 Nov 2021 19:30:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 9267C60184;
        Fri, 26 Nov 2021 19:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637955009;
        bh=VJ8veWKoA5JbnwL/uH3HKAbafdEqUwxZD6IGqqEX4PY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bRYz/gyHu9KgBo3RRjm9wK6PdCiuw5/JgfHlwU28vEIgYqyULDHZPFARGw8om/pTx
         bxtYutKFZrNrs/1o4y87BHJKmMorDfquNqemzg0Pxqj5KAyy0SQ67RaYuJmkKNT2Wt
         HOkltGXsvJvz4eMMONs+N1Aw4cPsqfbXKqJS5jrYHJ37e62xK3jBnvZlSoT3R8GIhO
         c7zNzbJh3uet1lTWM0+LeM0AcG5U0VRYDNfvkIgPrTiywbZOZKzh0QoDUXz+HcM4mC
         X5t8RfvEABrnuwA5hBTw3/kSf/ICT36ShNy0ySWFTgSFm5pJ3/nmUV9dejxduRWKTj
         tzgxTLqFNQrYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8873F60BE3;
        Fri, 26 Nov 2021 19:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: vlan: fix underflow for the real_dev refcnt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163795500955.14661.10590716553685187245.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 19:30:09 +0000
References: <20211126015942.2918542-1-william.xuanziyang@huawei.com>
In-Reply-To: <20211126015942.2918542-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan (William) <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 Nov 2021 09:59:42 +0800 you wrote:
> Inject error before dev_hold(real_dev) in register_vlan_dev(),
> and execute the following testcase:
> 
> ip link add dev dummy1 type dummy
> ip link add name dummy1.100 link dummy1 type vlan id 100
> ip link del dev dummy1
> 
> [...]

Here is the summary with links:
  - [net] net: vlan: fix underflow for the real_dev refcnt
    https://git.kernel.org/netdev/net/c/01d9cc2dea3f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


