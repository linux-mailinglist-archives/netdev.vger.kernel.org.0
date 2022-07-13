Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70F1573839
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbiGMOA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236455AbiGMOAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AFB2E681;
        Wed, 13 Jul 2022 07:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FBA161DA4;
        Wed, 13 Jul 2022 14:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF3ECC341D8;
        Wed, 13 Jul 2022 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657720815;
        bh=CzV2juzizVMlY6ImvsnPyBqegbB6kShm9CID5wye2Uo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jwqEed771ldulcjtrlVs/mUfqsa625olal5mKOERtOs6IlBNpYTaZKMMSCV+hFjWz
         5n0KNYZNAgNJOi4SlDgZpy0xuQ47oH5LwfM8FMCUe+5hrz1V+QMwF/Owrr6dA4niDK
         fk4Ju94Ulvq7EWCLH1O0nGp5A0VNyqxj9odkxPsPAVwCYh0KhitjBxBEHiLzX0bDPi
         H3Ph6KI9GcIM6jxaZHQiRf1f9lAo6dBu/GsWZ0s5xQi7eAlmt5qbZ5ttFb6TosFdqd
         kFhHN1pzExEvPmFIMlGB92qFMOIKfbfBY+z4XJAxCE07m1BAfRtKTrDk6IY0E7PoC+
         +vOD4Ano6fp9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ADE93E45231;
        Wed, 13 Jul 2022 14:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-af: Remove duplicate include
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165772081570.13863.4590642394293681973.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 14:00:15 +0000
References: <20220713020759.52770-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20220713020759.52770-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Jul 2022 10:07:59 +0800 you wrote:
> The include is in line 14 and 23. Remove the duplicate.
> 
> Fix following checkincludes warning:
> 
> ./drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: linux/bitfield.h is included more than once.
> ./drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: rvu_npc_hash.h is included more than once.
> 
> [...]

Here is the summary with links:
  - octeontx2-af: Remove duplicate include
    https://git.kernel.org/netdev/net-next/c/d86a153aca7e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


