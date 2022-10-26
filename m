Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9F060D97E
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 05:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiJZDAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 23:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbiJZDAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 23:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC3737195;
        Tue, 25 Oct 2022 20:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0CE4B82011;
        Wed, 26 Oct 2022 03:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E754C43470;
        Wed, 26 Oct 2022 03:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666753216;
        bh=r2FvViBei9qOOo9bC6zCzVR7mO/2AW2UOaMHseaf2nM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T2h+io34A4LiRVf7yXiFYr7EKu44JRY3ItTtVt528JrtoCLkqX5WYkWJYoCNmFIrZ
         1pPtgV3Xa9F9COpVTVE6vtkyggzE9gO42T/8A+cCaqaTlYZ19zB6jm8cPUjMtvcZa5
         KQwPzyvbBv7Z2lGQU9WzLUDDSZmddCQgLFQgN/l10hZ0/gaUmoCRz1V/bqOAWpEi0N
         QQgjAJoUkvt3QUC3COxHlAvnKFXXhq8FfZfzYSrV0XQmZ4/lQkL3gHS7jZACfuZs7+
         W25She/zlDVGhn0BHT2CPJMl3r6B6/+qKQEOa+E4ZwRddcN+PFRNPONdZ/6EmRKoOB
         PiQRoEeGXHyPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 52FF2E29F32;
        Wed, 26 Oct 2022 03:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipa: don't configure IDLE_INDICATION on v3.1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166675321633.7735.14430255714313842833.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Oct 2022 03:00:16 +0000
References: <20221024234850.4049778-1-caleb.connolly@linaro.org>
In-Reply-To: <20221024234850.4049778-1-caleb.connolly@linaro.org>
To:     Caleb Connolly <caleb.connolly@linaro.org>
Cc:     elder@linaro.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jami.kettunen@somainline.org,
        elder@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 25 Oct 2022 00:48:50 +0100 you wrote:
> IPA v3.1 doesn't support the IDLE_INDICATION_CFG register, this was
> causing a harmless splat in ipa_idle_indication_cfg(), add a version
> check to prevent trying to fetch this register on v3.1
> 
> Fixes: 6a244b75cfab ("net: ipa: introduce ipa_reg()")
> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
> 
> [...]

Here is the summary with links:
  - net: ipa: don't configure IDLE_INDICATION on v3.1
    https://git.kernel.org/netdev/net/c/95a0396a0642

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


