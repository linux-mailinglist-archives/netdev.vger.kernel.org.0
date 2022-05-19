Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E911D52C88D
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 02:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbiESAUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 20:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiESAUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 20:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91578BD3B;
        Wed, 18 May 2022 17:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3575617A0;
        Thu, 19 May 2022 00:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3490AC385A9;
        Thu, 19 May 2022 00:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652919612;
        bh=jRp6y1bDxc2yAiFV8gQbgEIBEpjOZYAWnd8HQTx1XdQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rhUHTsI9ecC7aJ9b/TWprqiIHwYxusjOakrlL/NmALufD5VnJ9TxWQhw1tLMLzzzK
         oszoassqpgEAN5avX0h2bqhNM/U8Z1/Qg0uHQkCTCdC0jNGL+z6+VaRm7JlGevGfIg
         UEl83ABUZsC2de3SGY2BzSvzGcpvxUMBuw1XRlwnhO2kuyf4f2CDoUkdQiRJ5EXgCZ
         +b8IVAea3wOkJCVrTzobmw8p/SkhQ8NuZc9xzKFVSkJZzikKSVkZsEUoAin6+P2i39
         KYNbwiN7Wf1lD6ME3eDIPL+X+rUanjfQHLFrhGxrwQzA4XyaugI4nT65mWzejQMcP+
         DskF5e3c1LOEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19E01F0392C;
        Thu, 19 May 2022 00:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 bpf-next] selftests/bpf: add missed ima_setup.sh in Makefile
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165291961210.22195.3504343038749230473.git-patchwork-notify@kernel.org>
Date:   Thu, 19 May 2022 00:20:12 +0000
References: <20220516040020.653291-1-liuhangbin@gmail.com>
In-Reply-To: <20220516040020.653291-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, bpf@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net, m.xhonneux@gmail.com, lmb@cloudflare.com,
        u9012063@gmail.com, toshiaki.makita1@gmail.com, brouer@redhat.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Andrii Nakryiko <andrii@kernel.org>:

On Mon, 16 May 2022 12:00:20 +0800 you wrote:
> When build bpf test and install it to another folder, e.g.
> 
>   make -j10 install -C tools/testing/selftests/ TARGETS="bpf" \
> 	SKIP_TARGETS="" INSTALL_PATH=/tmp/kselftests
> 
> The ima_setup.sh is missed in target folder, which makes test_ima failed.
> 
> [...]

Here is the summary with links:
  - [PATCHv3,bpf-next] selftests/bpf: add missed ima_setup.sh in Makefile
    https://git.kernel.org/bpf/bpf-next/c/70a1b25326dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


