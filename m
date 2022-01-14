Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AADD48E92B
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 12:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240824AbiANLaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 06:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240785AbiANLaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 06:30:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828C3C061574;
        Fri, 14 Jan 2022 03:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04DCC61F19;
        Fri, 14 Jan 2022 11:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4255C36AF8;
        Fri, 14 Jan 2022 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642159810;
        bh=gURMWjjcQAIYtK0XBHscJTqO17bvPfXKd7/Gxz6rx1Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ir9fvL7uF/vKsNLu3Z9kBM5pHSobZyvZRQxZf3zqVdoy3aDGPkhvfBSGt1bGLgaiS
         hJaKtHdt3AuM5BovSAGZ2v5WjXj6XkVrF/U9bODVd6rfh/3MS2l+n1CWUIyvDVdzSr
         VUfJh0k0uoCloHLe7MloYf1duT6bz1ADwdO8AD7fZ1ZGM2SMqkUAGckYmw9F8ossln
         JfQOGhJ7+Og4KGM2HM0OjFFyTaoxwggH5yvks0VaOtnMmbyZ3g2i8M76Ah7HwzDH2Z
         UB9+IL1aw203P+mNuvFGaYZiDfwvUdVxTJFJU28odIe/ji+x6x8N8wKMGQ1wFdvtXE
         dGZ0KzA8nUSJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99983F6079F;
        Fri, 14 Jan 2022 11:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] kselftests/net: list all available tests in usage()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164215981062.30922.10007153006606910064.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Jan 2022 11:30:10 +0000
References: <20220114030246.4437-1-lizhijian@fujitsu.com>
In-Reply-To: <20220114030246.4437-1-lizhijian@fujitsu.com>
To:     Li Zhijian <lizhijian@fujitsu.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Jan 2022 11:02:46 +0800 you wrote:
> So that users can run/query them easily.
> 
> $ ./fcnal-test.sh -h
> usage: fcnal-test.sh OPTS
> 
> 	-4          IPv4 tests only
> 	-6          IPv6 tests only
> 	-t <test>   Test name/set to run
> 	-p          Pause on fail
> 	-P          Pause after each test
> 	-v          Be verbose
> 
> [...]

Here is the summary with links:
  - [v2] kselftests/net: list all available tests in usage()
    https://git.kernel.org/netdev/net/c/2255634100bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


