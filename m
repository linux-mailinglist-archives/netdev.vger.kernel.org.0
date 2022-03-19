Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CA44DE604
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 05:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242134AbiCSEvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 00:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241900AbiCSEvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 00:51:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA43393ED;
        Fri, 18 Mar 2022 21:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92D7460BA5;
        Sat, 19 Mar 2022 04:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF3E0C340F3;
        Sat, 19 Mar 2022 04:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647665410;
        bh=Wia9h0kro9w5M8zRQMzT6WKW5JZ0MKe/hbIX+WdEhdM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V0bF5pWoGpOgPrQJjEXwYJTUgUbwC7z3JwzpQLsa0M+hulkObk64J6TBEoGe/jFrp
         2uKQ76Pzful3np5vP8po8zlB6IQIPZtsUDeTasT/RJTQtd/jLMQCjGHuAcuG9fegct
         JV8fZfYz/LhHbx4TMAVUsWQo8mvisj7sAgXOBq1nqO1zsVu8Azg7uYeDPo2K1FUZUF
         CY0w107y6wLEVLoIwZY71+S7tMp1A2Z8dadX3jXk7BL6X85M4nnZlEJJcyHpW09pUW
         6cP41ShJUNvW6+uKuz40xVTf8r91YExg/vuFQIMuNWJsbuoZy1JpSE/rKxDKcPlTOa
         IbKJkAD8U1WVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4BA2F03842;
        Sat, 19 Mar 2022 04:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] ptp: ocp: use snprintf() in ptp_ocp_verify()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164766541080.28065.6549943859608107838.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Mar 2022 04:50:10 +0000
References: <20220318074723.GA6617@kili>
In-Reply-To: <20220318074723.GA6617@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     jonathan.lemon@gmail.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Mar 2022 10:47:23 +0300 you wrote:
> This code is fine, but it's easier to review if we use snprintf()
> instead of sprintf().
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: re-spin the patch based on the latest tree.  It turns out that the
> code is not buggy so don't make the buffer larger and don't add a Fixes
> tag.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] ptp: ocp: use snprintf() in ptp_ocp_verify()
    https://git.kernel.org/netdev/net-next/c/d5f497b88979

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


