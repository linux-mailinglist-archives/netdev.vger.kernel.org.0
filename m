Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63755385CE
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 18:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240922AbiE3QCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 12:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241929AbiE3QCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 12:02:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0A562D8
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 09:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D34661164
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 16:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8250FC3411A;
        Mon, 30 May 2022 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653926414;
        bh=u1eWL59vowGbrC+q0HMh/8rR6rgO4eSCKlckxKf6Q3w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l86/rDXCg/qQoKOCPAuRBktP57FDXon18Mb1T1V+nOpzVvrPZ55f/uoVTPYivyTPE
         hlwRc5Jq7NxvMN8yHZFQIcT2UolQ/LJ3AlPR7//uJOMTdhaEty6Q9/MDYMUFwCfyig
         uYeFVfQP3Gr/tY4j5KM/qhAMgOgqnfiysWimUANUD63OPlV2VhI+AeXiLIIE3fde10
         x13MoV9rXRs1F2dSlAgDppc6Yyiqjzm+3G+Wh/c5eQPf9LpducwGyfqNQUIezN5Wed
         3je6q4SJEPeaaCBuWgap5cz1rox8ZuS6EsuNEL0VGCbvsy0Ta3eK7WsCnrPEEVmZkq
         E74kwBusO0bjQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65860F0383D;
        Mon, 30 May 2022 16:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/7] ss: Introduce -T, --threads option
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165392641441.20842.58115426606128949.git-patchwork-notify@kernel.org>
Date:   Mon, 30 May 2022 16:00:14 +0000
References: <cover.1653446538.git.peilin.ye@bytedance.com>
In-Reply-To: <cover.1653446538.git.peilin.ye@bytedance.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     stephen@networkplumber.org, dsahern@kernel.org,
        netdev@vger.kernel.org, peilin.ye@bytedance.com,
        richard_c_haines@btinternet.com, cong.wang@bytedance.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 24 May 2022 19:51:15 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Hi all,
> 
> This patchset adds a new ss option, -T (--threads), to show thread
> information.  It extends the -p (--processes) option, and should be useful
> for debugging, monitoring multi-threaded applications.  Example output:
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/7] ss: Use assignment-suppression character in sscanf()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=2d866c6d93db
  - [iproute2-next,2/7] ss: Remove unnecessary stack variable 'p' in user_ent_hash_build()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=b38831bc23c4
  - [iproute2-next,3/7] ss: Do not call user_ent_hash_build() more than once
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=cd845a85681b
  - [iproute2-next,4/7] ss: Delete unnecessary call to snprintf() in user_ent_hash_build()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=ea3b57ec3991
  - [iproute2-next,5/7] ss: Fix coding style issues in user_ent_hash_build()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=210018bfe99b
  - [iproute2-next,6/7] ss: Factor out fd iterating logic from user_ent_hash_build()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=12d491e58ff5
  - [iproute2-next,7/7] ss: Introduce -T, --threads option
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=e2267e68b9b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


