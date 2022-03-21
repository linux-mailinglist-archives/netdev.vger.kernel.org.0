Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E45D4E321F
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 22:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiCUVBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 17:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiCUVBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 17:01:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FFD1A48AB;
        Mon, 21 Mar 2022 14:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BEA161241;
        Mon, 21 Mar 2022 21:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DAA4FC36AE3;
        Mon, 21 Mar 2022 21:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647896410;
        bh=vq3Zh4EGOgWiMcZ951jyiYAG72iRYycU18MOTKy+fZI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pLmc98LTRY+hv+rZqrtc3p8Ko2AwNn0JXtZZ9iZBTHSbZ2NDdgLwGgIkhwGdbzeZD
         OriKrHhiQZ8oLNT6v8al1EbzSNzFFemk8h1Wa9aXXx+kaR8x/cvV+v1GNvY7+Iedoa
         ACovD8WBRQJ4t/K/9woa6ZEpa9Gsnz3LpDPd8Tao0/MH/ruJV96BbyDh8bKeKS0ONp
         i7SJZ+Ad/UROt0z3HXsVN8g/Tr4pMGzRBzgowJU93TzuPZyBH7NX3qnePuOmADfyg0
         mVIYoHBCag8dbOvXzBum5qRSswITpVKDay2WHORu6x7cLCXWjL1KoTAB/SCzteSVoE
         TCsK3EGGGgoUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BFA06EAC081;
        Mon, 21 Mar 2022 21:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/2] fixes for bpf_prog_pack
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164789641078.12886.8468813279524303384.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 21:00:10 +0000
References: <20220321180009.1944482-1-song@kernel.org>
In-Reply-To: <20220321180009.1944482-1-song@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kernel-team@fb.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 21 Mar 2022 11:00:07 -0700 you wrote:
> Two fixes for issues reported by syzbot and kernel test robot.
> 
> Song Liu (2):
>   bpf: fix bpf_prog_pack for multi-node setup
>   bpf: fix bpf_prog_pack when PMU_SIZE is not defined
> 
>  kernel/bpf/core.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] bpf: fix bpf_prog_pack for multi-node setup
    https://git.kernel.org/bpf/bpf-next/c/96805674e562
  - [bpf-next,2/2] bpf: fix bpf_prog_pack when PMU_SIZE is not defined
    https://git.kernel.org/bpf/bpf-next/c/e581094167be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


