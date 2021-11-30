Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018A14633E0
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241403AbhK3MNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241384AbhK3MNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:13:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C46C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 04:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 95671CE192A
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 12:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C02DCC5831A;
        Tue, 30 Nov 2021 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638274210;
        bh=4KX+zjuJr2YzrHGaeeI4FtED/sAEBhbUf+tWioHZH7g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t2iyA+aRuky2pcfymGBSCmIPuGVGLUbUvM3FQsReRN+uxSq7eajamqYYmLn8byrXd
         UChxQSf4bAJYGnvXm87v+3Lj4zo/SmslXMmcw6TBbe4kKIRfj6MIaKg7GIKgXewq1W
         TQcNcPt7IsXPBFbtdu7FzS63RKDGf34tsOiFnrqQh1PfM2Y0kDaOX5xaaZPPAFuhzG
         ZvpITQ6rq6JowzkY0X+wZD6yCCFJWeiZUE897u1OFH6d8QiPqYZSEIPEGkCNhnityy
         z1xi+D/yHYeQcAtHeOZbcVwsxcbjznfgiw0Q+KtYeXo3ua7Sy1aEVazCwQtAQvcRYV
         a6p+t3i3ZCs+w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ACE2360AA1;
        Tue, 30 Nov 2021 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: nexthop: reduce rcu synchronizations when
 replacing resilient groups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827421070.23105.15957891178793599366.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:10:10 +0000
References: <20211129120924.461545-1-razor@blackwall.org>
In-Reply-To: <20211129120924.461545-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, nikolay@nvidia.com, idosch@idosch.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 14:09:24 +0200 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> We can optimize resilient nexthop group replaces by reducing the number of
> synchronize_net calls. After commit 1005f19b9357 ("net: nexthop: release
> IPv6 per-cpu dsts when replacing a nexthop group") we always do a
> synchronize_net because we must ensure no new dsts can be created for the
> replaced group's removed nexthops, but we already did that when replacing
> resilient groups, so if we always call synchronize_net after any group
> type replacement we'll take care of both cases and reduce synchronize_net
> calls for resilient groups.
> 
> [...]

Here is the summary with links:
  - [net-next] net: nexthop: reduce rcu synchronizations when replacing resilient groups
    https://git.kernel.org/netdev/net-next/c/7709efa62c4f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


