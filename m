Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3B667F996
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbjA1Qaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjA1Qay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:30:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD162069A;
        Sat, 28 Jan 2023 08:30:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4460DB80B56;
        Sat, 28 Jan 2023 16:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0CD7C433D2;
        Sat, 28 Jan 2023 16:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674923450;
        bh=SrptIqBOawipKfLslvwoYZ+bZA7dFj784uTMNshZQbs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H3zXIH98Xr3CEI+wv/UvyXsW8V+A65vNBEodkx5H/amIeNGHQyqaQEzLmnXZA74M3
         zRXrKpqMHHZj9nMe2MhEqkvLgEQW51CcLuGnfyZT8WlQ21BcIOAWKNYBJaqPPTAFEe
         f+2WYkmTqvZSQVwe6KynsxMO+4OgxcDaKFRbgF8vcZo8OC6dl09j8662X+71fG3H9E
         RcpYMzhhcDlScvqTSRbGXM8YY5gXVpaWxEymA4S3zLP100Zyutfaxu0XYgxzKMPDNj
         fgunAiWRJsFuvZOA8GfPQaSJrh4YQipfmvG2KChXv85jEThyrnO0RqOfvlBjoaEH+o
         j6sTlAXfegJ2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A7F6DC39564;
        Sat, 28 Jan 2023 16:30:50 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2023-01-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167492345068.32752.1097135392071783907.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 16:30:50 +0000
References: <20230127215820.4993-1-daniel@iogearbox.net>
In-Reply-To: <20230127215820.4993-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to bpf/bpf.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 27 Jan 2023 22:58:20 +0100 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 10 non-merge commits during the last 9 day(s) which contain
> a total of 10 files changed, 170 insertions(+), 59 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2023-01-27
    https://git.kernel.org/bpf/bpf/c/0548c5f26a0f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


