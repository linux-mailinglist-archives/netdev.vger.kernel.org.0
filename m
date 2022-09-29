Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D849B5EEBA1
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbiI2CUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbiI2CU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:20:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F633A1D3D
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 008EFB821C1
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0C7EC43147;
        Thu, 29 Sep 2022 02:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664418021;
        bh=PSr17JTcnZLzWxo3pQ5eurpGAkgLuP4yaCcZ0MWPVHg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PekEiBv6zQOQ5rdCTzU3AD4gFR/hnhlVFGtscVGjQ5F7+2py2PhS+YluVEQcKIpuI
         vomymjiDYh1eAk5NMyEH3lIKsekGqf88ks4cMExWBvMjP9v/1/XO2z3IFqCoWwCL7M
         oANyOpdWvNrmIn8K6vvaPpr56Ulw0nkwexNmnI6fBjNoJrVUJh8ObgrDFCs3tgOl4q
         bHqfBZHHfrWdwFfQELeGqYE+TYcA5GNEqHdrXxf65ilKac6k5yHKVXrmRi0EWBlUFM
         hf5da2r5YVVo9vSpoBLD58icI/9su0jCP9fKqbJquGMs8jUPF/mKW3RmRdI5H+XuRq
         nMladxgR9EaXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A7D0C395DA;
        Thu, 29 Sep 2022 02:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Fix incorrect address comparison when searching
 for a bind2 bucket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166441802156.18961.11257773505760240774.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 02:20:21 +0000
References: <20220927002544.3381205-1-kafai@fb.com>
In-Reply-To: <20220927002544.3381205-1-kafai@fb.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, kernel-team@fb.com, pabeni@redhat.com,
        joannelkoong@gmail.com, glider@google.com, martin.lau@kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 26 Sep 2022 17:25:44 -0700 you wrote:
> From: Martin KaFai Lau <martin.lau@kernel.org>
> 
> The v6_rcv_saddr and rcv_saddr are inside a union in the
> 'struct inet_bind2_bucket'.  When searching a bucket by following the
> bhash2 hashtable chain, eg. inet_bind2_bucket_match, it is only using
> the sk->sk_family and there is no way to check if the inet_bind2_bucket
> has a v6 or v4 address in the union.  This leads to an uninit-value
> KMSAN report in [0] and also potentially incorrect matches.
> 
> [...]

Here is the summary with links:
  - [net-next] net: Fix incorrect address comparison when searching for a bind2 bucket
    https://git.kernel.org/netdev/net-next/c/5456262d2baa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


