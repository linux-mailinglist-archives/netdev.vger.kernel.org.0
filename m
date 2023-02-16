Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225AA698C34
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 06:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjBPFk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 00:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjBPFkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 00:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07ED8684
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 21:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F6D5B823E0
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22172C433D2;
        Thu, 16 Feb 2023 05:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676526018;
        bh=yiMmJqHmOmbRZ3OhAXp/119NFgnd4v/TlUWL/a6aZJI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k5QkznrXz27HpBhVukUXZ9EYO9r2eqS2edBKq9Q1N3oN1NFDcsGCD4NNlyEldFhCo
         AEVb7nhBhlkvh6Q1/AxEcP2xxDK8EZn+0nlaIlHX5eeRe75J//eYIIzk5EcQEEE4Iw
         Op+hV7ekEffwIm37TBJTepqNOGOliyYnzzTD4+AlO54ad52SFKXzoUGDGB5sx/hCZU
         JB3PUOcdVfKIrTGZ+Kv/yCbCA5PHOiUgssArusmLJ7Zhc2JiWNwEYW8De3j82AvkAC
         xj+oTcbJZhS2d8C1DGtwfRB2rP5jz63oFP5JBKzkQ5fy5UpWd8J/i6cSLpxvVmeZAr
         99zQor3RfBa1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3A07E29F3F;
        Thu, 16 Feb 2023 05:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: forwarding: tc_actions: cleanup temporary
 files when test is aborted
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167652601798.11549.12923717745347802742.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 05:40:17 +0000
References: <091649045a017fc00095ecbb75884e5681f7025f.1676368027.git.dcaratti@redhat.com>
In-Reply-To: <091649045a017fc00095ecbb75884e5681f7025f.1676368027.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     davem@davemloft.net, shuah@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 14 Feb 2023 10:52:37 +0100 you wrote:
> remove temporary files created by 'mirred_egress_to_ingress_tcp' test
> in the cleanup() handler. Also, change variable names to avoid clashing
> with globals from lib.sh.
> 
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: forwarding: tc_actions: cleanup temporary files when test is aborted
    https://git.kernel.org/netdev/net-next/c/f58531716ced

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


