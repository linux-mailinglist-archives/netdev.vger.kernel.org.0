Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEC05735EC
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 14:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbiGMMAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 08:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbiGMMAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 08:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB12410400E;
        Wed, 13 Jul 2022 05:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB08FB81D07;
        Wed, 13 Jul 2022 12:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EF60C3411E;
        Wed, 13 Jul 2022 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657713614;
        bh=7ZQv/4gcKwMxrWQ3R8K+5GmEoZGtx+9WTQW4h7AZojo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cNbCcC9IopFfBuw7A3T2mCSim7+evprYZO/9ddqN3WbI0UxVCBjsCRxcTmciyL1Ht
         75f85sBaZ1xWAilvt6v9GzewmGAZ8+CkFL26gjUGzYABjPIuPvb7bLL4szRHTDliOl
         T4ujPozUJcBPAe9J+XKiqlv9Kb9MHed+zRqtuzGzigq5Z23OZfc+bv/63m2w5XLg/G
         kXJx6k8PQPAHWtPsGslzIEv+ojuTvjaCqF9eHJ1KfyFYS3MlVzqU/2A28fLvagje0k
         +YiisZSVowUtJd7roVoEjOuHWvH1ZyfrVIY8CFHruawN6SpAqOE1bVvArF8z5vFKjp
         j7jOKHvfjtF1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 51DCBE45223;
        Wed, 13 Jul 2022 12:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] net: prestera: add support for port range
 filters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165771361432.14728.4361651412076279677.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 12:00:14 +0000
References: <20220711150908.1030650-1-maksym.glubokiy@plvision.eu>
In-Reply-To: <20220711150908.1030650-1-maksym.glubokiy@plvision.eu>
To:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, louis.peens@corigine.com, elic@nvidia.com,
        simon.horman@corigine.com, baowen.zheng@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 11 Jul 2022 18:09:06 +0300 you wrote:
> This adds support for port-range rules in Marvel Prestera driver:
> 
>   $ tc qdisc add ... clsact
>   $ tc filter add ... flower ... src_port <PMIN>-<PMAX> ...
> 
> Maksym Glubokiy (2):
>   net: extract port range fields from fl_flow_key
>   net: prestera: add support for port range filters
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: extract port range fields from fl_flow_key
    https://git.kernel.org/netdev/net-next/c/83d85bb06915
  - [net-next,v2,2/2] net: prestera: add support for port range filters
    https://git.kernel.org/netdev/net-next/c/551871bfc82c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


