Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6012C6EA1A2
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbjDUCaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbjDUCaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1B1212D
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 19:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D60D964D1D
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 330CDC4339B;
        Fri, 21 Apr 2023 02:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682044219;
        bh=JvvWPhp/8EVV8OL4IkKU4tiY94Ywo92jnz04tUvt5PY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tgWy9sErFWEbe8kmI6LpVHhx1EmPmizKT6fqmmQY2K8hqXj91WYDD6sEBhhfzD317
         bpDAu9cUjYs1W7wERS+l6RZdgqwepf5Dg1ZvyQ5CE/RswUXfgLQ7jrZzjNgCqpA9Ql
         niE2nX3QoYnkixYqmx/DOa1B6tZ3CxtGPcU45Dmn2UW5cj4VIMQn44kcETldpIp7jp
         CnmSDKr2FVElZzd9bszld4hBFNBdeMtRWD+HXRKkk0vec4YQBu55wFA1auy7Wp/T5p
         wUOYLsaGBXT1+QG2EBzEzDTqWcA0cW3CbSY1sH+DwaHUaiXB99XsbS39G52n04QE+h
         0KMl+zNS6AiDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15DF1E501E3;
        Fri, 21 Apr 2023 02:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] gve: update MAINTAINERS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168204421908.9555.3095328989706598759.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 02:30:19 +0000
References: <20230419210558.1893400-1-jeroendb@google.com>
In-Reply-To: <20230419210558.1893400-1-jeroendb@google.com>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pkaligineedi@google.com
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

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Apr 2023 14:05:58 -0700 you wrote:
> This reflects role changes in our team.
> 
> Signed-off-by: Jeroen de Borst <jeroendb@google.com>
> Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] gve: update MAINTAINERS
    https://git.kernel.org/netdev/net/c/e375b503943f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


