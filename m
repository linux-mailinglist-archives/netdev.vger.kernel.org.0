Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355E14742CD
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbhLNMkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:40:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55720 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbhLNMkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 07:40:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E54F5B8190A
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD833C3460A;
        Tue, 14 Dec 2021 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639485611;
        bh=HckZlMwlR2iiNcLJz0ZFs6bYok6ZZxhrEVDkYHFvelI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O6qzLlPlyeekT9fKv8/xz+48MP9pVA6xnvwkWDiTAmSmDQIQLn+jBwLZaEHnEunOc
         tJ9wBR6twtR7qstLVE+dQUrZCCz0LwAWrtppA3Mtf8kQobNXEiJiseM28fr1/qTX7c
         GAH/ruDch4MfNOpNMD0syG1f61iq/+x4cYGgHgZP5DC8B0hMoOH9Horhsqp2EZRGt9
         c1LAG+Pbei0fPyJRYK01DFikD9diMVjnfmVJ42cGgmdqhtjxk6S0ES2Up4M6D7PoZ3
         Q3Vvf+05z5oOT1/UgkZ20aHM1pHftp9imBV/ntbD5cNtvMBe+RdEe0i9VtBamR36yl
         B9W6gePYZzhHw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8D1B560A2F;
        Tue, 14 Dec 2021 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 net-next 0/2] net: add new hwtstamp flag
 HWTSTAMP_FLAG_BONDED_PHC_INDEX
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163948561157.12013.2611234775622892151.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Dec 2021 12:40:11 +0000
References: <20211210085959.2023644-1-liuhangbin@gmail.com>
In-Reply-To: <20211210085959.2023644-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com, hkallweit1@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Dec 2021 16:59:57 +0800 you wrote:
> This patchset add a new hwtstamp_config flag HWTSTAMP_FLAG_BONDED_PHC_INDEX.
> When user want to get bond active interface's PHC, they need to add this flag
> and aware the PHC index may changed.
> 
> v3: Use bitwise test to check the flags validation
> v2: rename the flag to HWTSTAMP_FLAG_BONDED_PHC_INDEX
> 
> [...]

Here is the summary with links:
  - [PATCHv3,net-next,1/2] net_tstamp: add new flag HWTSTAMP_FLAG_BONDED_PHC_INDEX
    https://git.kernel.org/netdev/net-next/c/9c9211a3fc7a
  - [PATCHv3,net-next,2/2] Bonding: force user to add HWTSTAMP_FLAG_BONDED_PHC_INDEX when get/set HWTSTAMP
    https://git.kernel.org/netdev/net-next/c/085d61000845

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


