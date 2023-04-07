Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34ABD6DA73F
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 04:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239970AbjDGCAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 22:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239719AbjDGCAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 22:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437FD7EDC;
        Thu,  6 Apr 2023 19:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C852E64E39;
        Fri,  7 Apr 2023 02:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FEDAC433A0;
        Fri,  7 Apr 2023 02:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680832818;
        bh=yMPh6O0JgasZNRwSsmD4beCe3OsIB2hIUjABUM4+a3A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NCUSxKzMyY9l5vImpY/yRrhs+fYk/zJ6+zujuV5NbY1vHlAVHfnyQ6her+2uQMJ5M
         D5P0mKZct7IrqM7ZcltqGE4Wp5XiaBWUnL9h7shUg1x4TjOedlJ0/jJShuVO8CcMtt
         M590XISTbAINu3kXqkcfFEuxxbAEO3FD+iREjaVsRQGoim1U2LI6Ced8o3J5ZSdVYK
         6NCyLNp7tybWAWhTAM3ZIDPxB4QLU/6pduig+JjhgOWpYg9oHboY0gtPsPR+F4mkIV
         KLstE1RWYyB9w1ODMVWjvMi/G8QtrRk9JJMCIGV2P6CYDn68pdIzQjUTbNZsQ7EysB
         PbLbZK2+8/eTQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8A90C41671;
        Fri,  7 Apr 2023 02:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: ensure all memory is initialized in
 bpf_get_current_comm
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168083281794.8155.1614082065625431355.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Apr 2023 02:00:17 +0000
References: <20230407001808.1622968-1-brho@google.com>
In-Reply-To: <20230407001808.1622968-1-brho@google.com>
To:     Barret Rhoden <brho@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu,  6 Apr 2023 20:18:08 -0400 you wrote:
> BPF helpers that take an ARG_PTR_TO_UNINIT_MEM must ensure that all of
> the memory is set, including beyond the end of the string.
> 
> Signed-off-by: Barret Rhoden <brho@google.com>
> ---
>  kernel/bpf/helpers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [bpf-next] bpf: ensure all memory is initialized in bpf_get_current_comm
    https://git.kernel.org/bpf/bpf-next/c/f3f213497797

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


