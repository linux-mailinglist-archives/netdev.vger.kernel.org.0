Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C734C3379
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiBXRUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiBXRUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:20:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AED029F41C
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 09:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38BB661BAD
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 17:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8ED1BC340FB;
        Thu, 24 Feb 2022 17:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645723210;
        bh=d7z6LUvoio5pbNGtmpX7S0mT81ymw66VlBI/OXExIH4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iqY9QPoqs+2likVtBPgZZ6Ov3mZqQqnx/wh5prkpfDSQMrnFbL//OkkpqbfH/8epb
         ++C4k/8AMwatiAnJkEwUnc4G/Zk2Bvn5gpq3zTPkeK9/R0A7L2lidW2dBFhOngtl0L
         ZNTWZae1joy31wDZsFpFq3iMm1ZWFQuQKnnOpoUBWHdcNN2C1j2cdNJT0snPgQpoPQ
         Hokn6jKqTnyZOEvrJmm77qljhYkclZX81iJaLQQKaeHJVZ9wr7RaKInv04+RMO2ULc
         uRq7gmTYoR+DY975bihYW+mQIeyFOGcaI5NrTHK0BpwmSDb/lCMpirjI9GZxRRftcW
         q34dnR8QgZ1/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7163FF03839;
        Thu, 24 Feb 2022 17:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ipv6: prevent a possible race condition with lifetimes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164572321046.7006.13558166524967233977.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Feb 2022 17:20:10 +0000
References: <20220223131954.6570-1-niels.dossche@ugent.be>
In-Reply-To: <20220223131954.6570-1-niels.dossche@ugent.be>
To:     Niels Dossche <dossche.niels@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        niels.dossche@ugent.be
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 23 Feb 2022 14:19:56 +0100 you wrote:
> valid_lft, prefered_lft and tstamp are always accessed under the lock
> "lock" in other places. Reading these without taking the lock may result
> in inconsistencies regarding the calculation of the valid and preferred
> variables since decisions are taken on these fields for those variables.
> 
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Niels Dossche <niels.dossche@ugent.be>
> 
> [...]

Here is the summary with links:
  - [net,v2] ipv6: prevent a possible race condition with lifetimes
    https://git.kernel.org/netdev/net/c/6c0d8833a605

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


