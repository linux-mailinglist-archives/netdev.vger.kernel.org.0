Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1576B52AF49
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbiERAkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbiERAkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1AE3D1D4;
        Tue, 17 May 2022 17:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A76EB614DB;
        Wed, 18 May 2022 00:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10911C34118;
        Wed, 18 May 2022 00:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652834413;
        bh=1FlRg+q3itx8/b3dLZmdvk32wKHYEcxROxHugqDE710=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UbyjKwt56rhEMgjUfdskjBJyOfy8K74KzhmgsjEOUyek1PO7OIyDlHgeaDybB6KF/
         JKDGO+oCoYMBvi5ytzSDizKYLu79vQA1UvwWcMBTjXY+119o6KrBnW/lMEFXVSKqeo
         8Ekx+hwu7w9jvsiJ5yG1aoj8hPWqSJ6i0ctxgF21HF0BBnoB5Vf3/UijTgY7dOD0cE
         5KwuAJHst3RalX0BSG0moN7e3Xqx45kLci+kupWTj6rRuv+l44QjzjvwT3vpg9DWNk
         x4VRFwa0ba/9NPnUWFJfqRHYN2AKKwUnONH1zX7au4qPQ4sKp+k8FIaup1V3sYO+rp
         lhfrexIgTjurQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ED06BF03939;
        Wed, 18 May 2022 00:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/2] net/smc: send and write inline optimization
 for smc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165283441296.18628.6204960999595052855.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 00:40:12 +0000
References: <20220516055137.51873-1-guangguan.wang@linux.alibaba.com>
In-Reply-To: <20220516055137.51873-1-guangguan.wang@linux.alibaba.com>
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
        tonylu@linux.alibaba.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 16 May 2022 13:51:35 +0800 you wrote:
> Send cdc msgs and write data inline if qp has sufficent inline
> space, helps latency reducing.
> 
> In my test environment, which are 2 VMs running on the same
> physical host and whose NICs(ConnectX-4Lx) are working on
> SR-IOV mode, qperf shows 0.4us-1.3us improvement in latency.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] net/smc: send cdc msg inline if qp has sufficient inline space
    https://git.kernel.org/netdev/net-next/c/b632eb069732
  - [net-next,v3,2/2] net/smc: rdma write inline if qp has sufficient inline space
    https://git.kernel.org/netdev/net-next/c/793a7df63071

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


