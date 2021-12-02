Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9BD465C7A
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344910AbhLBDNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344839AbhLBDNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:13:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CE2C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62DF5CE2162
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 03:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8CFD7C53FCF;
        Thu,  2 Dec 2021 03:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638414609;
        bh=vsHjyoH+0i1zEXmpgzMLA2E4nnELx2OtcQ6NnBT87kA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j6v4VUo5GKEIAKwZ0i+B+0/hrGvoI4dKQzuR/zrCgHMpCOVCYPffAPSuvoYcYfKO6
         F49S9Brxq8xTNlwbN3eQ3Eedosi1q/fZ7e//pKIV5h565xjMTU47Wl+Rf4Z2YUIDZi
         CLjZN1Rys9LpJW6rMK9xRHCeCKi5o1jylE3n3hbYchEolZ4kYxtExsqMqRcr7Ibdng
         ZQHQwTRDGJ2fmu6NRZIGJCVGHIHrIsiLiZj/qZKWn+KiFrDFX4dsyysL5EL0ZajKH1
         spPen2UU84isRnyLi/+4CyfoyZrF5t+gzdv4TUK2eSWGlLTihfQL22klmk37kt1WEJ
         rPKtITNeoxwiw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 62503609EF;
        Thu,  2 Dec 2021 03:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vrf: Reset IPCB/IP6CB when processing outbound pkts in
 vrf dev xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163841460939.28228.4025698899293588562.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 03:10:09 +0000
References: <20211130162637.3249-1-ssuryaextr@gmail.com>
In-Reply-To: <20211130162637.3249-1-ssuryaextr@gmail.com>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Nov 2021 11:26:37 -0500 you wrote:
> IPCB/IP6CB need to be initialized when processing outbound v4 or v6 pkts
> in the codepath of vrf device xmit function so that leftover garbage
> doesn't cause futher code that uses the CB to incorrectly process the
> pkt.
> 
> One occasion of the issue might occur when MPLS route uses the vrf
> device as the outgoing device such as when the route is added using "ip
> -f mpls route add <label> dev <vrf>" command.
> 
> [...]

Here is the summary with links:
  - [net] vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit
    https://git.kernel.org/netdev/net/c/ee201011c1e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


