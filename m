Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB71662670C
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbiKLEu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbiKLEuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:50:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCDDDB8;
        Fri, 11 Nov 2022 20:50:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E6A0B828AD;
        Sat, 12 Nov 2022 04:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADDC8C433B5;
        Sat, 12 Nov 2022 04:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668228621;
        bh=X1oN0J+zXSJDkg/gmDDzsyLAs0ESOPf0QVbl7gVzh8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oFeQCGFBveaY9OB4mTTMU3O1Qkhi31B9XOjN3YA70KL5V4cuNbflPDL+B5k/zLaN0
         Cytu75BS537S7oTqKlEG9rY27zlYvWKg+K89cmVmJHmlpKLXYlVHNon4zSfxWH+ME1
         3wenk/uy1lUU1qr9nc0sP2rMo5cxc9hA0LBBwUYEFX28zvLSoPYTppjkgqm6C7VntV
         5OSO3jafAsuktBlMndK2VWBNxHr5z1mWq/5ud85ZKGPrvg13adcCFoRjicRpNNAbVT
         M7/7v6IixYLwWj4+jhVn++u+yOlgshhowUjVJ8qW3srBwQhvx/Ln7dyQ2JCGU/MbI4
         BVwRi6kNJNzvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 95825C395F7;
        Sat, 12 Nov 2022 04:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-11-11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166822862160.12539.1296563144301803906.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 04:50:21 +0000
References: <20221111233733.1088228-1-andrii@kernel.org>
In-Reply-To: <20221111233733.1088228-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 11 Nov 2022 15:37:33 -0800 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 49 non-merge commits during the last 9 day(s) which contain
> a total of 68 files changed, 3592 insertions(+), 1371 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-11-11
    https://git.kernel.org/netdev/net-next/c/f4c4ca70dedc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


