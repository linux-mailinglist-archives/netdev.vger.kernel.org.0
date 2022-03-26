Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F644E7CF5
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiCZABw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 20:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiCZABv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 20:01:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014915DA43
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 17:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A000CB82A95
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 00:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51B5FC3410F;
        Sat, 26 Mar 2022 00:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648252812;
        bh=PaQ5IBPd/zxKULJqfaJuMRJCTSp/MuGVOEvoPEOFl8M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QNE5x6pzzShiAdDsMOOvwVWaFqeSKmvaMeiqPBemdd8naxGuokXjT/Ks9HMxyTBbU
         VnyoPUSwZtIVO4TPg23ntoaRaipYm80cp06hTbQN3kyk5UqeUwS2PhSPRwr3cnvMVz
         lpEeMwlugdiDjDuyBf/p4kXIx6FXE3kZdday4vpGmXk351/ckvppybAReV/5yH+746
         +XQ6RGBFh9moDIPHoyYPrlkOsa7if3DSCJ9hhl6zioVd51KO81U8e4JgJ4qol/V/tx
         oAyPr0PJyKSUty48417GjKMhzn7wjbKCnPsIyVyltSISThyVAJg5SOgsR1qi14LqDw
         dwhW4waugBHJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34C0BF03848;
        Sat, 26 Mar 2022 00:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] llc: only change llc->dev when bind() succeeds
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164825281221.29666.2719014687727840250.git-patchwork-notify@kernel.org>
Date:   Sat, 26 Mar 2022 00:00:12 +0000
References: <20220325035827.360418-1-eric.dumazet@gmail.com>
In-Reply-To: <20220325035827.360418-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com,
        syzkaller@googlegroups.com, beraphin@gmail.com, smanolov@suse.de
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 24 Mar 2022 20:58:27 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> My latest patch, attempting to fix the refcount leak in a minimal
> way turned out to add a new bug.
> 
> Whenever the bind operation fails before we attempt to grab
> a reference count on a device, we might release the device refcount
> of a prior successful bind() operation.
> 
> [...]

Here is the summary with links:
  - [net] llc: only change llc->dev when bind() succeeds
    https://git.kernel.org/netdev/net/c/2d327a79ee17

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


