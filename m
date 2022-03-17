Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795A74DC90E
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbiCQOli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235194AbiCQOld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:41:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47559186F9E;
        Thu, 17 Mar 2022 07:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCA66B80122;
        Thu, 17 Mar 2022 14:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29DE1C340F2;
        Thu, 17 Mar 2022 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647528010;
        bh=W+C/rY1F7cscNtkzq88lgvhn6XE+laUchKkk4A1EC+0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q6JAGE+VyUhFhCkX3PD7XHPPELlF3bfE091Lmj+8XBeTIICABOIxm0uOg8oNWTREj
         8+K5hVpooma9/YUm7RF8D/WLgZd0hFbH+1ohXzIfB0lR4DaE6iRG+pYJNF1YbXQDNL
         +VFob51SLCFsp4jkc0Fq9VjJATIHNu2TgahDGsftVfctH38FVo2xoBYJM/K+0rYW5D
         KM9JUQbeKR39xXD7IntI+F1qQX3OR8v9lfU+OGgRPMXUxq0Zl4gopkGyvRf5TQ/InI
         e4KJuU6dematLm31gyVd+tLsdxLbwBSOURttk5/3Kdtf87xHiHxWTpkkS0EtbaG55O
         5p9bYX3Ybz9Mg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 073BCF0383F;
        Thu, 17 Mar 2022 14:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: net: fix array_size.cocci warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164752801002.21318.2421302537534313985.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 14:40:10 +0000
References: <20220316092858.9398-1-guozhengkui@vivo.com>
In-Reply-To: <20220316092858.9398-1-guozhengkui@vivo.com>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        zhengkui_guo@outlook.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 16 Mar 2022 17:28:57 +0800 you wrote:
> Fix array_size.cocci warning in tools/testing/selftests/net.
> 
> Use `ARRAY_SIZE(arr)` instead of forms like `sizeof(arr)/sizeof(arr[0])`.
> 
> It has been tested with gcc (Debian 8.3.0-6) 8.3.0.
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> 
> [...]

Here is the summary with links:
  - selftests: net: fix array_size.cocci warning
    https://git.kernel.org/netdev/net-next/c/1abea24af42c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


