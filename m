Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07D66BE03B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 05:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCQEka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 00:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCQEkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 00:40:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2F727D6E;
        Thu, 16 Mar 2023 21:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AAAEB82449;
        Fri, 17 Mar 2023 04:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2424C4339C;
        Fri, 17 Mar 2023 04:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679028019;
        bh=Hv0O98FHMJMlf9hVnLnggH9Zq/u9yD2dvLMndkSVZfE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ionWvsmCG2DOuWe79gxKqB7deTH7OGXLLKD2BoZVza5jnRCb9R5278G0GXET9n+Jn
         BZqMvUhnpTpupxRSV//5kg70TFZJRvbzLkxoxb7TTi9J/zAp0DaJKyrQS2WUNQmDCr
         iGatIHLp+kEO2m+P9fB+bGdYzdKaRMqPNGyrqlrUqMJCO60Mfqw6U/xQVZCxvtHzpO
         4M2kmLqjEvL0bg75IGUgXWmVwPcHylPyoDWFS0GSECKvKXWmCm86H5inCrOl7QJGy8
         4mcwmu4moyAfbcojcuJjoJlaSLHUUArN5wSMXzf41zzM3b+/WRJ/zs8MR3IV27lkuY
         QLTPyVCJQjdGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C4E0E2A03A;
        Fri, 17 Mar 2023 04:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: xdp: don't call notifiers during driver init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167902801950.7493.7591082991842203309.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 04:40:19 +0000
References: <20230316220234.598091-1-kuba@kernel.org>
In-Reply-To: <20230316220234.598091-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, lorenzo@kernel.org,
        tariqt@nvidia.com, bpf@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Mar 2023 15:02:34 -0700 you wrote:
> Drivers will commonly perform feature setting during init, if they use
> the xdp_set_features_flag() helper they'll likely run into an ASSERT_RTNL()
> inside call_netdevice_notifiers_info().
> 
> Don't call the notifier until the device is actually registered.
> Nothing should be tracking the device until its registered and
> after its unregistration has started.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: xdp: don't call notifiers during driver init
    https://git.kernel.org/netdev/net/c/769639c1fe8a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


