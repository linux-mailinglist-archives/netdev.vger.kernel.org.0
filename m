Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6BA4C12EA
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 13:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbiBWMkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 07:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240333AbiBWMkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 07:40:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6C1A27B6
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 04:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABF93612E3
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0CF23C340FB;
        Wed, 23 Feb 2022 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645620011;
        bh=L6s45iIBjgRU33nwB5NfAfmcLIPfG+1Ou9/mF1ACgLw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DNMiryzl+gzmp4L6UYaHJvqVsTZkXeWcySWCg7eUrd0gBkdv9/VhSEMVHZOVn74lB
         rir6gEuZayuW5FNc3t90Mq9iYw8CeOF3eVLFcD5DBJamQ3FiR9kC2ch8NIsvV5S/8K
         hU9vIB7VU5nflQP+tqrA+956E4WweTi31b5ldTGgCzCPJdzTUEUQGyEQj9DZatEO5L
         QU45fm7N0pAehFGV1dFWud9KbIFK9p0H+78hdIb9PzfN49n/alLcMJoI8HdQru97le
         e+1cy34oy3r0ZOqrDLoLBVzqgLmkIiK0pLyc9kV6O8OOIa98HpgRNLTTUir7gEt+jK
         hDTKubBFVpzKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EF90AE6D4BA;
        Wed, 23 Feb 2022 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mctp: Fix warnings reported by clang-analyzer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164562001097.25344.11210323312274090430.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 12:40:10 +0000
References: <20220222042936.516874-1-matt@codeconstruct.com.au>
In-Reply-To: <20220222042936.516874-1-matt@codeconstruct.com.au>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jk@codeconstruct.com.au
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
by David S. Miller <davem@davemloft.net>:

On Tue, 22 Feb 2022 12:29:36 +0800 you wrote:
> net/mctp/device.c:140:11: warning: Assigned value is garbage or undefined
> [clang-analyzer-core.uninitialized.Assign]
>         mcb->idx = idx;
> 
> - Not a real problem due to how the callback runs, fix the warning.
> 
> net/mctp/route.c:458:4: warning: Value stored to 'msk' is never read
> [clang-analyzer-deadcode.DeadStores]
>         msk = container_of(key->sk, struct mctp_sock, sk);
> 
> [...]

Here is the summary with links:
  - [net-next] mctp: Fix warnings reported by clang-analyzer
    https://git.kernel.org/netdev/net-next/c/8d783197f06d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


