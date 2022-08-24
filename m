Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7E459F5CF
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 11:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbiHXJAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 05:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbiHXJAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 05:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2004A4E84F;
        Wed, 24 Aug 2022 02:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9E2AB8238F;
        Wed, 24 Aug 2022 09:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79ED6C433D7;
        Wed, 24 Aug 2022 09:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661331617;
        bh=pLVCx13ITieI3fq1FFMfOLXjtbLgufn9497mkH0nEuc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SJerzTaMktaYW+/+oO42SHfH23OumBYzXN2m5nF6rc+7xvlYaRS+L271SWEMk/jM+
         Qxy44jW3KyZbHcmvoe9nTzXU1/0niTw0GMtZCoLTtH41MVGl+Nb72zrBGOXIu5CdfJ
         /4gV8kaJ/ShLw8Kb3n2Lte4EQJu/0LdzpSoGEdi7h7SzEBUeDYPjJ4Y1vbjH9edHo2
         TNkcrXldCw3Exzo5I+4jqk30iSC5RLA6EU/SRJaVmiJm2ljsiZmQfuloQlx4zY6N4C
         GpRYOxk54an5Sl0EnMepoRIuHK+8yV42ZNNYvHQqSflj+a5vhxJRtGp6h4yV3qO9xW
         FKaJ3muuBBwOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6612BE1CF31;
        Wed, 24 Aug 2022 09:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5] net: skb: prevent the split of kfree_skb_reason()
 by gcc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166133161741.23661.3276364041204544927.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 09:00:17 +0000
References: <20220821051858.228284-1-imagedong@tencent.com>
In-Reply-To: <20220821051858.228284-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     kuba@kernel.org, miguel.ojeda.sandonis@gmail.com,
        segher@kernel.crashing.org, ndesaulniers@google.com,
        ojeda@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 21 Aug 2022 13:18:58 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Sometimes, gcc will optimize the function by spliting it to two or
> more functions. In this case, kfree_skb_reason() is splited to
> kfree_skb_reason and kfree_skb_reason.part.0. However, the
> function/tracepoint trace_kfree_skb() in it needs the return address
> of kfree_skb_reason().
> 
> [...]

Here is the summary with links:
  - [net-next,v5] net: skb: prevent the split of kfree_skb_reason() by gcc
    https://git.kernel.org/netdev/net-next/c/c205cc7534a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


