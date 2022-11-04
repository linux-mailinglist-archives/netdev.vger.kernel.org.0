Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E1F618F73
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiKDEUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKDEUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1ECA2124C;
        Thu,  3 Nov 2022 21:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D6176203F;
        Fri,  4 Nov 2022 04:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA006C433D7;
        Fri,  4 Nov 2022 04:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667535616;
        bh=u8Du8iYv9DT4erIL/3kLesz/9/0WGIRa7JowWxouDQg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QKKTLkdvmEU9p+5Ffk3gmA/ub7h4m24JbENKkIDw+eTjbm1rpDRAge7M+GgBPENyR
         0icgEdg5gBqSzIU9506LopHeoSuQSORN/MGXxh6DzWsupHZE17/apH6KXsMBvXvJ8k
         ePupV5qJHsjkHsiShx8lqysPwdqLLA58ONvosG1TKFa2H0u1fA0HoMviX8gsvrN2xV
         URdCPhrcvQmHPGsbbRy9RZOXGCvEm27cGtUh/cnXJ/9KgmccJIdKe7E9BcKRmTs8/x
         x+z2TJO1p1XBfhG/14Ow494DvkSu0StYy7NBpT1o8v26/JF5r6uMz+oW/nonhyWaPD
         OhR85piXrl+Mg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 846E7E270E2;
        Fri,  4 Nov 2022 04:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2022-11-03
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166753561653.10149.11930255438949716932.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 04:20:16 +0000
References: <20221103125315.04E57C433C1@smtp.kernel.org>
In-Reply-To: <20221103125315.04E57C433C1@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  3 Nov 2022 12:53:14 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2022-11-03
    https://git.kernel.org/netdev/net/c/91018bbcc664

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


