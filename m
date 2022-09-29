Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B904C5EF117
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 11:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbiI2JAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 05:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiI2JAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 05:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDCE6CF49
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28307620AC
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 09:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E9F4C433D7;
        Thu, 29 Sep 2022 09:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664442016;
        bh=MiUy1pGezA7LkTOTxuMgTRi625O0Gi856lm9eGTJEbk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fv89+3wJyMMJphD7tY4fBoenRlbhTvJlXK8M7b+/lQI7tZC+Xh/l/2zIwqId0zP49
         M9q09BOjetDvElSChgKfs+UvUb9w+edP0i0gI28X4qfgoxf5TiXnuz8Vn/+U0lL+e5
         C5l3IrxxFqhiRg6QjQeGNWJ9XEMiS5VWOmgdtmacCoxqebNLNg79lCT2XYPVdml8Jc
         RvPCCIMljN9FPteDgtpwag20nxzkblemzjQV6D4oCYfYvpuE1f/Kt1ckUzZ7EKsJvx
         6Na4Ats74y+RbctNQ8czptQPhf+eYfrdnv+qXXAvHyitaKhMsSQkMLasLDvWpDC4gt
         9U4BUAIYEymog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CB00E4D01B;
        Thu, 29 Sep 2022 09:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v2] nfp: Use skb_put_data() instead of skb_put/memcpy
 pair
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166444201624.32085.4180071358048072222.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 09:00:16 +0000
References: <20220927141835.19221-1-shangxiaojing@huawei.com>
In-Reply-To: <20220927141835.19221-1-shangxiaojing@huawei.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        niklas.soderlund@corigine.com, oss-drivers@corigine.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 27 Sep 2022 22:18:35 +0800 you wrote:
> Use skb_put_data() instead of skb_put() and memcpy(), which is clear.
> 
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
> changes in v2:
> - no change
> 
> [...]

Here is the summary with links:
  - [-next,v2] nfp: Use skb_put_data() instead of skb_put/memcpy pair
    https://git.kernel.org/netdev/net-next/c/d49e265b66d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


