Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8FA4E1F01
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 03:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344156AbiCUCVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 22:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344147AbiCUCVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 22:21:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B7156755;
        Sun, 20 Mar 2022 19:20:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 816C960A27;
        Mon, 21 Mar 2022 02:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2A8FC340EE;
        Mon, 21 Mar 2022 02:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647829209;
        bh=64/k54pvMqj6twISzt0WN6Gl+zN6N395oF0BTzFgfWs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sX3wH74DfZCyLwTljShxRriiEQUsXLkvr/4Ix548wnakfswmgMwTW7HrpI5r29I7s
         Ma7JV3MImRpfudqxgAW5rxo/T/ai8InKZjdT4LtMGZJvybNr0e40O8vwKogpgjmBqW
         OdV4YiB9+Qrws+y+OJ9hwl0y8lWhCQPuXK8zGiWd/b4Uaj8vmxMDR/n2pp4JwNZXpg
         yc5DOuAr2nUrE7LVBjd24pftG6QgnBlAJ8gks5VNub92l8Iqvlnov7o8dEvdUNHo/L
         Me5YVgBml8Gw7eOuD2nKZKVE43p9dypBSc2S1NC0OwJjlfj/WKqWlbEaKWtP37A3wd
         OBHNl/zYnytsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B69ECE6D406;
        Mon, 21 Mar 2022 02:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 bpf-next] bpf: select proper size for bpf_prog_pack
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164782920974.9354.16623497137141452745.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 02:20:09 +0000
References: <20220311201135.3573610-1-song@kernel.org>
In-Reply-To: <20220311201135.3573610-1-song@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kernel-team@fb.com,
        edumazet@google.com
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Fri, 11 Mar 2022 12:11:35 -0800 you wrote:
> Using HPAGE_PMD_SIZE as the size for bpf_prog_pack is not ideal in some
> cases. Specifically, for NUMA systems, __vmalloc_node_range requires
> PMD_SIZE * num_online_nodes() to allocate huge pages. Also, if the system
> does not support huge pages (i.e., with cmdline option nohugevmalloc), it
> is better to use PAGE_SIZE packs.
> 
> Add logic to select proper size for bpf_prog_pack. This solution is not
> ideal, as it makes assumption about the behavior of module_alloc and
> __vmalloc_node_range. However, it appears to be the easiest solution as
> it doesn't require changes in module_alloc and vmalloc code.
> 
> [...]

Here is the summary with links:
  - [v4,bpf-next] bpf: select proper size for bpf_prog_pack
    https://git.kernel.org/bpf/bpf-next/c/ef078600eec2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


