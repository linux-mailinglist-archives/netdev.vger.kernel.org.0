Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662D26C621F
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 09:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjCWImG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 04:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbjCWIlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 04:41:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27391A49A
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 01:40:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF2AEB81FE7
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82D89C433A1;
        Thu, 23 Mar 2023 08:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679560820;
        bh=BkgkqhpiUMyLlYU7TqdOmrhP1hQxGHQQZwIkf8I1aLg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=unECyf7M+nkeLZdfRWsDm3hp8iy749WmAdiOFJ+mIu3iTJC0MYy9iTJW/GTD6kcLi
         z8Um/0Fku4rDhSZ8zi+4HvPFKMfwqet431gp4sH7jY5sh1MaiJklWsYEbIRl66VByg
         HRW70dOKPqZthx9NCLJEppUm46U7hd84BIjqlnHHxplwnNuT67YIER61F3vDV/PITk
         BgioW554Uhtxs4c5LoS250sAitrNcQKkqfh6jDgsf3zKQT7cUWyt1kV9QeGi7NjXuN
         B9ZNVxmiVeKdeLmUYyjxjYyqtqw92NaDW66vFXHvUbtAgk40xDbiQGh+9DSDvj52g2
         8czVJF/Rrl73w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 686D9E61B88;
        Thu, 23 Mar 2023 08:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net/sched: act_api: use the correct TCA_ACT
 attributes in dump
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167956082042.32268.16682063594078687002.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 08:40:20 +0000
References: <20230321223345.1369859-1-pctammela@mojatatu.com>
In-Reply-To: <20230321223345.1369859-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, simon.horman@corigine.com,
        haliu@redhat.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 21 Mar 2023 19:33:45 -0300 you wrote:
> 4 places in the act api code are using 'TCA_' definitions where they
> should be using 'TCA_ACT_', which is confusing for the reader, although
> functionally they are equivalent.
> 
> Cc: Hangbin Liu <haliu@redhat.com>
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net/sched: act_api: use the correct TCA_ACT attributes in dump
    https://git.kernel.org/netdev/net-next/c/fcb3a4653bc5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


