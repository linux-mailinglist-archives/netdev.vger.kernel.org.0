Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64774B11DC
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243708AbiBJPkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:40:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243694AbiBJPkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:40:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D3C9C;
        Thu, 10 Feb 2022 07:40:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19E6761C58;
        Thu, 10 Feb 2022 15:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FF68C340EB;
        Thu, 10 Feb 2022 15:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644507608;
        bh=ODADg4qCJeA1twJ8DMe06Pzn5JoIJqAvj52kpuB2H7k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T7UnPzn1kxUpqHG5GVAwsPMZAyL5LvbIDnBnsCDfxUekvkBnfWOP/pYB6mmUO3dNf
         qfdHOgKlh2GL/7IsUGGZ+0lSW8bOxXxuElrmMvaeu5Vnz47wUqVYLH6kmF65rIca85
         bPUsfQ8qxSHnH7sSeIoc4283qwrNX1rMEjcX1Po+nswEvVMQAVuD5f5Y1RwV+l6wFW
         tyMfpKAbwM8EAA1XzI8kga2p1uiE8NBfejhEdYNJSI1cGfrKaTCMHofY0Ou7pLe0ie
         9YKtJRlwkvmw0ZlJpqsIyudsPI2UWdhj8w2bvQNGRTUI/HMlD7KZEr5tWUwf15bvr0
         qXYyMUrRd3TPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56F8EE6D3DE;
        Thu, 10 Feb 2022 15:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mpls: Fix GCC 12 warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164450760835.15967.16970904238415952820.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 15:40:08 +0000
References: <1644452918-576-1-git-send-email-victor.erminpour@oracle.com>
In-Reply-To: <1644452918-576-1-git-send-email-victor.erminpour@oracle.com>
To:     Victor Erminpour <victor.erminpour@oracle.com>
Cc:     davem@davemloft.net, kuba@kernel.org, bpoirier@nvidia.com,
        l4stpr0gr4m@gmail.com, jiapeng.chong@linux.alibaba.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Feb 2022 16:28:38 -0800 you wrote:
> When building with automatic stack variable initialization, GCC 12
> complains about variables defined outside of switch case statements.
> Move the variable outside the switch, which silences the warning:
> 
> ./net/mpls/af_mpls.c:1624:21: error: statement will never be executed [-Werror=switch-unreachable]
>   1624 |                 int err;
>        |                     ^~~
> 
> [...]

Here is the summary with links:
  - net: mpls: Fix GCC 12 warning
    https://git.kernel.org/netdev/net/c/c4416f5c2eb3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


