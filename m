Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD706875CA
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 07:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjBBGUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 01:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjBBGUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 01:20:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2F280154;
        Wed,  1 Feb 2023 22:20:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88C49B824D9;
        Thu,  2 Feb 2023 06:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2669DC433EF;
        Thu,  2 Feb 2023 06:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675318817;
        bh=LQSOLKvh3mGf0OkDuMZkmBirfLqqy93plSlmElbid9g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qbgsJ9PKSNwd5RDmELA+vT2i01FRm/k+rIMx5UTzwXAC6q5z04qMD6JySiTqOKGrb
         wyDHu4qA/I7xLWde9VhU5aC3swJlJCvmUDLORBkveUIBS87P+pVTJPhDKL0JM8FQOJ
         GB3IIKWDKkJ5Trj4m09fIej3BENYf36PRFXDe6yXj918KlqGcANeP1QU6+WCTSuzKd
         Uqu4CisOg3gczhGHgkKnST3y7vIAiVaxlaYI2/JdtjbXuuohOgxM2Ut7q3SxZNTHAN
         md8HvCU/TDYu4A/rLxAY5pdXwrTAqgcIODe3yJpdkT30n9Ra8un0MABwaoXXm6KJXh
         vY2XqUTYVHh9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0521BE5250B;
        Thu,  2 Feb 2023 06:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v1] octeontx2-af: Removed unnecessary debug messages.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167531881701.1809.3269440141665197563.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 06:20:17 +0000
References: <20230201040301.1034843-1-rkannoth@marvell.com>
In-Reply-To: <20230201040301.1034843-1-rkannoth@marvell.com>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, leon@kernel.org, sgoutham@marvell.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 1 Feb 2023 09:33:01 +0530 you wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> NPC exact match feature is supported only on one silicon
> variant, removed debug messages which print that this
> feature is not available on all other silicon variants.
> 
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v1] octeontx2-af: Removed unnecessary debug messages.
    https://git.kernel.org/netdev/net-next/c/609aa68d6096

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


