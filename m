Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32AF4BA639
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 17:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243362AbiBQQk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 11:40:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243357AbiBQQkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 11:40:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B71C2B2FFE
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 08:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 086D161702
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 16:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69E8DC340F4;
        Thu, 17 Feb 2022 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645116010;
        bh=mgOt4vKNXMFZhYDeX6ivqlgnI/XWHddl1nQrGCrVXFU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qm+ELpL+X++irvvYPygnzcOmQEvhIlxFVFZOpSJaA7O337XYIkftyM0IWITvQQIWE
         U+zIVqb/h3dPjaG2Y8g7kLNnHodeIz5j8ByUDzSADCjnqQOARdYqVYDHI5qo8Yx8Lw
         oWsehqOW/jIFHTpyyt3390wh+nHVtyH8826iurLv4Qj/udKyRUAanCxAOZUE4+iFiO
         POROTd7bjyZDgTH+iFo18BG5nUojw4Yde/HfwiyyHj04qL3V9xpk3KQFQQq7VXrlQY
         9//XHJmYMTO4C6hKhApgvSqLweepxmc3ouR2ROB5cPxmFH+tFNDp7YkUE8cITI3Oqx
         uV8wkwiYpTNCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4FE8FE7BB03;
        Thu, 17 Feb 2022 16:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] net: transition netdev reg state earlier in
 run_todo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164511601032.3440.7516787503708839548.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 16:40:10 +0000
References: <20220215225310.3679266-1-kuba@kernel.org>
In-Reply-To: <20220215225310.3679266-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        lucien.xin@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Feb 2022 14:53:09 -0800 you wrote:
> In prep for unregistering netdevs out of order move the netdev
> state validation and change outside of the loop.
> 
> While at it modernize this code and use WARN() instead of
> pr_err() + dump_stack().
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: transition netdev reg state earlier in run_todo
    https://git.kernel.org/netdev/net-next/c/ae68db14b616
  - [net-next,2/2] net: allow out-of-order netdev unregistration
    https://git.kernel.org/netdev/net-next/c/faab39f63c1f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


