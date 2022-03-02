Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412E14CACC1
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 19:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244350AbiCBSBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 13:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244343AbiCBSA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 13:00:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8F6CA736;
        Wed,  2 Mar 2022 10:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 095FE60ACC;
        Wed,  2 Mar 2022 18:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B089C36AE9;
        Wed,  2 Mar 2022 18:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646244011;
        bh=v/COIc+X+EM2q8D/TuV93XKDdU5ewdBka72ch/RrZP4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S4PLV395wr0JXJoyENgV2quWokBxSRSK9PNrpotPqwzpBAp14YIFBBJI6DvXl+9o6
         HBIT/bEuTg1PyaCGjuzXYDgGhIc0GtrQHBX/TOMq3ZFmkHE50e9bhiFi5mQQvKrWqn
         l4KgQN4PF7bNs/SWuz4QINPIcC8pGvG4wiWAjF4MueVWzFp7gDR+A7pQOHJXJ1Mvnr
         FnulFn1+QUzXBPf+wGthpLkz2PzI6h9I3aC8yTEZHO50B22rjuS0PhkjH5kTyZ6gH3
         GWsy+VLckeUwWHpNVykN2aIFTJBglml/4vdudb0rzK8+EGhvgda9+Uagm5puPB7+Hk
         s+L7AX+Pte5gg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 45E49E6D44B;
        Wed,  2 Mar 2022 18:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hamradio: fix compliation error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164624401128.29389.5358685462275620570.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Mar 2022 18:00:11 +0000
References: <1646203277-83159-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1646203277-83159-1-git-send-email-wangqing@vivo.com>
To:     Qing Wang <wangqing@vivo.com>
Cc:     jreuter@yaina.de, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  1 Mar 2022 22:41:14 -0800 you wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> add missing ")" which caused by previous commit.
> 
> Link: https://lore.kernel.org/all/1646018012-61129-1-git-send-email-wangqing@vivo.com/
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> 
> [...]

Here is the summary with links:
  - net: hamradio: fix compliation error
    https://git.kernel.org/netdev/net-next/c/a577223a97df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


