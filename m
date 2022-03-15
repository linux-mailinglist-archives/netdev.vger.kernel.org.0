Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6C44D9E13
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 15:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349446AbiCOOvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 10:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343923AbiCOOvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 10:51:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C6A55210
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 07:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B8B26111D
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 14:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 964D1C340EE;
        Tue, 15 Mar 2022 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647355810;
        bh=R1IHl9ooKWwGtjOZfsj06cKF51orr0IKysjcZb5E2DA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EEQBQEDra1uPsCn4iT7nqFdEkfH5Bc9xtWhPyN40VlBExCAtbUOB/UpU9OFoOaahX
         4HMxbpGVkYEewSQ6PayD0cwkoh/Rc78OfL8dGnKnlnvv9EXh4LAWWvo/ahZga4uE8D
         RTlwFQ6/LRvqMn9X7sFluOpgLki/PgOZ3afkILrtWCbFpuGrQ9Dodft1OTTIyGefjX
         9JFd1IAawWAeILTj9FsYJP73j2fQa8m9AVwNdvpifzmPXh8/OAX+oXHcDI2xROmMXs
         Qch29M0F+A27e+hq/tn/OwOnAAM25lvtaER2TUP3qWd4zCDFfUE8/BSnwzuBvwpSK0
         j57eBpRdqK+dA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 78A0DE6BBCA;
        Tue, 15 Mar 2022 14:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] netdevsim: Support for L3 HW stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164735581049.5134.4508726854205043909.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Mar 2022 14:50:10 +0000
References: <cover.1647265833.git.petrm@nvidia.com>
In-Reply-To: <cover.1647265833.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        idosch@nvidia.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 14 Mar 2022 15:01:14 +0100 you wrote:
> "L3 stats" is a suite of interface statistics aimed at reflecting traffic
> taking place in a HW device, on an object corresponding to some software
> netdevice. Support for this stats suite has been added recently, in commit
> ca0a53dcec94 ("Merge branch 'net-hw-counters-for-soft-devices'").
> 
> In this patch set:
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] netdevsim: Introduce support for L3 offload xstats
    https://git.kernel.org/netdev/net-next/c/1a6d7ae7d63c
  - [net-next,v3,2/3] selftests: netdevsim: hw_stats_l3: Add a new test
    https://git.kernel.org/netdev/net-next/c/9b18942e9993
  - [net-next,v3,3/3] selftests: mlxsw: hw_stats_l3: Add a new test
    https://git.kernel.org/netdev/net-next/c/ed2ae69c4053

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


