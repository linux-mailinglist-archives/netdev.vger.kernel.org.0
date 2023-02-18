Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E67C69BB30
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 18:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjBRRMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 12:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjBRRMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 12:12:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4566317CE7
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 09:12:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F129FB80860
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 17:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C95BC4339B;
        Sat, 18 Feb 2023 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676740353;
        bh=SrQlfDX7naqIic0xpnXGGKSOlbPrJZ15FdPG8/r1YfM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JrVE8vw7WX/RduxQaYs2htdQ6EhKk3D4RdQJnPZkVgQnAAFvejGW6OgX1GYvS8dUV
         tgeZWlFRD8Kv4njwfopESYDQQT0a732UMyVhxE1xV2wvV9vuEUiJo5r6DtSiyTa65N
         pIVEf/xX0zogi3k34+BPol/wOjZEtNzY4KRloqu4c/30zMF/YZPBdpx8V7PS1lwIXO
         uM9rAm3Aphdo+bLSzF6qLGbiMeeLsGgFnvRSfNflLjm1FZs8awzJaArJr0+7k2g8mY
         HJznleJiqpXFikpoDJ9XBMwbpF/C1TR+YPOlwjUu2rbRi+vMcyTnLTu3WJh9100mid
         ctJqQCXynJ+tQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67B6CE21EC4;
        Sat, 18 Feb 2023 17:12:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/2] iplink: support IPv4 BIG TCP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167674035342.11220.11096641197731361357.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Feb 2023 17:12:33 +0000
References: <cover.1675985919.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1675985919.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        dsahern@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu,  9 Feb 2023 18:44:22 -0500 you wrote:
> Patch 1 fixes some typos in the documents, and Patch 2 adds two
> attributes to allow userspace to enable IPv4 BIG TCP.
> 
> Xin Long (2):
>   iplink: fix the gso and gro max_size names in documentation
>   iplink: add gso and gro max_size attributes for ipv4
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/2] iplink: fix the gso and gro max_size names in documentation
    (no matching commit)
  - [iproute2-next,2/2] iplink: add gso and gro max_size attributes for ipv4
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=1dafe448c7a2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


