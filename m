Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565F25E6594
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiIVOaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbiIVOaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:30:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54881ACA32
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 07:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 303A9B837AF
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCB75C433B5;
        Thu, 22 Sep 2022 14:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663857014;
        bh=07h7TdhOOOoLb2IXD8a228+AUj4TH1PM+6KYtaVMzUM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CS7lqzJQLj/YAgmf/sPtAzhT6zVP2BxvwWO8/4mOOIr8xPc/teyreshQrtSZTEGd6
         +KZ+AReo8E2yYvxyxDpMwWjT9Y00FbNGSvcfOQIcdC4zz8jfOTyXHbTN0602SjCk5P
         Tgm0vL+vKgYsHxY9SwsWsmiSHSbJ7MiWzwiH7HS3xBCWAdZ7tlfyskuXNKnRNw0vpj
         c4UuYT45wkOwkf+M6a+ttQXBg6juX7b2bxFODa99jB+rE7uJnJgHqkpewW6+nt/M5W
         Mc3bA59dHVZC2w2VzR3zMXwwcgqB5B50gql4tsve0Chw2vAXn0YLxKYkObtIORYpZL
         Fwe6kxnLdV1oQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1237E4D03D;
        Thu, 22 Sep 2022 14:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: marvell: Fix refcounting bugs in
 prestera_port_sfp_bind()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166385701472.15701.3191419697067047173.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 14:30:14 +0000
References: <20220921133245.4111672-1-windhl@126.com>
In-Reply-To: <20220921133245.4111672-1-windhl@126.com>
To:     Liang He <windhl@126.com>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, yevhen.orlov@plvision.eu,
        taras.chornyi@plvision.eu, oleksandr.mazur@plvision.eu
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

On Wed, 21 Sep 2022 21:32:45 +0800 you wrote:
> In prestera_port_sfp_bind(), there are two refcounting bugs:
> (1) we should call of_node_get() before of_find_node_by_name() as
> it will automaitcally decrease the refcount of 'from' argument;
> (2) we should call of_node_put() for the break of the iteration
> for_each_child_of_node() as it will automatically increase and
> decrease the 'child'.
> 
> [...]

Here is the summary with links:
  - net: marvell: Fix refcounting bugs in prestera_port_sfp_bind()
    https://git.kernel.org/netdev/net/c/3aac7ada64d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


