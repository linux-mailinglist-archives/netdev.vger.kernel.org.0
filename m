Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173F96BAAA3
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjCOIU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbjCOIUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:20:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6CE591FF;
        Wed, 15 Mar 2023 01:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43150B81D8B;
        Wed, 15 Mar 2023 08:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F117FC4339B;
        Wed, 15 Mar 2023 08:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678868421;
        bh=+yo6va50VFljRx9yw4IImw/EexK/kygDiGhr5xKRzHs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P91GuPwsDZ2cuRabk9BdKDvpnmdIB6k+IT6+YhGFAjQTq0RaZgIudDa7rQMT2J3V/
         CjyNcqWO5THk/wnOrTWxdKD52BtriBdiMPt6UIfaDYVdwWuyJRiymh1fl5YibIJmw7
         82988lEqF3OSZk5I752fm1raT7Hkg8nbNoYo8+y1wVQqJAqGxY0Q8PzGeVSRx9uyXb
         200IxmXDaeZBOMTc1M/8j3FBpggvb+vlsKIMEJ4lguzYZyW3dtp6iycyHwjmip89pX
         wRE5/tIiikLI9FHM4y2Fx4/wjg9IEwEUmyEszz/EJQqHz+ZYcJM3jPqhrGg2m3stSa
         i7hQpdTH7q1aw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9EB5E52532;
        Wed, 15 Mar 2023 08:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] smc: Updates 2023-03-01
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886842088.29094.16124554092676505653.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 08:20:20 +0000
References: <20230313101032.13180-1-wenjia@linux.ibm.com>
In-Reply-To: <20230313101032.13180-1-wenjia@linux.ibm.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        hca@linux.ibm.com, kgraul@linux.ibm.com, wintera@linux.ibm.com,
        jaka@linux.ibm.com, raspl@linux.ibm.com, tonylu@linux.alibaba.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Mar 2023 11:10:30 +0100 you wrote:
> The 1st patch is to make implements later do not need to adhere to a
> specific SEID format. The 2nd patch does some cleanup.
> 
> Stefan Raspl (2):
>   net/smc: Introduce explicit check for v2 support
>   net/ism: Remove extra include
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net/smc: Introduce explicit check for v2 support
    https://git.kernel.org/netdev/net-next/c/f947568e2580
  - [net-next,2/2] net/ism: Remove extra include
    https://git.kernel.org/netdev/net-next/c/298c91dc40e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


