Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056FF466448
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 14:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358116AbhLBNNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 08:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354377AbhLBNNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 08:13:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A562C061757;
        Thu,  2 Dec 2021 05:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70DBFCE22C5;
        Thu,  2 Dec 2021 13:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68401C53FD3;
        Thu,  2 Dec 2021 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638450609;
        bh=CQK9cua0MLyWbKpqaziAyAfOfw7bPMu4osrVR0XZkig=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pHj6a6WjtphP4zApHaWY4K9S1z2CxdHft0ougef9+DcGTVvYNL/1LXsFSGmifNtBE
         Ssl9q8ZxJDZYgK9iQ5LZkdNXuEQXJo+yqaPmZgVOxyv/xjP0Td8s2sj8NMnQJzHGJQ
         WL7++1y2dCQF0UYxkByvcE5MzV+8DYkbMHI7yvu4Nut1cHkKDYgyBP7l3D859aZT7p
         dwtURBd4IWz5LnOzqZQqIumg095eIwVASENxpnmlyVzHkZVbfJ9IA0ehZg7ecZIFPU
         kk74UjC+vao3x3clnM8f3CsCykIZhtCuaOADnpF302xeWXgiuHgpLi72wkGcgfb+Tm
         LUlGpWWhZqpNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 495E860A90;
        Thu,  2 Dec 2021 13:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: openvswitch: Remove redundant if statements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163845060929.30486.18251129192128815140.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 13:10:09 +0000
References: <20211202075148.34136-1-vulab@iscas.ac.cn>
In-Reply-To: <20211202075148.34136-1-vulab@iscas.ac.cn>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  2 Dec 2021 07:51:48 +0000 you wrote:
> The 'if (dev)' statement already move into dev_{put , hold}, so remove
> redundant if statements.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>  net/openvswitch/vport-netdev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - net: openvswitch: Remove redundant if statements
    https://git.kernel.org/netdev/net-next/c/98fa41d62760

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


