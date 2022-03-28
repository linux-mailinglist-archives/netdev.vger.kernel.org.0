Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923AD4E9BFB
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 18:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiC1QMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 12:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241406AbiC1QL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 12:11:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A58253B68;
        Mon, 28 Mar 2022 09:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7B4361446;
        Mon, 28 Mar 2022 16:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 232FAC340F3;
        Mon, 28 Mar 2022 16:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648483814;
        bh=C56vqohSF2+qE/1ERNm3Se9n5cXzJDxUNt6M2glu0BM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pQpD8xYFWVRNej1bWR8inZi78pgTDL3Sr/X3H/4UgTsJ7W/jpY/5Pj2Ja03nmQojD
         OlnCseDaHZQ+GS4QrdMWG5iwgwgW2naZ8ni5xAWNt/ANdvxG2YeDisMzXNldTS6zQt
         MVNeWEVSeXQa7ohwPmfdwZv1oH3VP7JbrLfRzUKNjgTcYLANDA8gus/8wwZfDu7TIR
         B8wc9lvLh/UmUWmExeAoYaBwDbCtSpnsJO91JoshmqraXQzhqzZeVmJST3C8HWhSKL
         NXQvkeEoXhqnuVJ/U9YW57O0W4TMTO2bR23skwVRFbm5r0njJWASaPFO8WUuVcwrm0
         6zv8pNZXBl8Ng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F0A24E7BB0B;
        Mon, 28 Mar 2022 16:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: net: Add tls config dependency for tls selftests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164848381397.17422.14353941842854525376.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Mar 2022 16:10:13 +0000
References: <20220328134650.72265-1-naresh.kamboju@linaro.org>
In-Reply-To: <20220328134650.72265-1-naresh.kamboju@linaro.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, kuba@kernel.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lkft@linaro.org
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

This patch was applied to bpf/bpf.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 28 Mar 2022 19:16:50 +0530 you wrote:
> selftest net tls test cases need TLS=m without this the test hangs.
> Enabling config TLS solves this problem and runs to complete.
>   - CONFIG_TLS=m
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 
> [...]

Here is the summary with links:
  - selftests: net: Add tls config dependency for tls selftests
    https://git.kernel.org/bpf/bpf/c/d9142e1cf3bb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


