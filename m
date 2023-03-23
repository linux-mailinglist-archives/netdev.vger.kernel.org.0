Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623F36C5F3F
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 07:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjCWGAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 02:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCWGAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 02:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AF924730
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 23:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CECDB81F67
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 06:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11C94C433EF;
        Thu, 23 Mar 2023 06:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679551220;
        bh=vfa0NPULGebF/rLM/FtX9xzQnwS1fhkD67pK7tuFfp0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L+EqyXxliQoh06gPCh9e91PmgEW0QfvPwf/cVTZ0A2x2w5CD1zJiuKDsJcXSIMmas
         Bri3leN0JrjkFXvLWeNRW+ZmpKI71Ai3cR1AT+L2XCJyV9F4sSNguAFDAENY3PuQq6
         kRMR3LTQqenLzUs7pmjiyGApohCou3zhhvy4wRTY8eDDEnoNMvrzBGgeBQYpSyXGQG
         0PgkdwARkUVHD2a+aAfOS16BM5gJK3xBbp74DmmqKrSYD5xtvmcewFFV6qp9qOw66/
         pBihPAl1+dtDdjRZ6xbtXS+T+/4UagmLjbg9xs5O53iAUG+Vc4wsbM7/ckBVbxTDXA
         Ba0/6Pb044a3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F0B8CE21ED4;
        Thu, 23 Mar 2023 06:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/7] net/mlx5e: Set uplink rep as NETNS_LOCAL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167955121998.17973.16248642901272759046.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 06:00:19 +0000
References: <20230321211135.47711-2-saeed@kernel.org>
In-Reply-To: <20230321211135.47711-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, gavinl@nvidia.com, gavi@nvidia.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 21 Mar 2023 14:11:29 -0700 you wrote:
> From: Gavin Li <gavinl@nvidia.com>
> 
> Previously, NETNS_LOCAL was not set for uplink representors, inconsistent
> with VF representors, and allowed the uplink representor to be moved
> between net namespaces and separated from the VF representors it shares
> the core device with. Such usage would break the isolation model of
> namespaces, as devices in different namespaces would have access to
> shared memory.
> 
> [...]

Here is the summary with links:
  - [net,1/7] net/mlx5e: Set uplink rep as NETNS_LOCAL
    https://git.kernel.org/netdev/net/c/c83172b0639c
  - [net,2/7] net/mlx5e: Block entering switchdev mode with ns inconsistency
    https://git.kernel.org/netdev/net/c/662404b24a4c
  - [net,3/7] net/mlx5: Fix steering rules cleanup
    https://git.kernel.org/netdev/net/c/922f56e9a795
  - [net,4/7] net/mlx5e: Initialize link speed to zero
    https://git.kernel.org/netdev/net/c/6e9d51b1a5cb
  - [net,5/7] net/mlx5e: Overcome slow response for first macsec ASO WQE
    https://git.kernel.org/netdev/net/c/7e3fce82d945
  - [net,6/7] net/mlx5: Read the TC mapping of all priorities on ETS query
    https://git.kernel.org/netdev/net/c/44d553188c38
  - [net,7/7] net/mlx5: E-Switch, Fix an Oops in error handling code
    https://git.kernel.org/netdev/net/c/640fcdbcf27f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


