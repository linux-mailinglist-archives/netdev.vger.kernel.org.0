Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E73C59A9A5
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 01:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243547AbiHSXuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240711AbiHSXuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC3F10B52F;
        Fri, 19 Aug 2022 16:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2BA26189F;
        Fri, 19 Aug 2022 23:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 007F6C4347C;
        Fri, 19 Aug 2022 23:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660953019;
        bh=pwtfbOnPhKJEUFyeDRLEE4hlOZf8CHkDcZnbiWc3Ktw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MsNfMP6wSzcIklNyvNxnu14ZN9r7NF7fW459aNPmNgmbfYWAYsPGUUCGDldNdjDc8
         Cyx2KXxJuDGbwPBEAnHafye8vLmj/2lBnu8B8SrHC7Fng3lSdFhUgPS9O+HTd74pUP
         LV6EY0tQvBCUvphb3IuR8j+qWuBgYpuX0fTaz6vfNlTpj7Za2ztemyNCUB7rAtIWSN
         +VsKCe0kPYUa5Sb2aAyTA996BFIz//l+mReSd4YOGphmQihTQ1A8De2WfVFKONVaEn
         43t7T6fMcBH2oQm6TjasZC0JhIgccSNovtQ8Dkb8ycPao1Ufw8kfTK5oIyzb/2524B
         nANUPAO8aOJUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1F26E2A05F;
        Fri, 19 Aug 2022 23:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests/net: test l2 tunnel TOS/TTL inheriting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166095301885.11596.12881956498838147761.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Aug 2022 23:50:18 +0000
References: <20220817073649.26117-1-matthias.may@westermo.com>
In-Reply-To: <20220817073649.26117-1-matthias.may@westermo.com>
To:     Matthias May <matthias.may@westermo.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 Aug 2022 09:36:49 +0200 you wrote:
> There are currently 3 ip tunnels that are capable of carrying
> L2 traffic: gretap, vxlan and geneve.
> They all are capable to inherit the TOS/TTL for the outer
> IP-header from the inner frame.
> 
> Add a test that verifies that these fields are correctly inherited.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests/net: test l2 tunnel TOS/TTL inheriting
    https://git.kernel.org/netdev/net-next/c/b690842d12fd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


