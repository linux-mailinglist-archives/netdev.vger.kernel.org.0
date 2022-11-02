Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6CF61625E
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 13:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiKBMAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 08:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiKBMAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 08:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859DE28E14
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 05:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22BB961934
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 854F9C43144;
        Wed,  2 Nov 2022 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667390416;
        bh=R1pmHtKIxnm5tUHckkm5iAJ8CqBdI3lnUpcdeFqrkHw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R6rmD+X3Oa6nD6YzWc2Q8bXHENGVWiqFnXjimzPVvNt6FJMjyW7XnNLvh5OGA6I89
         B11Nhawop6Bv8Gt0nzcVpcuVUM5dySgpxTKEn4TjqTZNUiSkaMYf1GPH9FNl+llGlk
         C/S44iCs06HKbRn44G4uyxTMtaCfUF+ohmrRLhQT63lHvXPi7m2bdzGJi/BUbLdiyP
         2q3EcNQ6T/FkAcAI4W4ReLTBl/3DXZXO2oMID5AEwEsQi8PW9aibm5NNKSRP3ZL6AR
         hC5UNc7zztm9eJ+++NVgKlUrcGonwB6qcuGf7/T7WnemhyiH3XNzreDiLdA0y0vbOa
         +rIsSUEj5zq+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DB86E29F4C;
        Wed,  2 Nov 2022 12:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] gve: Reduce alloc and copy costs in the GQ rx path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166739041644.9516.13589359544477751243.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 12:00:16 +0000
References: <20221029165322.1294983-1-shailend@google.com>
In-Reply-To: <20221029165322.1294983-1-shailend@google.com>
To:     Shailend Chand <shailend@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 29 Oct 2022 09:53:22 -0700 you wrote:
> Previously, even if just one of the many fragments of a 9k packet
> required a copy, we'd copy the whole packet into a freshly-allocated
> 9k-sized linear SKB, and this led to performance issues.
> 
> By having a pool of pages to copy into, each fragment can be
> independently handled, leading to a reduced incidence of
> allocation and copy.
> 
> [...]

Here is the summary with links:
  - [net-next] gve: Reduce alloc and copy costs in the GQ rx path
    https://git.kernel.org/netdev/net-next/c/82fd151d38d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


