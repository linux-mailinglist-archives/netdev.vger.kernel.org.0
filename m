Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE08679001
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbjAXFk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbjAXFk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:40:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2D6305FE;
        Mon, 23 Jan 2023 21:40:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10FB261177;
        Tue, 24 Jan 2023 05:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 602ADC433A0;
        Tue, 24 Jan 2023 05:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674538826;
        bh=qvg+AcmvVF7mUQYijwMRQBPynWwrabBv7d+Ecn7H4DQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W/22PdFMyhCboxEhkAIMdM3l6v3pPUdec0biDZdcKxw/9sKej8gWsRzXmHcI/pviu
         zD42HcSTRuyokV1GLHiongtHhY4eMx4ha+dv5Q7VqzUtRfq0pdFPcaeGBqP4uA8fsi
         7jU2Sod+PGrary5Veej8O1y9NghIfMYd3lunPfjFdoCxLJTyY3js7ZiKJtIybMTEpF
         xo1FS8xObvnYe3tlq5lejB5dVqXwGQBOCLLea90qhZneQDFGjiIAOMzsh303WACtgA
         qfJCCgQ/rVJJkF+lcX06kQE96KDGm9KiwUR4wk47vNhYjJ0zNb7XqhtQ9yLR1GZOBy
         ZYPOdaWH4okhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 45997F83ECD;
        Tue, 24 Jan 2023 05:40:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: microchip: sparx5: Fix uninitialized variable
 in vcap_path_exist()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167453882627.30916.10967773161306261455.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 05:40:26 +0000
References: <Y8qbYAb+YSXo1DgR@kili>
In-Reply-To: <Y8qbYAb+YSXo1DgR@kili>
To:     Dan Carpenter <error27@gmail.com>
Cc:     lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, horatiu.vultur@microchip.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
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

On Fri, 20 Jan 2023 16:47:12 +0300 you wrote:
> The "eport" variable needs to be initialized to NULL for this code to
> work.
> 
> Fixes: 814e7693207f ("net: microchip: vcap api: Add a storage state to a VCAP rule")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> Probably you had CONFIG_INIT_STACK_ALL=y in your .config for this to
> pass testing.
> 
> [...]

Here is the summary with links:
  - [net-next] net: microchip: sparx5: Fix uninitialized variable in vcap_path_exist()
    https://git.kernel.org/netdev/net-next/c/3bee9b573af5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


