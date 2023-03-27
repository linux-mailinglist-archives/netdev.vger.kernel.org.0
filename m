Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E276C9D0E
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbjC0IAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjC0IAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DAB4685;
        Mon, 27 Mar 2023 01:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3FCF61042;
        Mon, 27 Mar 2023 08:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2B68C433EF;
        Mon, 27 Mar 2023 08:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679904019;
        bh=9ySR9UOyQlkYt24hLL/e6CMGlP26H3qYJtgXugM5zcU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uB3GfZls10PqB/xYkP24YnAoaMwSAG/vZuMow7pMO/ybMhoXDP7xVEjH97nS4r14N
         XrnJzJ+9OXnUHDzAGMQpTWf/JNwS6BmLwx6NfpKEv+x+Px009QowDFacqLu93vvfyj
         wSTK9GBicTkNPiP3rgPpbipdo2Fkl2d1bD8Gss8/qmhcuu4CA6MHCHAF/HiWYJJ6Zp
         a7ycocGCrvEnylf6X+Geitwic8cO+UKeqTGSkwcMIUQ9Pf9HCSVE4q0/rTRy7i+1Kn
         BO/eHnrryRROdxg+il8C4Goi37R7QGgTkaukS+tsTK1USzW3/G5hyQs2YMoLAkargE
         rfmR8p/IFuJcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D63F9E4D02F;
        Mon, 27 Mar 2023 08:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: tls: add a test for queuing data before
 setting the ULP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167990401887.27318.15104190928200538935.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Mar 2023 08:00:18 +0000
References: <20230324181757.2407412-1-kuba@kernel.org>
In-Reply-To: <20230324181757.2407412-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Mar 2023 11:17:57 -0700 you wrote:
> Other tests set up the connection fully on both ends before
> communicating any data. Add a test which will queue up TLS
> records to TCP before the TLS ULP is installed.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: shuah@kernel.org
> CC: linux-kselftest@vger.kernel.org
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: tls: add a test for queuing data before setting the ULP
    https://git.kernel.org/netdev/net-next/c/a504d246d212

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


