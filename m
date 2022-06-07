Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A409953FD0D
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242610AbiFGLLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243286AbiFGLLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:11:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4413393D5;
        Tue,  7 Jun 2022 04:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A14BB81F69;
        Tue,  7 Jun 2022 11:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6967C34114;
        Tue,  7 Jun 2022 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654600213;
        bh=WNo/GKQfClkuUUNIAxhmLCRNfiQK1Xf045r+s/N/H8o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SQ86wqHt16s3t/HhIDRghw6tv1Fr4XmfFod2nVldf+4by1HHAr7y2iipnYixmHTgt
         AWTq6nbJ1dQ2y9rnFS1ynEcTefv2hGU2SUirZfJJMfLgSQpwixk5dwwinsu/M88nNR
         JNhIjl2Sn2nviAI0xAvOUKS4oWzhdjiMIuFVxpx/72E5uLcQ0xJCw/y8H90s3cvVRv
         jKF0Rr6cSFt+urdSSxmKroTrYhLZaWLoaGGj5xLFN3aZISDOGj4CBLrosI9Qz/weV4
         aQchIz9Jkk4QGZWQ9FC2Buk2jbuDKoLBsqRsYv7cI3pR6c9gLWauK/e0+d5N7qrQo6
         a5kuQVC9VXS+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7F43E737E2;
        Tue,  7 Jun 2022 11:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/3] reorganize the code of the enum
 skb_drop_reason
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165460021374.11944.12196215356756517705.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Jun 2022 11:10:13 +0000
References: <20220606022436.331005-1-imagedong@tencent.com>
In-Reply-To: <20220606022436.331005-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     kuba@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        nhorman@tuxdriver.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        imagedong@tencent.com, dsahern@kernel.org, talalahmad@google.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  6 Jun 2022 10:24:33 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> The code of skb_drop_reason is a little wild, let's reorganize them.
> Three things and three patches:
> 
> 1) Move the enum 'skb_drop_reason' and related function to the standalone
>    header 'dropreason.h', as Jakub Kicinski suggested, as the skb drop
>    reasons are getting more and more.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/3] net: skb: move enum skb_drop_reason to standalone header file
    https://git.kernel.org/netdev/net-next/c/ff8372a467fa
  - [net-next,v4,2/3] net: skb: use auto-generation to convert skb drop reason to string
    https://git.kernel.org/netdev/net-next/c/ec43908dd556
  - [net-next,v4,3/3] net: dropreason: reformat the comment fo skb drop reasons
    https://git.kernel.org/netdev/net-next/c/b160f7270e6d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


