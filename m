Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C1F5E7C93
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 16:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbiIWOLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 10:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbiIWOKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 10:10:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF91EE664;
        Fri, 23 Sep 2022 07:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C0E76CE24E7;
        Fri, 23 Sep 2022 14:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2BCD3C433C1;
        Fri, 23 Sep 2022 14:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663942215;
        bh=RCxptDXU8HCZ1mcOVvAGrWiCCf/8eHMkemxHICWAP+0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MncRIXGX/S3mGugKtrw+VfBQ++LLqMd5c7ULiZqmYgOsqTy7b2ro1LeNlGo+00mt4
         YGcRDSTsFEU1B7HhpbO6RbsOGvISk9JwpP4HI60XxfxvcSyjWOZVw7c+dbAUy8z0Bi
         2rFlhyYxdCC0tOZCUWinsuY1yCIDb8hbIcIQup1dkE0vSsC4q7ckr7hh1EKokl0oeg
         GPyTPknxb06QLEFvGR1F6/7/U1YB9u1CAG3NS1RtIQQa1iLL4aOuG6LA2+6uEOpWx6
         sJuxMOZq5TX4jLanespQmYaxqVTUnuDGWW5UNXzoYTPePFJPPA9c7hq8y/DEMUmdIf
         YsAqQMSJ3NwBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08381E4D03A;
        Fri, 23 Sep 2022 14:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] net: mt7531: pll & reset fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166394221502.18573.7555903251873086373.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 14:10:15 +0000
References: <20220917000734.520253-1-lynxis@fe80.eu>
In-Reply-To: <20220917000734.520253-1-lynxis@fe80.eu>
To:     Alexander 'lynxis' Couzens <lynxis@fe80.eu>
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, dqfext@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        landen.chao@mediatek.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 17 Sep 2022 02:07:32 +0200 you wrote:
> v1 -> v2:
>  - commit message: add Fixes: tag
>  - add missing target branch in subject
> 
> Alexander Couzens (2):
>   net: mt7531: only do PLL once after the reset
>   net: mt7531: ensure all MACs are powered down before reset
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net: mt7531: only do PLL once after the reset
    https://git.kernel.org/netdev/net/c/42bc4fafe359
  - [net,v2,2/2] net: mt7531: ensure all MACs are powered down before reset
    https://git.kernel.org/netdev/net/c/728c2af6ad8c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


