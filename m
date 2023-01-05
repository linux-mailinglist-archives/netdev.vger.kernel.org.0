Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BEF65E4B9
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjAEEkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjAEEkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:40:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3EC12602;
        Wed,  4 Jan 2023 20:40:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CF986136C;
        Thu,  5 Jan 2023 04:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC36AC433F0;
        Thu,  5 Jan 2023 04:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672893620;
        bh=R2TQPhSjDVcJfhuT8PGVBh4mDhDcyMHD8RXGpeAjTz0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LG7WiI/x+yK2v2+32/oChxHxTg3eygCr5+rS1qecdTDeXI55X8PuTdAFI21fwgTvd
         R6qIBesdYHtdxKnw3z7smmeBYIedYcKSHdeevGNJpe8X+YDSiE1IieGDrJj5i9nwEa
         0gbQBsss86zcM6+C4j7qiEx0yrExzcgxNmeJAS7TL7OTgTeEvVtdS8UuUHKXQfMP7Y
         TqzhGBxzn+5Da6DM8ub6F8SIbSAqBi/cI8anqI9I+TtzT2KMnZTugVbOQXp0ICm2KC
         zJnldQZ6hOPhHS9DE86+uo5TcHYZI1Bpfp9NrJ+gYrX72tWY/7DwMqKHK9ZetHXyFU
         EoDXxZtyTmYOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BEB29E57253;
        Thu,  5 Jan 2023 04:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2023-01-04
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167289362077.19861.15068716431831684165.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Jan 2023 04:40:20 +0000
References: <20230104215500.79435-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20230104215500.79435-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, kuba@kernel.org,
        andrii@kernel.org, martin.lau@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to bpf/bpf.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 Jan 2023 13:55:00 -0800 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 5 non-merge commits during the last 8 day(s) which contain
> a total of 5 files changed, 112 insertions(+), 18 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2023-01-04
    https://git.kernel.org/bpf/bpf/c/49d9601b8187

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


