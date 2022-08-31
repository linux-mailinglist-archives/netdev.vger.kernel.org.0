Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8D45A75F2
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 07:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiHaFuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 01:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiHaFuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 01:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE6E4454B
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 22:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FF4F61695
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 05:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 656D2C433D7;
        Wed, 31 Aug 2022 05:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661925014;
        bh=zd38yHEPjIzFh6JXmP0wvE2Lm0wzoCjW8kPDs2v/X4s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d8u4U1q/K6BHQN5B7giBGKh4btEO2DsnPmZk8Na3KuqWIKlB42EG+qywpsWKhPd6G
         xZSiTnVaYyCfAbT+eSzm7RDV9/lsyJuO1g4GlSm8zI0zILCGcc0GVmICaCqtLY5vEt
         qff3deROthEe1wRj2G6oWuoZYwh7B0YnDdYrGq6UzCTDgCSGR9kDr+Ug20fH3wxDjO
         Y+t5EZzpK3xqST2WdmxQ7f9yWlIZdVUkhRZgq2BYQxq9PbZ5F54Ci6lkjEFZLHmFUj
         Guc59Nn6MgKkU6mlErJtqbpxVjZnwNTK/gwogM+95i9Kqz/OlOPBe+utL899V3Ul4r
         8VdJ1rTNlmNHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4DF33E924DB;
        Wed, 31 Aug 2022 05:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: virtio_net: fix notification coalescing comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166192501431.15694.14643084506747072925.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 05:50:14 +0000
References: <20220823073947.14774-1-alvaro.karsz@solid-run.com>
In-Reply-To: <20220823073947.14774-1-alvaro.karsz@solid-run.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Aug 2022 10:39:47 +0300 you wrote:
> Fix wording in comments for the notifications coalescing feature.
> 
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> ---
>  include/uapi/linux/virtio_net.h | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Here is the summary with links:
  - net: virtio_net: fix notification coalescing comments
    https://git.kernel.org/netdev/net/c/fce1c23f6291

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


