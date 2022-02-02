Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66BB4A6B40
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:10:13 +0100 (CET)
Received: (majordomo@0.0.0.0) by vger.kernel.org via listexpand
        id S232234AbiBBFKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiBBFKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:10:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE60FC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 21:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D92B616BF
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A482CC340EB;
        Wed,  2 Feb 2022 05:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778610;
        bh=I3E8UKiaYN8mR3oMJBJXCCYxit+TPH4dSusycT4sj9Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aHkoqyyng3jksW8UfiGFbud9En2RFldXM4pYuCVHHYl1aj21b8I07r/SLBSEVngrA
         8qQJadJPsL7ejhVxk/vRR/KDqZXi9X2oCfcDwnt9+hSR2f+UYAGZIawhgqgr75Frzs
         CSpcxGh6DEfg5YySjeGV5c2aT/BO0wnxsr2Vug1AHBW0KX66Yk1UMBYV6en4AkzzEs
         ywRTqfBSdzDcmK62xfsJj3rSHig64cLvuNnVAsq5tz9PQtxRV1JbzTm20t8o8uLvC6
         LY112ifKTmGUI86dm1ddC2AOYTbCPKqxjTKnEuMfWPmVHOp7dEl0dRTiabRwajO2vf
         aZrFg903eDFIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8CD1DE5D091;
        Wed,  2 Feb 2022 05:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-02-01
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164377861057.30544.7924209825776669007.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 05:10:10 +0000
References: <20220201173754.580305-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220201173754.580305-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue,  1 Feb 2022 09:37:52 -0800 you wrote:
> This series contains updates to e1000e driver only.
> 
> Sasha removes CSME handshake with TGL platform as this is not supported
> and is causing hardware unit hangs to be reported.
> 
> The following are changes since commit 881cc731df6af99a21622e9be25a23b81adcd10b:
>   net: phy: Fix qca8081 with speeds lower than 2.5Gb/s
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE
> 
> [...]

Here is the summary with links:
  - [net,1/2] e1000e: Separate ADP board type from TGP
    https://git.kernel.org/netdev/net/c/68defd528f94
  - [net,2/2] e1000e: Handshake with CSME starts from ADL platforms
    https://git.kernel.org/netdev/net/c/cad014b7b5a6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


