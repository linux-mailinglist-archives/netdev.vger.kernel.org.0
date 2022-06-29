Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83A8560BE5
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 23:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiF2VkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 17:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiF2VkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 17:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7F61A056;
        Wed, 29 Jun 2022 14:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B505B8277D;
        Wed, 29 Jun 2022 21:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBBA8C385A2;
        Wed, 29 Jun 2022 21:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656538813;
        bh=Ixcyyum6LRqqQpRT0KSQ75ZzpbRcr+HgSNdzTTYfdbA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hPFz4u/vhHZM9VKQ+ZfpB16HZ1PjAMJRZG8gcMFZohx3aZyJU4BsrWCuiCCTwlims
         Wj4+Sv41WRF5hVwh9y47mLyhTrp+m4WXvhTb1RX1TPjQD9gt3ZNKj/dJhqGOGq0rQT
         wWV3cAxnrBuzeRjqvECnz+8ZKQAXfra4tU5DIAtFVsy44B/hzNx1CDtXs1lHNhC/j7
         DKdYCB5BronJikN8RIRyI1RafuPAIlDA1nNHASsKmshV8NaE4z4HD/tT8BBhAwGGvt
         jiLhgKUX/KmvpycPy7itSqg2QEvybcxv9XbxU3ZRN54A2dkW+syevXvcKOvQu9NNih
         5t/0AyStrDZBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9FB87E49BBA;
        Wed, 29 Jun 2022 21:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] bpftool: Probe for memcg-based accounting before
 bumping rlimit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165653881365.30550.15940066910957186806.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 21:40:13 +0000
References: <20220629111351.47699-1-quentin@isovalent.com>
In-Reply-To: <20220629111351.47699-1-quentin@isovalent.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, sdf@google.com, laoar.shao@gmail.com
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

On Wed, 29 Jun 2022 12:13:51 +0100 you wrote:
> Bpftool used to bump the memlock rlimit to make sure to be able to load
> BPF objects. After the kernel has switched to memcg-based memory
> accounting [0] in 5.11, bpftool has relied on libbpf to probe the system
> for memcg-based accounting support and for raising the rlimit if
> necessary [1]. But this was later reverted, because the probe would
> sometimes fail, resulting in bpftool not being able to load all required
> objects [2].
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] bpftool: Probe for memcg-based accounting before bumping rlimit
    https://git.kernel.org/bpf/bpf-next/c/f0cf642c56b7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


