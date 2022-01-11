Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B739B48B234
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349762AbiAKQaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242291AbiAKQaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:30:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1A7C06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 08:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85D77616DE
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 16:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E73EEC36AE3;
        Tue, 11 Jan 2022 16:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641918613;
        bh=gJ6U7pY/e8Cswv/ApbL296Dbnayxmq5z3vuSaNP6S9I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jhj7oz5DtNN86tPB4CKoAp4YwpekPq4/sEMnYeSGaaIpo29IULeSkEe72l0seH4NW
         UrB5iGRiioi/fQjEAQ/CXFS1hRQU4VN5Ha5fGTkT2EcNNCBV+z1OW+vfxKvP9njJDZ
         N161D9X+0NPfc25QqaT1UPQN2AvichtrDg/3mK6XmB/dPRPuYEflWr3G7c70Ta2TrO
         ACknVeEmbjJd16pCEIEC7IqGxvFyO+KlwhE82PEqtNsDuR7ysnRGPo2oeOwzna64FF
         Rpve5ZIJMwCOf8JYoMCF5luhu2bDgIjgoGMudIhS/BRohH1iPQ6B00IwRB2uztR5Ce
         8ghaWamirt+tw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA4D1F6078E;
        Tue, 11 Jan 2022 16:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/2] RDMA clang warning fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164191861380.12736.2034538744802044982.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Jan 2022 16:30:13 +0000
References: <cover.1641753491.git.leonro@nvidia.com>
In-Reply-To: <cover.1641753491.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, leonro@nvidia.com, sthemmin@microsoft.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Sun,  9 Jan 2022 20:41:37 +0200 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> This is followup to Stephen's series [1].
> 
> Thanks
> 
> [1] https://lore.kernel.org/all/20220108204650.36185-1-sthemmin@microsoft.com
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/2] rdma: Limit copy data by the destination size
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=b87671681e8a
  - [iproute2-next,2/2] rdma: Don't allocate sparse array
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=bb4cc9cca408

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


