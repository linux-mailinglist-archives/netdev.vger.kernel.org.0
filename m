Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7975F59F9B1
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbiHXMUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbiHXMUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCC51EAC3;
        Wed, 24 Aug 2022 05:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A54C6198D;
        Wed, 24 Aug 2022 12:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8D5BC43141;
        Wed, 24 Aug 2022 12:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661343614;
        bh=8SMMHB7PtUxZNv3hf0+GbpG8cVRLUfp6evHlCrCt3y4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HUkYTe2K8O6hGhjo4Ogi0wTPS9ZRyYlMAao3o/clp0GReB/pLwXiHDvHPz7hQZCLG
         ep/B2XD/mVhoEXZNnUhnf4iP2RaO1HgGLa+jcVmOHBzw3bzUfaWjrwT7XzW7OiwjUY
         +DY56EjgWwNuoo3eeSRa0u+j1Gqa/MrP7Ktz8FbPNhqiN4+cXY7A1+RromOuZpRrs4
         PiB3Z3SQOZNaP4mbEjxWV/GX1aqb6Kc77dp3euL9DXfiHrLRRv4RWf14/GkUKzhZar
         pkoM9Eov0vMFDD2HH+8oYDqcWOJtlHepBskXAkv9v1JiWH4xsOUKjiLrjWuAcnwxqF
         htbV2OwcHAPCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9558AC04E59;
        Wed, 24 Aug 2022 12:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] net/core/skbuff: Check the return value of skb_copy_bits()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166134361460.15514.13686117599705580571.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 12:20:14 +0000
References: <20220823054411.1447432-1-floridsleeves@gmail.com>
In-Reply-To: <20220823054411.1447432-1-floridsleeves@gmail.com>
To:     lily <floridsleeves@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au
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
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Aug 2022 22:44:11 -0700 you wrote:
> skb_copy_bits() could fail, which requires a check on the return
> value.
> 
> Signed-off-by: Li Zhong <floridsleeves@gmail.com>
> ---
>  net/core/skbuff.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [v1] net/core/skbuff: Check the return value of skb_copy_bits()
    https://git.kernel.org/netdev/net/c/c624c58e08b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


