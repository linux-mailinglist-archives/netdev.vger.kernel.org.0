Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574F0509284
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 00:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351981AbiDTWN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 18:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244022AbiDTWNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 18:13:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AC21EC78;
        Wed, 20 Apr 2022 15:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 113A761994;
        Wed, 20 Apr 2022 22:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63495C385A1;
        Wed, 20 Apr 2022 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650492611;
        bh=G8vNznOpkTfw9H8uWYpTCo/GdOJHcgmx9HT492axnms=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K+RdLTX0e89xAbkcAcQ+gjKuzt/XZK3PmIdK90yJ0XuMANnvL7a7/j2W5xOYNmtx/
         9RMPipbdi4pnHVIa1iDI2AOoCyXGXbeho8jrYLk/jAt2rVaM7v84QxtOxHjHwAq6Gy
         b79bAoUIpavRumzL9sAiSxJzoMGjC5F/nS7nAznQDjltchxJLHGlY48YwnMw6qGjnk
         oKMspcQkU4jhswuSbaageo329NodoOz7aU2c+ZVP+jlUOqxWRqvEm4+K8CKqaNYN2+
         S9otFaNywXkvFPFHSCfoVC5ewwuCK7Qqm1jbYe9A2gnR3dv67xu+yuLKXqH4rxPMhD
         u9ggF4taw04zQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B81DE8DBD4;
        Wed, 20 Apr 2022 22:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] samples/bpf: reduce the sampling interval in
 xdp1_user
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165049261123.2236.3984383189414860962.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 22:10:11 +0000
References: <20220419114746.291613-1-shaozhengchao@huawei.com>
In-Reply-To: <20220419114746.291613-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Tue, 19 Apr 2022 19:47:46 +0800 you wrote:
> If interval is 2, and sum - prev[key] = 1, the result = 0. This will
> mislead the tester that the port has no traffic right now. So reduce the
> sampling interval to 1.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  samples/bpf/xdp1_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [bpf-next] samples/bpf: reduce the sampling interval in xdp1_user
    https://git.kernel.org/bpf/bpf-next/c/db69264f983a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


