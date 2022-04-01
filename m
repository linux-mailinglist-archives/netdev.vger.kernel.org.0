Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1ACC4EFBBB
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 22:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352518AbiDAUmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 16:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352462AbiDAUmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 16:42:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BF8174BB5;
        Fri,  1 Apr 2022 13:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C1F7B82648;
        Fri,  1 Apr 2022 20:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 083B8C34110;
        Fri,  1 Apr 2022 20:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648845624;
        bh=iBSbCmnJn0tLSWLCsWdFOU49SO8FzjCl2RMQsZ/9F3s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FhDRsYYlDiduPJ8mWW2mUyblB4vYl7KnAKxN4oG6Fw+IYhQNMoG1Lg+hzxN82iARO
         kKOvg/zfzOkKrxJIZpHTBc1o+AKPC9zdpqGglHVSCa3ndBI+8kUfmo+/e25Mpb7p+3
         lRJHU3dReukWjhNsEDqJU8po37gDCxbNUfRNLQAp7fIefbEYHG4qoyDYjMiE6Sz1wX
         KH1vGrzZK62J9MaO1gWWI4f9TI7P9aBcJnzCLy/8tjN6UV/SlklEjfxfsYvSl6FHX1
         32c60E+DGIZ699MpOO5/q90CLmLh/KeZhge7vM/4KUWRw/vCBEhAHvIP6iyGa35cJN
         eU5uEonpc8TXQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9B1EF03849;
        Fri,  1 Apr 2022 20:40:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: Use swap() instead of open coding it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164884562388.7178.8772575945736654263.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Apr 2022 20:40:23 +0000
References: <20220322062149.109180-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20220322062149.109180-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 22 Mar 2022 14:21:49 +0800 you wrote:
> Clean the following coccicheck warning:
> 
> ./kernel/trace/bpf_trace.c:2263:34-35: WARNING opportunity for swap().
> ./kernel/trace/bpf_trace.c:2264:40-41: WARNING opportunity for swap().
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - bpf: Use swap() instead of open coding it
    https://git.kernel.org/bpf/bpf-next/c/11e17ae42377

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


