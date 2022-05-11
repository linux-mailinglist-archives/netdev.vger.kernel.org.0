Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3095236BC
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245512AbiEKPKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245433AbiEKPKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721695A5BA;
        Wed, 11 May 2022 08:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BA7B61868;
        Wed, 11 May 2022 15:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CA4FC34113;
        Wed, 11 May 2022 15:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652281816;
        bh=soPN5LRFKFxmnNGlcEbk3jFGK+X6i0ROLF9+M0KmYAo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gPrWIN2qkvbljmyPVcdiS20qBHd47vg/pi0Ig7v7JVlCSJHklETCrGT1kx6Rrj0wp
         eEeFONZbeeeecGMI35Uc/P0Qr9eUweAvPcqrEAlFwP0/En6D59wEF0VImzz+xbvuGV
         VnKRbfB38tQI3AGfu02Q5D6OhTiYxM/jR0AXepHuHZMQQs8qdR7aCl+7SHbL63Z4fa
         JfqbigwnoMAzs2KTCiAehGxtIAx9n8TGW9wqKpItKd7oXA3K7Uvw024kvV3ht1u+rG
         Gk8EnV3KHINm+7aHC+MMfJ4Pt6fttrUn9gsCTbgO9ZRQOXtUX4uwlcy0Y28pGiT4Ez
         oOYByjCqWIh1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3D9CDF03932;
        Wed, 11 May 2022 15:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/9] selftests: xsk: add busy-poll testing plus
 various fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165228181624.5151.11091684511221899070.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 15:10:16 +0000
References: <20220510115604.8717-1-magnus.karlsson@gmail.com>
In-Reply-To: <20220510115604.8717-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org
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

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Tue, 10 May 2022 13:55:55 +0200 you wrote:
> This patch set adds busy-poll testing to the xsk selftests. It runs
> exactly the same tests as with regular softirq processing, but with
> busy-poll enabled. I have also included a number of fixes to the
> selftests that have been bugging me for a while or was discovered
> while implementing the busy-poll support. In summary these are:
> 
> * Fix the error reporting of failed tests. Each failed test used to be
>   reported as both failed and passed, messing up things.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/9] selftests: xsk: cleanup bash scripts
    https://git.kernel.org/bpf/bpf-next/c/685e64a3c91d
  - [bpf-next,2/9] selftests: xsk: do not send zero-length packets
    https://git.kernel.org/bpf/bpf-next/c/f3e619bb34d3
  - [bpf-next,3/9] selftests: xsk: run all tests for busy-poll
    https://git.kernel.org/bpf/bpf-next/c/f90062b53229
  - [bpf-next,4/9] selftests: xsk: fix reporting of failed tests
    https://git.kernel.org/bpf/bpf-next/c/895b62eed2ab
  - [bpf-next,5/9] selftests: xsk: add timeout to tests
    https://git.kernel.org/bpf/bpf-next/c/db1bd7a99454
  - [bpf-next,6/9] selftests: xsk: cleanup veth pair at ctrl-c
    https://git.kernel.org/bpf/bpf-next/c/d41cb6c47474
  - [bpf-next,7/9] selftests: xsk: introduce validation functions
    https://git.kernel.org/bpf/bpf-next/c/76c576638f5d
  - [bpf-next,8/9] selftests: xsk: make the stats tests normal tests
    https://git.kernel.org/bpf/bpf-next/c/4fec7028ffea
  - [bpf-next,9/9] selftests: xsk: make stat tests not spin on getsockopt
    https://git.kernel.org/bpf/bpf-next/c/27e934bec35b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


