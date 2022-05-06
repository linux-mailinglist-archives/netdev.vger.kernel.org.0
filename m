Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E61451CE8C
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387846AbiEFBYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387839AbiEFBX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:23:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C50419D
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 18:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD39762023
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 01:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F088C385B5;
        Fri,  6 May 2022 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651800015;
        bh=kGdEq/FNJBhtqmjzibO9QDEiWqzQqYGySzfwOF9ATS4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rH/fHozEmyVa+6vWTLq/AonDAzCgIFM1a8cxKSFhtQRtK7YsTKLaWQdQhxP3lal/A
         4hYVJFEUd9IWtWHFXh55Em1r8uhCwLdy0kik/bytWpam/W2XdUuLF9gjw/RiW+x06b
         mxeNUpqludoNKtTNT1pjRdt6/1iqRXM5XIsf89BcvHewGHdPkS8nspRruheDmifheQ
         C2E+nqKQIpikH4abzKu6cxlpTw4tWr4sZ7Ag6QafFiofp3uOb6wVL57JPCQiFEW1vB
         PNhkaw893B8Bf8eq9V+zJoKoEwDpwScqMi67L0fFEq4Tjd/J3CSEAjP4dYahgLQVho
         bYvv79VCuX+Hw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0CFC3E8DBDA;
        Fri,  6 May 2022 01:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "Merge branch 'mlxsw-line-card-model'"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165180001504.16316.12147367518416012413.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 01:20:15 +0000
References: <20220504154037.539442-1-kuba@kernel.org>
In-Reply-To: <20220504154037.539442-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, idosch@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 May 2022 08:40:37 -0700 you wrote:
> This reverts commit 5e927a9f4b9f29d78a7c7d66ea717bb5c8bbad8e, reversing
> changes made to cfc1d91a7d78cf9de25b043d81efcc16966d55b3.
> 
> The discussion is still ongoing so let's remove the uAPI
> until the discussion settles.
> 
> Link: https://lore.kernel.org/all/20220425090021.32e9a98f@kernel.org/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "Merge branch 'mlxsw-line-card-model'"
    https://git.kernel.org/netdev/net-next/c/c4a67a21a6d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


