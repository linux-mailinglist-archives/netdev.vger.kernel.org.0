Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56345AB326
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 16:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbiIBOOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 10:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238757AbiIBON0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 10:13:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802E8F8F6B;
        Fri,  2 Sep 2022 06:41:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7494962122;
        Fri,  2 Sep 2022 13:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C964CC433D7;
        Fri,  2 Sep 2022 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662126016;
        bh=u/tfn1UuECw3LExgXv8MjsQQGfF+MDyPV7AB0i8NiLQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=incaRTr8WnBv1rfj1sjmPUeoHDDPIlxJY66kQHCXJXlwIPwy5NyemZuQjb/XoHNwb
         1xegJODHkPm7noaMIucfI2GsadIMhZqKcIN+p9nEBb3vk/yx/nCA6hyrpPBTjsSTMR
         D56ognyEUtkITA85n4mgsFNJONtle6N0D9UKPcKCt8cLSpbrMb203WxVdoQtnZ2Sy1
         KwtP1V2Fq9CqqqnxZ4EBlaQjH+vLEtesL9xWthiVQ8uhni2RwTh219eN5eWyjs5XCA
         XrOhAkr64Zl0zDWRICmISyf03/kMwYh4PONCY4EEEi2dy9yyXnLyQDd4zY+J2aj+kz
         ZqbcDYBAb57gA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B5C77E924D6;
        Fri,  2 Sep 2022 13:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 bpf-next 0/6] selftests: xsk: real device testing support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166212601674.28239.17720886706170091787.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 13:40:16 +0000
References: <20220901114813.16275-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220901114813.16275-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        john.fastabend@gmail.com
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

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu,  1 Sep 2022 13:48:07 +0200 you wrote:
> v5->v6:
> * rebase properly
> * collect acks (Magnus)
> * extend char limit for iface/netns to 16 (Magnus)
> 
> v4->v5:
> * ice patches have gone through its own way, so they are out of this
>   revision
> * rebase
> * close prog fd on error path in patch 1 (John)
> * pull out patch for closing netns fd and send it separately (John)
> * remove a patch that made Tx completion rely on pkts_in_flight (John)
> 
> [...]

Here is the summary with links:
  - [v6,bpf-next,1/6] selftests: xsk: query for native XDP support
    https://git.kernel.org/bpf/bpf-next/c/0d68e6fe12ad
  - [v6,bpf-next,2/6] selftests: xsk: introduce default Rx pkt stream
    https://git.kernel.org/bpf/bpf-next/c/1adef0643b7d
  - [v6,bpf-next,3/6] selftests: xsk: increase chars for interface name to 16
    https://git.kernel.org/bpf/bpf-next/c/24037ba7c47b
  - [v6,bpf-next,4/6] selftests: xsk: add support for executing tests on physical device
    https://git.kernel.org/bpf/bpf-next/c/a693ff3ed561
  - [v6,bpf-next,5/6] selftests: xsk: make sure single threaded test terminates
    https://git.kernel.org/bpf/bpf-next/c/c29fe883defc
  - [v6,bpf-next,6/6] selftests: xsk: add support for zero copy testing
    https://git.kernel.org/bpf/bpf-next/c/fe2ad08e1e1d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


