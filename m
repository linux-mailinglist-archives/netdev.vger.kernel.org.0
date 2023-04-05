Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E2D6D8601
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 20:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbjDESaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 14:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDESaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 14:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450B210E6;
        Wed,  5 Apr 2023 11:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D758963FDD;
        Wed,  5 Apr 2023 18:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 225C7C433D2;
        Wed,  5 Apr 2023 18:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680719418;
        bh=eC5lvqoT/q5ShJSZpTkIfYCwnUt/o1ct3RNlGhkzaoI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eTltNe+Ba+LbO0e+ZBlC0h1BY4DyZconlM2o52CNyo3qe/XjLniM75scQ6gLjasq3
         8tDDphRs60xpFjj6Obc5u5yBwvO29HeO6QxOLpWf6KcBMrtnVqpcjIJNVIzpj1IMJV
         643hmQ1bawkn5iKGLMgpCVS87BKb2Ip+aR5SGBA3gGNHlRZdUiNFYYuE8YU4jwd5yP
         Dwff1zb5soCTUT5d9pEP5h96xdy5ypUsbfQy4ndALwNlSHhradkuZfwLFv52nI1z82
         JtdgDCLMZQu0EWoHzpcegqIVDUqBbAu6y6iqvDAxPXT0k3CgAQclV36UAg4dhOnQ+d
         fVu4Dfo5zBGBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EF817E29F4C;
        Wed,  5 Apr 2023 18:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests: xsk: Add xskxceiver.h dependency to
 Makefile
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168071941796.18884.13193055443894349169.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Apr 2023 18:30:17 +0000
References: <20230403130151.31195-1-kal.conley@dectris.com>
In-Reply-To: <20230403130151.31195-1-kal.conley@dectris.com>
To:     Kal Conley <kal.conley@dectris.com>
Cc:     andrii@kernel.org, mykolal@fb.com, ast@kernel.org,
        daniel@iogearbox.net, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        shuah@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Mon,  3 Apr 2023 15:01:51 +0200 you wrote:
> xskxceiver depends on xskxceiver.h so tell make about it.
> 
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  tools/testing/selftests/bpf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [bpf-next] selftests: xsk: Add xskxceiver.h dependency to Makefile
    https://git.kernel.org/bpf/bpf-next/c/9af87166944b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


