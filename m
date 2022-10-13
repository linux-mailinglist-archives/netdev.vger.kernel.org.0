Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7CE5FDE78
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiJMQuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJMQuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E517160C91;
        Thu, 13 Oct 2022 09:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71B18B81F8E;
        Thu, 13 Oct 2022 16:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 207B6C43141;
        Thu, 13 Oct 2022 16:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665679816;
        bh=a8Pbv8UiduDifxCWy11ngujANuzjgm2hzxgzA2vpkcw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sx6ehGkQXkq85hNDww7r5R0TqeURvu8JMQ8k3/DivZGFv8XmkEBbjhF0oDLMOzwzl
         3dBTiqXRbr5ZjZQNyO0HHODZUnZtiOzppwQN2Q/cPGJLi62OuKvJsXW+/hFFnOM+vl
         W9W+CcIiR+N7+n+J9TLK2KXQpWaZbjK+iRDMezfhjLbMa9hKl9Ho90WLuMlqHbG1+a
         WGBV9v+odEYl+RAazT4EqbR56loz6EimI9M0cwcWqr58uUomXn9J/SJur8SeD16Iak
         67yWPKY7NrX6WooAwTKQkBj3EB80v/4AgTb3hJzy4rY5TKfJiZ+UcxwUYKS2rH6A75
         nVrQtlIRzRV7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EC114E4D00C;
        Thu, 13 Oct 2022 16:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: marvell: prestera: fix a couple NULL vs IS_ERR()
 checks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166567981595.2135.11581728647659863231.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Oct 2022 16:50:15 +0000
References: <Y0bWq+7DoKK465z8@kili>
In-Reply-To: <Y0bWq+7DoKK465z8@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     tchornyi@marvell.com, yevhen.orlov@plvision.eu,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, oleksandr.mazur@plvision.eu,
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 12 Oct 2022 18:00:59 +0300 you wrote:
> The __prestera_nexthop_group_create() function returns NULL on error
> and the prestera_nexthop_group_get() returns error pointers.  Fix these
> two checks.
> 
> Fixes: 0a23ae237171 ("net: marvell: prestera: Add router nexthops ABI")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net] net: marvell: prestera: fix a couple NULL vs IS_ERR() checks
    https://git.kernel.org/netdev/net/c/30e9672ac37f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


