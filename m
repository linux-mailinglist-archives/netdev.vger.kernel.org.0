Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7409C58B354
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 04:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241639AbiHFCA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 22:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241595AbiHFCAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 22:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AAA1082
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 19:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42004B82B00
        for <netdev@vger.kernel.org>; Sat,  6 Aug 2022 02:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDD49C433B5;
        Sat,  6 Aug 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659751215;
        bh=YbVhrt9J/yvNayPVU5J1z+GqJ+1XOJjcl7TC5yN1WZE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tyU80Vha90quApWYdqZhUeQgNPFpOeWn/pks2C8Oo08GC2rqcRMx4jF5Qwusmp4QA
         yQlvLfQY/OqYDYK2HQlL5H/Ghp60SCUpG+Hy21swd6wSRGQeQQFVCClwV1mwsUElLT
         Lz3ZrquILGnF9PJHpgDpxxgtsfz97WXPCUuOBNq8/x1w3MBecyG5l3CsHEAHF9KgS9
         TLo+WUtoeHYbBJ70WkaBcltgnXzHdfqqgsfBGz9DXDfQS1ie0mEvHPoCaXl0vtji7a
         4iZpbgosv5YFTVBNthMKpM+FuaU2NVbIs77OVItyb1+M6WaQDhTBrrGvQNKoEFejFy
         OEmSnQQV//etQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B3ADAC43140;
        Sat,  6 Aug 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: Update ibmveth maintainer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165975121572.22545.734294955087814195.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Aug 2022 02:00:15 +0000
References: <20220803155246.39582-1-nnac123@linux.ibm.com>
In-Reply-To: <20220803155246.39582-1-nnac123@linux.ibm.com>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  3 Aug 2022 10:52:46 -0500 you wrote:
> Add Nick Child as the maintainer of the IBM Power Virtual Ethernet
> Device Driver, replacing Cristobal Forno.
> 
> Signed-off-by: Nick Child <nnac123@linux.ibm.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - MAINTAINERS: Update ibmveth maintainer
    https://git.kernel.org/netdev/net/c/8a5dfc28af9a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


