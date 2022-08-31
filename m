Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3703E5A86F6
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiHaTuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiHaTuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EB245062;
        Wed, 31 Aug 2022 12:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 007626192C;
        Wed, 31 Aug 2022 19:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 409FFC433C1;
        Wed, 31 Aug 2022 19:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661975415;
        bh=CwC31PL9899CHPuWsFZ4q787QaQZMEcghhKVzhRL9uA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j2cnR9nb3gQPKAPASfHrnqXNz6J6tJIZQdj+VcB94ekv3iD9vtBruaHgTjxWim+wa
         9kCQ9UouT9P25sSdRrD59fOy71iHzPkoCf3RtYGWfKJbhWgtpyyPV2/3E7xK7h0YSe
         rhGoHis06prcYhEAWwxDaqwyVuNXFDrz+ruQ5QOByRJhrfIYCkjbDfN4bQE621VNzn
         H29f0v6qPOBOhw32iMBZ3B+o04n7kiT/ZH34tMPV2KHLeXnX9jEwNmng+96OAVbuEU
         0Y/vmuUPJsgWoTwM5Vvt+RAzSPA+GvQRRWpaypRNTFy5pprEtTTySFrazr3PHEnBna
         uZOK/LiSlJvkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 232EDC4166F;
        Wed, 31 Aug 2022 19:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Documentation: networking: correct possessive "its"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166197541513.20889.3530530600911600939.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 19:50:15 +0000
References: <20220829235414.17110-1-rdunlap@infradead.org>
In-Reply-To: <20220829235414.17110-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-doc@vger.kernel.org, corbet@lwn.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, jiri@nvidia.com
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

On Mon, 29 Aug 2022 16:54:14 -0700 you wrote:
> Change occurrences of "it's" that are possessive to "its"
> so that they don't read as "it is".
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Cc: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - Documentation: networking: correct possessive "its"
    https://git.kernel.org/netdev/net/c/404a5ad72011

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


