Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EDF5E70BF
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 02:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiIWAkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 20:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiIWAkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 20:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8C99E2D7;
        Thu, 22 Sep 2022 17:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72AE76235F;
        Fri, 23 Sep 2022 00:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BCC35C433B5;
        Fri, 23 Sep 2022 00:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663893616;
        bh=13EVSZS5FYRrqSVbHrO/HLwp4UpHOU5Audrge3bRExo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nnYwyKPkO1eOjJTgbx7qYq1WGj6nffroXV0urp+DkRzwmz7AD/kTSCY/vEINAalPZ
         +wRi4wEBtzSVAcprou191yDfjv3ic/uYNpHE/isPI24xxmtPX87zX7FdieZzK5rWdX
         3DkqV6hna59A6SYvGEDRmOM/X8nzos0Ib5Vt/2slTg2WUZBiR4i9p1PFCb5duQu5ys
         9+H2BIGBGbJSGnZYaMHUEZD/e/BbFaHNBRiVtQJbd7lICIwwc/fVdBkcv5w7KonwBy
         G/37eWW0BueGA1+yIlYSS7Aog3qtiauymnjyzxvc4f5cPlXjREzNyajhfQC1XmED5k
         amdoddCEYZqSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98FE0E4D03F;
        Fri, 23 Sep 2022 00:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: taprio: remove unnecessary
 taprio_list_lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166389361662.358.9640095235761157374.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 00:40:16 +0000
References: <20220921095632.1379251-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220921095632.1379251-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 21 Sep 2022 12:56:31 +0300 you wrote:
> The 3 functions that want access to the taprio_list:
> taprio_dev_notifier(), taprio_destroy() and taprio_init() are all called
> with the rtnl_mutex held, therefore implicitly serialized with respect
> to each other. A spin lock serves no purpose.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/sched: taprio: remove unnecessary taprio_list_lock
    https://git.kernel.org/netdev/net-next/c/a2c2a4ddc27d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


