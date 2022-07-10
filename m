Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7224F56D0B4
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 20:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiGJSWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 14:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGJSWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 14:22:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E23EE07;
        Sun, 10 Jul 2022 11:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0338160E8B;
        Sun, 10 Jul 2022 18:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5630BC341C8;
        Sun, 10 Jul 2022 18:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657477323;
        bh=fFLHdaTrkdL546hiavbwZ4q6JyKxUPTO4mCIXRkM4ZQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ojK40enGcuer2RNiPxNMGa9P6bv06ZfLhTK1nB7O87SXb1qLc3JDuplfTYSIZ5V8P
         SkoP7BOBQ8IxIenw8rrTP7Z1XnoKNRjWqbIEwnl2u8Iikx62dRbdbe9fY5QK8Qwwkt
         l1yvo3vUc3Avxlcr3I3QjLVkEzknIDVPh6X5ZBKpZF7YyC+/UQii9IyKm21YNQQrqI
         1ITC+VnR/nb+3e1lTPG9/uYZ4eSd3CYuPwg71ptlUKwmKQooutWLfCxCjvkYuGdWzE
         V2ZZaX7713W03hxWC9opx5v22vgRsAW9yzgd+2BAhLGImT67qbtdg6L9BnXy/bAinB
         wUeIRALm4Al5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33339E45BE0;
        Sun, 10 Jul 2022 18:22:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v5 00/12] octeontx2: Exact Match Table.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165747732320.1773.1868461985348849288.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Jul 2022 18:22:03 +0000
References: <20220708044151.2972645-1-rkannoth@marvell.com>
In-Reply-To: <20220708044151.2972645-1-rkannoth@marvell.com>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgoutham@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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

This series was applied to bpf/bpf-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 8 Jul 2022 10:11:39 +0530 you wrote:
> Exact match table and Field hash support for CN10KB silicon
> 
> ChangeLog
> ---------
>   1) V0 to V1
>      a) Removed change IDs from all patches.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,01/12] octeontx2-af: Use hashed field in MCAM key
    https://git.kernel.org/bpf/bpf-next/c/a95ab93550d3
  - [net-next,v5,02/12] octeontx2-af: Exact match support
    (no matching commit)
  - [net-next,v5,03/12] octeontx2-af: Exact match scan from kex profile
    https://git.kernel.org/bpf/bpf-next/c/60ec39311750
  - [net-next,v5,04/12] octeontx2-af: devlink configuration support
    (no matching commit)
  - [net-next,v5,05/12] octeontx2-af: FLR handler for exact match table.
    https://git.kernel.org/bpf/bpf-next/c/799f02ef2ce3
  - [net-next,v5,06/12] octeontx2-af: Drop rules for NPC MCAM
    (no matching commit)
  - [net-next,v5,07/12] octeontx2-af: Debugsfs support for exact match.
    https://git.kernel.org/bpf/bpf-next/c/01b9228b20ad
  - [net-next,v5,08/12] octeontx2: Modify mbox request and response structures
    https://git.kernel.org/bpf/bpf-next/c/68793a8bbfcd
  - [net-next,v5,09/12] octeontx2-af: Wrapper functions for MAC addr add/del/update/reset
    (no matching commit)
  - [net-next,v5,10/12] octeontx2-af: Invoke exact match functions if supported
    https://git.kernel.org/bpf/bpf-next/c/84926eb57dbf
  - [net-next,v5,11/12] octeontx2-pf: Add support for exact match table.
    https://git.kernel.org/bpf/bpf-next/c/e56468377fa0
  - [net-next,v5,12/12] octeontx2-af: Enable Exact match flag in kex profile
    https://git.kernel.org/bpf/bpf-next/c/7189d28e7e2d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


