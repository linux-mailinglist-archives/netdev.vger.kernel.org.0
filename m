Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8585D561708
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiF3KAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiF3KAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB0E43ED8
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09B88621A5
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 10:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65F08C341CC;
        Thu, 30 Jun 2022 10:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656583214;
        bh=gbkIELy/FoUfbKIaVhubPHLYMdB/mdUrp2fzaTU3594=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DIuNfzxeTLAEeCs2palbddEuWOwG2sS8G8M/7Q/pWPFhbWr4pO2uuClSNTvccX75t
         YmoK4GmdcwRRmS2khWZwFcJ83w5OGJjKl4YFTilla8HnBdgwLP7qiCMzcjL+6TtRer
         ANJKZ75XT96v9v+iX1w7pVqyIYcKMcPjjoZewBjO5QhNDILFmvLHZbp9YIPFUlAFHK
         1YVtmYYhZP5S6pNvsLK299To+7h5Phrje3pcWKCM7tg+EBzW6nW3y5ly01j+NgNWbK
         04P1ECZyquIre5KThNjtqtyRQe2haalHBaYLE5aWVar4C99aOtqNndZoJlyYnPIyb2
         G+rQEArU5eogQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48E13E49BBB;
        Thu, 30 Jun 2022 10:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mlxsw: spectrum_router: Fix rollback in tunnel next hop
 init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165658321429.30282.12420438180519678903.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 10:00:14 +0000
References: <20220629070205.803952-1-idosch@nvidia.com>
In-Reply-To: <20220629070205.803952-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com
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

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 29 Jun 2022 10:02:05 +0300 you wrote:
> From: Petr Machata <petrm@nvidia.com>
> 
> In mlxsw_sp_nexthop6_init(), a next hop is always added to the router
> linked list, and mlxsw_sp_nexthop_type_init() is invoked afterwards. When
> that function results in an error, the next hop will not have been removed
> from the linked list. As the error is propagated upwards and the caller
> frees the next hop object, the linked list ends up holding an invalid
> object.
> 
> [...]

Here is the summary with links:
  - [net] mlxsw: spectrum_router: Fix rollback in tunnel next hop init
    https://git.kernel.org/netdev/net/c/665030fd0c1e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


