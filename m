Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C7A4C71D4
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 17:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbiB1Qky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 11:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiB1Qkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 11:40:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A04981198;
        Mon, 28 Feb 2022 08:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A6243CE175A;
        Mon, 28 Feb 2022 16:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05187C340F0;
        Mon, 28 Feb 2022 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646066410;
        bh=1/VDKwcrxOwUXW7PkPQ4YjS7GLrJ5lJeI6UJBXY4i9Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RO6z7u2JN141BDj589wq5Gf//JmSBzc532GINDStT7w43AqcxNv6HdYUHG/2fuk9L
         iTzf39VrDMyZnHhf57go12PiIZZ71JGA//zeaC3tpr7UVoshLLpxljfqwL8Cc0x4fv
         SBp6BwFYa4I+SeokRQEM/ejn6NY9my85l9/m/UnGI0IzbmoFhT93aLRmfTauqtISPb
         fC29A0S9bYVe+BGRkfNLdGEGhlECv/kQQH5MMTdnUfCrLaQY5YRaGkgMpS1hRWnNI6
         RH6Vqs2SC87mwxjo2VGnRKzvBtuO6i77T4mWgMElE9euiYQOTAPW467hx0DIzdB0bB
         aWphr94Sm76yw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D598DEAC095;
        Mon, 28 Feb 2022 16:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] libbpf: fix BPF_MAP_TYPE_PERF_EVENT_ARRAY auto-pinning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164606640987.23345.3964294221213220765.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 16:40:09 +0000
References: <20220225152355.315204-1-stijn@linux-ipv6.be>
In-Reply-To: <20220225152355.315204-1-stijn@linux-ipv6.be>
To:     Stijn Tintel <stijn@linux-ipv6.be>
Cc:     bpf@vger.kernel.org, songliubraving@fb.com, andrii@kernel.org,
        toke@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kpsingh@kernel.org, yhs@fb.com,
        kafai@fb.com, daniel@iogearbox.net, ast@kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 25 Feb 2022 17:23:55 +0200 you wrote:
> When a BPF map of type BPF_MAP_TYPE_PERF_EVENT_ARRAY doesn't have the
> max_entries parameter set, the map will be created with max_entries set
> to the number of available CPUs. When we try to reuse such a pinned map,
> map_is_reuse_compat will return false, as max_entries in the map
> definition differs from max_entries of the existing map, causing the
> following error:
> 
> [...]

Here is the summary with links:
  - [v2] libbpf: fix BPF_MAP_TYPE_PERF_EVENT_ARRAY auto-pinning
    https://git.kernel.org/bpf/bpf-next/c/a4fbfdd7a160

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


