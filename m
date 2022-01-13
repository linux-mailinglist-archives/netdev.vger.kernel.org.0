Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEE548D861
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 14:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbiAMNAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 08:00:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41888 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiAMNAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 08:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F89B61C50;
        Thu, 13 Jan 2022 13:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBC04C36AEF;
        Thu, 13 Jan 2022 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642078811;
        bh=s+duKtAVtGsUQyltgq7UzQG59GI6tZ6fWYE6VAu1CG0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IvZsycrtYAxO6Krl//JYJPjlQRz5AgQcv30DTXCALXbs0iAtT3mJPsD7gueHWZYr3
         577OTEN5Ql+WEpG/yr4rRH40T/wJCQUo0Nr+FmLb7jMf2So4Mboxk3c+TMhNpkJaZY
         Ff1BYNfDKL3n6xt1TyF+zPzM8haZz9Fp63snOG7/wxEVxzM8s90e2W72PXumJ3bTyX
         IHLqJ6pYnYM69mkEaUqS/yngn2H/irSDWQ8RNPPdPOwnoHEyBW0u4u1Fc5uzPc4UA/
         LtdhwiuaoqvFPseLjK2/m2Dbj4smgwSWj6/khDdWaWOmY3wT/mu0i5GNp11KYQArMN
         J4JG3O6EpEAZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1B2CF6079C;
        Thu, 13 Jan 2022 13:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] kselftests/net: adapt the timeout to the largest runtime
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164207881178.26897.5058098241493061619.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Jan 2022 13:00:11 +0000
References: <20220113072859.3431-1-lizhijian@fujitsu.com>
In-Reply-To: <20220113072859.3431-1-lizhijian@fujitsu.com>
To:     Li Zhijian <lizhijian@fujitsu.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhoujie2011@fujitsu.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 13 Jan 2022 15:28:59 +0800 you wrote:
> timeout in settings is used by each case under the same directory, so
> it should adapt to the maximum runtime.
> 
> A normally running net/fib_nexthops.sh may be killed by this unsuitable
> timeout. Furthermore, since the defect[1] of kselftests framework,
> net/fib_nexthops.sh which might take at least (300 * 4) seconds would
> block the whole kselftests framework previously.
> $ git grep -w 'sleep 300' tools/testing/selftests/net
> tools/testing/selftests/net/fib_nexthops.sh:    sleep 300
> tools/testing/selftests/net/fib_nexthops.sh:    sleep 300
> tools/testing/selftests/net/fib_nexthops.sh:    sleep 300
> tools/testing/selftests/net/fib_nexthops.sh:    sleep 300
> 
> [...]

Here is the summary with links:
  - kselftests/net: adapt the timeout to the largest runtime
    https://git.kernel.org/netdev/net/c/de0e444706ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


