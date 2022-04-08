Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B474F9EDA
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 23:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239737AbiDHVLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 17:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbiDHVLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 17:11:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF7ED112E;
        Fri,  8 Apr 2022 14:09:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9614B61F4E;
        Fri,  8 Apr 2022 21:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E91BAC385A9;
        Fri,  8 Apr 2022 21:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649452179;
        bh=ctz8WQ3vKMre+QNyDwXcKe5E06K2scqAFaURoxJnheQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=caqIH1P3c550eqqFd4LTN05WxLA1HMrfcEDTrB3uk4gxgnD/agcVpAl1ju0V8zjYh
         QrkOAjIU985pu/vpxGUw1dfZeacNwp+y7GaE69mRuy5PodiIiqMCqmxTBQPbXXrYXZ
         AzicUplt2F4ikDo1aItoAc23nbJKm1FDZZAwBf3AfcrymvkCMPb/hjhGTDrE4TndSA
         DJEXCePFvE8FTdFzK9CQaRW3vWVnbUZl522hzuCBjikiVW33fg2Mek4eD1QHVUezXm
         dXZk7wGgtbAahYoTpmTvPElxVKTc0Y0wuXOEWJMzsI9w+mbVLKipg4izncPPAO5sHa
         yNvGFL6MTCPVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4686E85B76;
        Fri,  8 Apr 2022 21:09:38 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Fix return value checks in
 perf_event_stackmap.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164945217886.693.13574650471014956022.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 21:09:38 +0000
References: <20220408041452.933944-1-ytcoode@gmail.com>
In-Reply-To: <20220408041452.933944-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     skhan@linuxfoundation.org, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, hengqi.chen@gmail.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, shuah@kernel.org, songliubraving@fb.com,
        yhs@fb.com
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

On Fri,  8 Apr 2022 12:14:52 +0800 you wrote:
> The bpf_get_stackid() function may also return 0 on success.
> 
> Correct checks from 'val > 0' to 'val >= 0' to ensure that they cover all
> possible success return values.
> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] selftests/bpf: Fix return value checks in perf_event_stackmap.c
    https://git.kernel.org/bpf/bpf-next/c/658d87687cd5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


