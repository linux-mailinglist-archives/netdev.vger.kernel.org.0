Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D655E7202
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 04:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbiIWCke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 22:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiIWCkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 22:40:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320DF923E9;
        Thu, 22 Sep 2022 19:40:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7969B829EC;
        Fri, 23 Sep 2022 02:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BB9DC43470;
        Fri, 23 Sep 2022 02:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663900820;
        bh=1+HE4F2+hYNsEeWhIanwznM5q0fte0nsniEHKEwpY+4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RDfpNQKRTmBrD2zAJO1MDWPgseyqSIEAXQYtWyJWV9uiG8NFrEZJKjOxBHiTRwBhU
         tgj8JoCfm8Xh8K0muBHJHTE8DX04iTCMMNEnZwIzuH4zZIFXNASSrOStj6PsTXWJcn
         Hnd0v6SjTGEDyEXmt+pPo1rHqb+sp0FJcsGYOUgirndXdZCv7r8K8+g07TOnxVzyZn
         uW6omtFxE7iW4EFlAUn+GKPnzKvhNFcfLNBBZUmkklqV3LXZk1SPLJT7XSDAN3FSVL
         aXaVeRoFSA1FIn+BUzudKCqq31aKKPnwqNOxy3Vw6Qt6nTzOD4otEDrnnrZY53I+f1
         8rH9WCPWoqL8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 440A5E4D03C;
        Fri, 23 Sep 2022 02:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 1/1] ptp_ocp: use device_find_any_child() instead of custom
 approach
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166390082027.27582.16975289666549853165.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 02:40:20 +0000
References: <20220921141005.2443-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20220921141005.2443-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     jonathan.lemon@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vadfed@fb.com,
        richardcochran@gmail.com
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

On Wed, 21 Sep 2022 17:10:05 +0300 you wrote:
> We have already a helper to get the first child device, use it and
> drop custom approach.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/ptp/ptp_ocp.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)

Here is the summary with links:
  - [v1,1/1] ptp_ocp: use device_find_any_child() instead of custom approach
    https://git.kernel.org/netdev/net-next/c/304843c7ac44

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


