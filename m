Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A368410B91
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 14:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhISMbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 08:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhISMbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 08:31:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 812A96126A;
        Sun, 19 Sep 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632054607;
        bh=5GuwBvIei7SQsp0//NdDIDMmyxyqjw2gFLgRfaDSoEg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MQAJu1KrK+fmlRyMPvdi/WPkVELdojbARGGEG2no1TCn7C2QlXJ5fLA6/vARH1NNp
         E7DhQNVhr/iSpWE/tSnJ5M0qWQXxYt/nFjS8Ckz/i4Mlmu7TsK0RfN7vR6yS2yXVLv
         G0duTiPvWv5TuOXyDli7u/faRM4hnsv8B2SSvDqy8GSuMCqGiqVhByvFJ/gTHYx/nh
         1CklPTy2nShtZDcB4+UNXJFio+Qyl4S/638oOxVCcIt/1/SI59ClN3HcrGn3DcOImm
         OTEBgCRx8r1UaACQS4A2Y0bs32mmIVpn18LIP4cseWhp94pMiVHk+odlsWxZVym23y
         n1Ybs+ZKejjdA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 75B6760A2A;
        Sun, 19 Sep 2021 12:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: net: af_unix: Fix makefile to use TEST_GEN_PROGS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205460747.12471.18162549656003560869.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 12:30:07 +0000
References: <20210917215356.33791-1-skhan@linuxfoundation.org>
In-Reply-To: <20210917215356.33791-1-skhan@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 17 Sep 2021 15:53:56 -0600 you wrote:
> Makefile uses TEST_PROGS instead of TEST_GEN_PROGS to define
> executables. TEST_PROGS is for shell scripts that need to be
> installed and run by the common lib.mk framework. The common
> framework doesn't touch TEST_PROGS when it does build and clean.
> 
> As a result "make kselftest-clean" and "make clean" fail to remove
> executables. Run and install work because the common framework runs
> and installs TEST_PROGS. Build works because the Makefile defines
> "all" rule which is unnecessary if TEST_GEN_PROGS is used.
> 
> [...]

Here is the summary with links:
  - selftests: net: af_unix: Fix makefile to use TEST_GEN_PROGS
    https://git.kernel.org/netdev/net/c/e30cd812dffa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


