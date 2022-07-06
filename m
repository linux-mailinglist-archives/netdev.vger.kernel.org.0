Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCBF567FB0
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 09:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiGFHUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 03:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbiGFHUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 03:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CC4222BC;
        Wed,  6 Jul 2022 00:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67419B81B37;
        Wed,  6 Jul 2022 07:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1CE6BC341CB;
        Wed,  6 Jul 2022 07:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657092016;
        bh=T4cV8xgwyibbhFJKPEWOheCwq4TI+nkD/YMstmO3nN8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hn6rJQO0wJgHqLQVdOaS8q+olo+NWBaxma5kKehhmOSnkkqR/yURap4Jp7+ev+O+T
         7DVu1yXlcP5weIcwCqRiIEpmBjPnX5UWSy/WW+iBGxv+dEl+0wkJDYldhHsnKVsPLL
         jCkyE9NyjvP/eymd8g0Q4oyFCugFnPJJgHyJmF7k54nQy1FST3ZsaoqLoMCoJatKvo
         szd2Z5MHIfGnOGFkrnofvi83lUffLXld/dRguDGmETUEBGsTo79tYljFQXypXKs3hL
         RNnxx6Jag5HQym1ehgyNPrgm8di+pVDLg9lhwCm1R7k71CeoYffzWQjtepGDCeNqZS
         J+WEiyP5fDEJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE4C2E45BDE;
        Wed,  6 Jul 2022 07:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V1 00/12] *** Exact Match Table ***
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165709201597.20840.6578848345104586479.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Jul 2022 07:20:15 +0000
References: <20220706034442.2308670-1-rkannoth@marvell.com>
In-Reply-To: <20220706034442.2308670-1-rkannoth@marvell.com>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgoutham@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 6 Jul 2022 09:14:30 +0530 you wrote:
> *** Exact match table and Field hash support for CN10KB silicon ***
> 
> ChangeLog
> ---------
>   1) V0 to V1
> 	a) Removed change IDs from all patches.
> 
> [...]

Here is the summary with links:
  - [V1,01/12] octeontx2-af: Use hashed field in MCAM key
    https://git.kernel.org/netdev/net-next/c/a95ab93550d3
  - [V1,02/12] octeontx2-af: Exact match support
    https://git.kernel.org/netdev/net-next/c/017691914c11
  - [V1,03/12] octeontx2-af: Exact match scan from kex profile
    https://git.kernel.org/netdev/net-next/c/60ec39311750
  - [V1,04/12] octeontx2-af: devlink configuration support
    https://git.kernel.org/netdev/net-next/c/ffd92c57469d
  - [V1,05/12] octeontx2-af: FLR handler for exact match table.
    https://git.kernel.org/netdev/net-next/c/799f02ef2ce3
  - [V1,06/12] octeontx2-af: Drop rules for NPC MCAM
    https://git.kernel.org/netdev/net-next/c/c6238bc0614d
  - [V1,07/12] octeontx2-af: Debugsfs support for exact match.
    https://git.kernel.org/netdev/net-next/c/01b9228b20ad
  - [V1,08/12] octeontx2: Modify mbox request and response structures
    https://git.kernel.org/netdev/net-next/c/68793a8bbfcd
  - [V1,09/12] octeontx2-af: Wrapper functions for MAC addr add/del/update/reset
    https://git.kernel.org/netdev/net-next/c/87e91f92cdcd
  - [V1,10/12] octeontx2-af: Invoke exact match functions if supported
    https://git.kernel.org/netdev/net-next/c/84926eb57dbf
  - [V1,11/12] octeontx2-pf: Add support for exact match table.
    https://git.kernel.org/netdev/net-next/c/e56468377fa0
  - [V1,12/12] octeontx2-af: Enable Exact match flag in kex profile
    https://git.kernel.org/netdev/net-next/c/7189d28e7e2d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


