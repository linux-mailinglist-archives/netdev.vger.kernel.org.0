Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669B7648CF9
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiLJDub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiLJDu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:50:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB8A54349
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 19:50:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8CA06CE2B8E
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 03:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71BCAC433D2;
        Sat, 10 Dec 2022 03:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670644221;
        bh=chc1kqI6lUbWOYkupQlrpMId8GNvMQ5xMhLDq+e5R50=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dnQq3FzjIDAlpKoHEx2mh/OXCnmNtji7qrQ56jW5mlzxvm9f/0meO5I1O/J7szQHT
         UmEuJe4j3RhsWX1P87GW63SBHfgLX/QTNhoEaoq+DTmqlBEpcGxyWRr7ZiS1vIRw43
         TkDHmhXS9cgVQZNFyP0URA9HY5r5OOqZ4lCVNXVt/sJc3EhgxdACyO1yDpkDOIBWYt
         zz/T0RoEEaxkdNEE9Dzo1dviHyl0CR6JSYlkcVS5k7dpAf1o1UwCoc/4OX9jOh1Lqq
         M0+Z2FA3H4wR+syRXZkNwTWUvkO4jizLhMuiYkyF+hT6RArRIfznbeVw62oIKs6eXd
         LkqBDtF+7tVgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C104C41612;
        Sat, 10 Dec 2022 03:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: mlx5_ifc updates for MATCH_DEFINER general
 object
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167064422130.8448.9639606216199415128.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Dec 2022 03:50:21 +0000
References: <20221209001420.142794-2-saeed@kernel.org>
In-Reply-To: <20221209001420.142794-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, kliteyn@nvidia.com, valex@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Thu,  8 Dec 2022 16:14:06 -0800 you wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> 
> Update full structure of match definer and add an ID of
> the SELECT match definer type.
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Alex Vesker <valex@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: mlx5_ifc updates for MATCH_DEFINER general object
    https://git.kernel.org/netdev/net-next/c/f1543c7abab2
  - [net-next,02/15] net/mlx5: fs, add match on ranges API
    https://git.kernel.org/netdev/net-next/c/38bf24c38d19
  - [net-next,03/15] net/mlx5: DR, Add functions to create/destroy MATCH_DEFINER general object
    https://git.kernel.org/netdev/net-next/c/e046b86e2900
  - [net-next,04/15] net/mlx5: DR, Rework is_fw_table function
    https://git.kernel.org/netdev/net-next/c/0a8c20e23ff2
  - [net-next,05/15] net/mlx5: DR, Handle FT action in a separate function
    https://git.kernel.org/netdev/net-next/c/c72a57ad6e91
  - [net-next,06/15] net/mlx5: DR, Manage definers with refcounts
    https://git.kernel.org/netdev/net-next/c/1339678fdde1
  - [net-next,07/15] net/mlx5: DR, Some refactoring of miss address handling
    https://git.kernel.org/netdev/net-next/c/f31bda789f1d
  - [net-next,08/15] net/mlx5: DR, Add function that tells if STE miss addr has been initialized
    https://git.kernel.org/netdev/net-next/c/1207a772c09d
  - [net-next,09/15] net/mlx5: DR, Add support for range match action
    https://git.kernel.org/netdev/net-next/c/be6d5daeaa3b
  - [net-next,10/15] net/mlx5e: meter, refactor to allow multiple post meter tables
    https://git.kernel.org/netdev/net-next/c/fd6fa761466c
  - [net-next,11/15] net/mlx5e: meter, add mtu post meter tables
    https://git.kernel.org/netdev/net-next/c/d56713250a59
  - [net-next,12/15] net/mlx5e: TC, add support for meter mtu offload
    https://git.kernel.org/netdev/net-next/c/6fda078d5f75
  - [net-next,13/15] net/mlx5e: multipath, support routes with more than 2 nexthops
    https://git.kernel.org/netdev/net-next/c/7c33e73995e9
  - [net-next,14/15] net/mlx5: Refactor and expand rep vport stat group
    https://git.kernel.org/netdev/net-next/c/64b68e369649
  - [net-next,15/15] net/mlx5: Expose steering dropped packets counter
    https://git.kernel.org/netdev/net-next/c/4fe1b3a5f8fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


