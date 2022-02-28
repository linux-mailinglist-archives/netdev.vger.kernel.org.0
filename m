Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835A74C707A
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 16:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbiB1PUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 10:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiB1PUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 10:20:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5ECC522C4;
        Mon, 28 Feb 2022 07:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5397D60FD8;
        Mon, 28 Feb 2022 15:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9F58C340EE;
        Mon, 28 Feb 2022 15:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646061610;
        bh=szhdfk7+7V9sGlldHCLj5UhBz7sXxIGJHMZ+TCys5dA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BBF27rZrJ6bBGl5XgqNOKiGgQ3ctoLnlS5yJgcQYsTR8aNMvxlevv3hvTOpBt2aIp
         7ge6Lv9MKdrjeugB4Tqzdk98/q1vu7kunefeqYAftikkRZjZivGnonuaTsTn8lCkyT
         tg3ZUN0CG/hDcPYOxPAYPKEUC+1Y2yKinzdzI/6ip+ZeG9/bXTpLUMm3g6ikXwitMw
         L8kIwtucbk9K8on/O4pbBW0YLXDXHjr+il3KiAWYYHyKxmHvnDRyNGM5P+q4bvqfc8
         qA24eGozJ1/YWcO/QZZ8w7DW4Id50XxeQ4dCyQqUF5o+auCCvky7xQUenkvAHNac52
         LcLrZkvFWmDaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E341E5D087;
        Mon, 28 Feb 2022 15:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] bpftool: Remove redundant slashes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164606161057.12013.6641220017965219668.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 15:20:10 +0000
References: <20220226163815.520133-1-ytcoode@gmail.com>
In-Reply-To: <20220226163815.520133-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, jean-philippe@linaro.org,
        mauricio@kinvolk.io, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Sun, 27 Feb 2022 00:38:15 +0800 you wrote:
> Because the OUTPUT variable ends with a slash but CURDIR doesn't, to keep
> the _OUTPUT value consistent, we add a trailing slash to CURDIR when
> defining _OUTPUT variable.
> 
> Since the _OUTPUT variable holds a value ending with a trailing slash,
> there is no need to add another one when defining BOOTSTRAP_OUTPUT and
> LIBBPF_OUTPUT variables.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] bpftool: Remove redundant slashes
    https://git.kernel.org/bpf/bpf-next/c/c62dd8a58d19

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


