Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A838317421
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhBJXPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:15:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233557AbhBJXKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 18:10:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4B0E964EBB;
        Wed, 10 Feb 2021 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612998607;
        bh=TytTf8z1FZ7LJNb3jSnsedm0A3OhtKPemmCYkkZ2Lpg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oKySckboBwuMk6eNMBTRKjieV6VeJM4w1IOjUz6HVNN87ZX4xWOifD6bu1Mh3pwFE
         msb1YVoWd5fPzPSdcDBPOPNFMSIST0uO2bv4HsCJf58zY7zYg/RoEQvIQeo38AkpTe
         dD2iBEuY7nU0PMtfRYfNVuIhtyQ1Se7iUji6ZQrbZ2VygxKvBxynRh9Meyg71P+Z0C
         kpsO33crJVIqafVxNpbETscMzkcAjAkF9V/Cre3vLhMmbSBYOmzMEO9/q/p3M7LGEt
         ucTiuDgq3L4aLlc2TknHlB/VFKNOflrir96qXb3v2oYR7/5bErn5XkZdYOJEq1UMOi
         ZM7AxodMOeyfw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 380DF609F1;
        Wed, 10 Feb 2021 23:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] cxgb4: collect serial config version from
 register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161299860722.8401.9500743309721224656.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Feb 2021 23:10:07 +0000
References: <1612849958-25923-1-git-send-email-rahul.lakkireddy@chelsio.com>
In-Reply-To: <1612849958-25923-1-git-send-email-rahul.lakkireddy@chelsio.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, bhelgaas@google.com, rajur@chelsio.com,
        alexander.duyck@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  9 Feb 2021 11:22:38 +0530 you wrote:
> Collect serial config version information directly from an internal
> register, instead of explicitly resizing VPD.
> 
> v2:
> - Add comments on info stored in PCIE_STATIC_SPARE2 register.
> 
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] cxgb4: collect serial config version from register
    https://git.kernel.org/netdev/net-next/c/24a1720a0841

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


