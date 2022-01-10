Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24ECA488D7A
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 01:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbiAJAaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 19:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbiAJAaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 19:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF14C06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 16:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EFD261028
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 00:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A05F7C36AE3;
        Mon, 10 Jan 2022 00:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641774616;
        bh=eeGlYNCr2Q2q3bmPtRm9nMSz4OPPs3BBrlHCmSOCSPM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HIeKLoUlC6VV/fvwd48+qpl9VGPQuhpvr6hoX6QGNv4P//iLF1aa2orMGRUca1Wv9
         hk986zeE01/EWNB6m+YdQaUolFaKiGpWa4HgucDw5I9YGQ29rPvR1fuRRXNr0IySpq
         Sr+ggrLEA3p+yLuV/9KB8bCjLTTQB2UmYdeR90uvjQOiyRG6JED+sLIRDQfLRukK7z
         nxpozb9ktlbjHWJL3HTwZC8DpMVoYOW2eSGCZOFnam/roXhZx34ZI2be9ao2Iyxdud
         5hcCQkeSGyWKdyNgZ4+1Jc+DShfRbHZgLoCirC+gbFSRlfp8UudGJQMN0QHuYwegHv
         FfXrYkgBCKH+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81B17F60790;
        Mon, 10 Jan 2022 00:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] bnxt_en: Update for net-next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177461652.5269.18284372712524159669.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 00:30:16 +0000
References: <1641772485-10421-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1641772485-10421-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 18:54:41 -0500 you wrote:
> This series adds better error and debug logging for firmware messages.
> We now also use the firmware provided timeout value for long running
> commands instead of capping it to 40 seconds.
> 
> Edwin Peer (4):
>   bnxt_en: add dynamic debug support for HWRM messages
>   bnxt_en: improve VF error messages when PF is unavailable
>   bnxt_en: use firmware provided max timeout for messages
>   bnxt_en: improve firmware timeout messaging
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] bnxt_en: add dynamic debug support for HWRM messages
    https://git.kernel.org/netdev/net-next/c/8fa4219dba8e
  - [net-next,v2,2/4] bnxt_en: improve VF error messages when PF is unavailable
    https://git.kernel.org/netdev/net-next/c/662c9b22f5b5
  - [net-next,v2,3/4] bnxt_en: use firmware provided max timeout for messages
    https://git.kernel.org/netdev/net-next/c/bce9a0b79008
  - [net-next,v2,4/4] bnxt_en: improve firmware timeout messaging
    https://git.kernel.org/netdev/net-next/c/8c6f36d93449

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


