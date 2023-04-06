Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDFA6D8CAD
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbjDFBUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDFBUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E890C3C32
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 18:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81987642B9
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 01:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4B24C4339B;
        Thu,  6 Apr 2023 01:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680744017;
        bh=Vn1R4hy/F7135UY9+SD+y7mcEUBlhNsHFW89VhCZwBI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=keZAExbV5g0rYptqzKkmQXzfkTR7w97bh/qf5iXhIEgtK6dS/lLz+n+P9zpXzl6pI
         l/iYT1HQJ48Ougtzta+BNTR0Xl38QTKRzc2DoYj+SeJp8T2WkzH4YHZo5RKH7pdFbo
         B1wvpuB3pnOESL2uj/fCpPDzbBuUCaWrurj68aqfEi+nAJK8IKAibiVljdXXuO5pzH
         GF3dwdIP47CsEdMv7Mc9xSyb77xnI5KwXQ1CMfvuqFB7lKyqzyqYHXQ+S2jR8otpPu
         BHQwgKlWjGWtC5y4Z1UBSXH5CJ4q/ItOl3wFTMaH6sxqmzF168RupCnkpLwY0ESehL
         4CEvAOwkB3LIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B655BC395D8;
        Thu,  6 Apr 2023 01:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: sch_mqprio: use netlink payload helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168074401774.24882.44168637009370038.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 01:20:17 +0000
References: <20230404203449.1627033-1-pctammela@mojatatu.com>
In-Reply-To: <20230404203449.1627033-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Apr 2023 17:34:49 -0300 you wrote:
> For the sake of readability, use the netlink payload helpers from
> the 'nla_get_*()' family to parse the attributes.
> 
> tdc results:
> 1..5
> ok 1 9903 - Add mqprio Qdisc to multi-queue device (8 queues)
> ok 2 453a - Delete nonexistent mqprio Qdisc
> ok 3 5292 - Delete mqprio Qdisc twice
> ok 4 45a9 - Add mqprio Qdisc to single-queue device
> ok 5 2ba9 - Show mqprio class
> 
> [...]

Here is the summary with links:
  - [net-next] net/sched: sch_mqprio: use netlink payload helpers
    https://git.kernel.org/netdev/net-next/c/8b0f256530d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


