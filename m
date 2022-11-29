Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409DF63B6CD
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbiK2BAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiK2BAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35DE2B1A3;
        Mon, 28 Nov 2022 17:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F74661449;
        Tue, 29 Nov 2022 01:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0244C433C1;
        Tue, 29 Nov 2022 01:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669683615;
        bh=VsIRV30DZnONfV7yknBeYkXlYzrjlKW+VfAChq1+DX8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a2sq0XHdKSooq6BN+jLKhWSEYwCAj+/tgv7VZY10CxsJrepE3SkbF95MhqnXrn2G7
         X8iJOdb/KN8vMXNMhm1GnkkngGCAOlr1qsZxBkt8xaMdgxYCbPPVriRfQ3CWQrZIpN
         8htm+JynmZyRr6J59twjxk1QvVgNx0rXLLNxvOMDUTr6+T4SAdV1mUNvxKQiHSib5M
         EN1FEavHiox+UU4+Gi/mzyHdviJLm6w6EuVlDAutVZ2Zv0zObGhwk5gSP2E5StmbWN
         P7DVGPAeXONW8MQjcPfiAnLP2WBKus9ggInhrlUTCGDQUP9NsbowyVTPgk4UBmIUBo
         wOOjqw/Ae6P1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ADBEEE21EF7;
        Tue, 29 Nov 2022 01:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv4: Fix route deletion when nexthop info is not
 specified
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166968361569.11299.14762199018908685930.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 01:00:15 +0000
References: <20221124210932.2470010-1-idosch@nvidia.com>
In-Reply-To: <20221124210932.2470010-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, dsahern@gmail.com,
        razor@blackwall.org, jonas.gorski@gmail.com, mlxsw@nvidia.com,
        stable@vger.kernel.org
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

On Thu, 24 Nov 2022 23:09:32 +0200 you wrote:
> When the kernel receives a route deletion request from user space it
> tries to delete a route that matches the route attributes specified in
> the request.
> 
> If only prefix information is specified in the request, the kernel
> should delete the first matching FIB alias regardless of its associated
> FIB info. However, an error is currently returned when the FIB info is
> backed by a nexthop object:
> 
> [...]

Here is the summary with links:
  - [net] ipv4: Fix route deletion when nexthop info is not specified
    https://git.kernel.org/netdev/net/c/d5082d386eee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


