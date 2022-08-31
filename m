Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F4E5A761A
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiHaGAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiHaGAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A046133A12
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 23:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AF39616DD
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82CCBC43140;
        Wed, 31 Aug 2022 06:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661925615;
        bh=cOAM5G24H/9Dhr3Pl2W0BHkxc2Cn8nsbmyjrD7nqsuc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UUHmOwhPFhM3zZENg70KTLnXNiJRxCjyoc2sW/lRozQygneeln6JQ/MXhOXkbOgnd
         Zr8VE5E1mv77VVhzglpJHx/y79X9k7hriBhdRPbh8AebMTfNT/5VlOEFDuBLxdwvZT
         TFIKsa/23gz/Kq6mzzAsHIJCNaiEUCozh8Yf6MGshDsSfzOeqfsbr+XMH4SEq8TpVA
         b/9Jva1DhDjdERtj1ABI8xlj+7H777D0Q3tU83TpLgZgvJU74w5J4FzPbK5s43I0k4
         DaKxJX7E0iA5T4J7S+ckeaMIYvwINr+hbAjQDXD3aBg9Nk6CgCZs5JOrMym/WxJz8N
         Gs/3wgD5YM0WA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E2ABE924D6;
        Wed, 31 Aug 2022 06:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next] funeth: remove pointless check of devlink pointer in
 create/destroy_netdev() flows
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166192561544.21117.9608144792234082401.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 06:00:15 +0000
References: <20220826110411.1409446-1-jiri@resnulli.us>
In-Reply-To: <20220826110411.1409446-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, dmichail@fungible.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 Aug 2022 13:04:11 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Once devlink port is successfully registered, the devlink pointer is not
> NULL. Therefore, the check is going to be always true and therefore
> pointless. Remove it.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] funeth: remove pointless check of devlink pointer in create/destroy_netdev() flows
    https://git.kernel.org/netdev/net-next/c/4f99de7b181f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


