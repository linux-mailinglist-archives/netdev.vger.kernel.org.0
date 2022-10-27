Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1ED60EEA0
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiJ0DbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbiJ0Dao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:30:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9657E255BE
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 20:30:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D9F2B824BA
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 03:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BFBDC4347C;
        Thu, 27 Oct 2022 03:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666841425;
        bh=L/XF3J7bJEdXzS+pdwNv8v1uKCPPMZVhOTC3xBdrPrY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=anEre0z6BI1pOGRpTMqbXlj9LvqSKPrjeiAC2LFuwoZtptDzYyyvx6ayjbijMmZXA
         Si0UkD46U9IzPPtWqJ8kAKb8iqld17vvQ7Om+CubLaMobOsRT3tospP4A7l9j8n0fu
         uxzFI6yDiG7ZQyfVCVfsujn2sbbc36O2v4DMP9gCSplydgRNIpkoyMiLdoirok2lkK
         2QT9aQ0hZvD/jggAQ7JLkkhNNQ9CD0gnzKc8fGgjPP7nanzXvnriRKbLiGGtv84hgE
         1z0mPg6dFzCMKdUlXCvSIMmMHszlDimkX2avSu/YLvP4DWDJ73WD/xUNm2hy8N6nXa
         azn1wrJshV7lQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EF2FBE4D003;
        Thu, 27 Oct 2022 03:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: tc-testing: Add matchJSON to tdc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166684142497.32384.16234624278724376378.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 03:30:24 +0000
References: <20221024111603.2185410-1-victor@mojatatu.com>
In-Reply-To: <20221024111603.2185410-1-victor@mojatatu.com>
To:     Victor Nogueira <victor@mojatatu.com>
Cc:     davem@davemloft.net, jiri@resnulli.us, kuba@kernel.org,
        netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        edumazet@google.com, pabeni@redhat.com, jeremy@mojatatu.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 24 Oct 2022 11:16:03 +0000 you wrote:
> This allows the use of a matchJSON field in tests to match
> against JSON output from the command under test, if that
> command outputs JSON.
> 
> You specify what you want to match against as a JSON array
> or object in the test's matchJSON field. You can leave out
> any fields you don't want to match against that are present
> in the output and they will be skipped.
> 
> [...]

Here is the summary with links:
  - selftests: tc-testing: Add matchJSON to tdc
    https://git.kernel.org/netdev/net-next/c/95d9a3dab109

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


