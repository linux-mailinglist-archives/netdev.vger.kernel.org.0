Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87C9524DDD
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354184AbiELNKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354176AbiELNKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:10:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E698C24F0E2
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 824BB6200C
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 13:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E005EC34114;
        Thu, 12 May 2022 13:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652361011;
        bh=8LuqptOPDv7pbme64Ld3baQ3zSx5HkIsp5MgoF6QiuU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EiZL+5f6SA36ToSKmPvFcA2T2ds9jnskbzKOoGoU+b+Cf/qHjR1QGcpOyv9ARhts8
         IJezJn8Kf4GctSwm9bx7g1NhgWWcMlDNZVWtTPhB9bS5F7k3UtfpVWjcb4VaEcxSvp
         sd0dkzdBrQoFxxhctk0cvw/NhmdkH90dR5HlkKgyyH8j+AbZ1D10T0yqmZfMyztcDd
         1vvEmTEk673lO+z9oqdiZRLcbISzoN/HtzM00EEhMyAKHCczJok2KUeconOnER8L5r
         xJSKZKsfxdS6hpncE781t2h+NT/wdsuYKAzYd0w6QkMQbBK/qj9aS1aM8MdIVGt3CC
         MD5hHRxgq2COQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1D9AF0392C;
        Thu, 12 May 2022 13:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mlxsw: Avoid warning during ip6gre device removal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165236101178.8258.8883298954039833110.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 13:10:11 +0000
References: <20220511115747.238602-1-idosch@nvidia.com>
In-Reply-To: <20220511115747.238602-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 11 May 2022 14:57:47 +0300 you wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> IPv6 addresses which are used for tunnels are stored in a hash table
> with reference counting. When a new GRE tunnel is configured, the driver
> is notified and configures it in hardware.
> 
> Currently, any change in the tunnel is not applied in the driver. It
> means that if the remote address is changed, the driver is not aware of
> this change and the first address will be used.
> 
> [...]

Here is the summary with links:
  - [net] mlxsw: Avoid warning during ip6gre device removal
    https://git.kernel.org/netdev/net/c/810c2f0a3f86

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


