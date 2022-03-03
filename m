Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9664CBB5A
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 11:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbiCCKa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 05:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbiCCKa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 05:30:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8B1179A2B;
        Thu,  3 Mar 2022 02:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ACE861365;
        Thu,  3 Mar 2022 10:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8D20C340F0;
        Thu,  3 Mar 2022 10:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646303412;
        bh=vJGtHO8HLMsb4Q6Od8HA8qJMHjiBPSG80rJOEeuzKAY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hAxas/wJ79XJ55GdDOpJv0H8QuuY5XTaxKJ1B5IXC463vWxNA1Iec8/GAQSWdMazn
         eHG3J8ARFaPb0XvVGE8S5YwEuuNHYRWxnAmoV1gO8rN3RYqIu/LHoud7iQZV5k51pX
         YwhUDoi5IaUyVKAioJFazLNw99RnjYe6vrwcUN3YFN7+vEkudZgmhKzFCA9jbVH2zt
         HK2+lynp7o5ebTW7pX9d1uctaNonBnqXlRx+ZHwdSQVsDuXPfd97j0sNhWq7szsX5L
         1O7ArWpsSZ7e7TAlEXdE6Z3Na1C8IXq9rSVjteMiD255BdYALAdT/Z6x4fpaKtC0IL
         Xfop7VuxopRww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3E3EE8DD5B;
        Thu,  3 Mar 2022 10:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v9 0/5] page_pool: Add stats counters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164630341186.19668.2407883981018370083.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 10:30:11 +0000
References: <1646207751-13621-1-git-send-email-jdamato@fastly.com>
In-Reply-To: <1646207751-13621-1-git-send-email-jdamato@fastly.com>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com,
        leon@kernel.org, linux-rdma@vger.kernel.org, saeedm@nvidia.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Tue,  1 Mar 2022 23:55:46 -0800 you wrote:
> Greetings:
> 
> Welcome to v9.
> 
> This revisions adds a commit which updates the page_pool documentation to
> describe the stats API, structures, and fields.
> 
> [...]

Here is the summary with links:
  - [net-next,v9,1/5] page_pool: Add allocation stats
    https://git.kernel.org/netdev/net-next/c/8610037e8106
  - [net-next,v9,2/5] page_pool: Add recycle stats
    https://git.kernel.org/netdev/net-next/c/ad6fa1e1ab1b
  - [net-next,v9,3/5] page_pool: Add function to batch and return stats
    https://git.kernel.org/netdev/net-next/c/6b95e3388b1e
  - [net-next,v9,4/5] Documentation: update networking/page_pool.rst
    https://git.kernel.org/netdev/net-next/c/a3dd98281b9f
  - [net-next,v9,5/5] mlx5: add support for page_pool_get_stats
    https://git.kernel.org/netdev/net-next/c/cc10e84b2ec3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


