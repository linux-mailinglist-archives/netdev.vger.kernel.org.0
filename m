Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DD5560F90
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 05:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiF3DUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 23:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbiF3DUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 23:20:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DF940A38;
        Wed, 29 Jun 2022 20:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75391B827FB;
        Thu, 30 Jun 2022 03:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16732C341CA;
        Thu, 30 Jun 2022 03:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656559214;
        bh=DQg6ibDynoYcoqExVb/W9xu3z+AWl3sONWXlXNqrmoU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VS+IfqZ2W5qNpOmLcATfwuiVaKD/DoS/5GL4fm5OHoheMkuaRQMz7jIoAAXLDG4Uj
         IUlClOEmfYuRKPRAuE+KshoH5m/23rVKlmRrZeBjZ6tWuLr4vo29EvRNEHZZOKzO4t
         YcUBcJQAF7GoA+vsYtKF9rcnUDq3B1F0giyjRjOl4Zk9Eq6Gx/SUSfAnwlJgnLLjUj
         7/Buv3Sgu1HWAT4/dVz8iXAkrIlQpn5F5n7IvLj9HU7rT5puTeHyJTjz7CsaKFtcCd
         oH61mOnhKI6NoW57T6Ydm80A3RQI3WFmNKe3P+cPWNBskODpeU9wnptOedFvwj4vv/
         H8rlp0KrR7P2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EADAAE49FA0;
        Thu, 30 Jun 2022 03:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests net: fix kselftest net fatal error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165655921395.17409.13594561872528407248.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 03:20:13 +0000
References: <20220628174744.7908-1-dietschc@csp.edu>
In-Reply-To: <20220628174744.7908-1-dietschc@csp.edu>
To:     Coleman Dietsch <dietschc@csp.edu>
Cc:     linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 28 Jun 2022 12:47:44 -0500 you wrote:
> The incorrect path is causing the following error when trying to run net
> kselftests:
> 
> In file included from bpf/nat6to4.c:43:
> ../../../lib/bpf/bpf_helpers.h:11:10: fatal error: 'bpf_helper_defs.h' file not found
>          ^~~~~~~~~~~~~~~~~~~
> 1 error generated.
> 
> [...]

Here is the summary with links:
  - selftests net: fix kselftest net fatal error
    https://git.kernel.org/netdev/net/c/7b92aa9e6135

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


