Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259F9539980
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 00:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348420AbiEaWaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 18:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348419AbiEaWaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 18:30:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D80C9E9DD;
        Tue, 31 May 2022 15:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0C2A61454;
        Tue, 31 May 2022 22:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3DDA5C3411D;
        Tue, 31 May 2022 22:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654036213;
        bh=9CKFF1v1EuML4c9sbd8g8eEThV0z6jr7sag1RJZVsVQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O0TdG8p6Muv4GNkaiYcpNUOQjXdI7Ys2BaegeqJ9TjURLkmmcdmwP9wSfTGfC4wtp
         6LQ+l1QQTTkNVV7vICicf2rOq8c3qqon7I0Fd6wrGS2n0hsR+oejLA8sQKHAAEpEYn
         yVylGcTPCimH2OmOxXJzrNvUeSLj/0sVwbS+EehioQkCiDZyCwZr/W5sy2uHExu0uG
         JIAT8n7/IB90s46KbDiySe7oRf7De0r99bB/lIQOaM9sYqpi1YG3E52tGxOPTTfNOZ
         z/9JWa4jbUI763n5NpkUZxrEsjOFMnvYEtArXshkQ3Q0Ou2UD9TtTUuZ8y7ZMIqaIG
         r1hoGvP4fwImA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1ED99F0394D;
        Tue, 31 May 2022 22:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpf: arm64: clear prog->jited_len along prog->jited
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165403621312.30952.5989556122316481247.git-patchwork-notify@kernel.org>
Date:   Tue, 31 May 2022 22:30:13 +0000
References: <20220531215113.1100754-1-eric.dumazet@gmail.com>
In-Reply-To: <20220531215113.1100754-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        zlim.lnx@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org,
        syzkaller@googlegroups.com
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

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 31 May 2022 14:51:13 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot reported an illegal copy_to_user() attempt
> from bpf_prog_get_info_by_fd() [1]
> 
> There was no repro yet on this bug, but I think
> that commit 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
> is exposing a prior bug in bpf arm64.
> 
> [...]

Here is the summary with links:
  - [bpf] bpf: arm64: clear prog->jited_len along prog->jited
    https://git.kernel.org/bpf/bpf/c/e0491b11c131

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


