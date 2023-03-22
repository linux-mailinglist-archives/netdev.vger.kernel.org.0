Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FF96C41A3
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 05:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCVEkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 00:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjCVEkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 00:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68D917CEB;
        Tue, 21 Mar 2023 21:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D4D3B81B2A;
        Wed, 22 Mar 2023 04:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 303FAC4339B;
        Wed, 22 Mar 2023 04:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679460018;
        bh=w40bNQaOzdkmfZmlA2GvF9Q+pMKCnRWIU9AcJrvVFSc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dwnClOx3dhE5Oq3XrUAyEn1mUjd41JjiThDSqGOoN2z0fgrDmmKBmZJHn2+qKfVnr
         uU6fLkA25Yl9BbBrWFZZaVP0oGJsKGP55vFKkwwaFTGb3/LhIcm2segxwg28+lKsEd
         TfNlul6ehwjzcCi6BBwYhchmp9wkblt+SZJJu+lgmBV/iQYln53R0PBXiESLmZg+Ba
         PibkVmSfQcPw8Cpc6+D5xkcvTSWmfNkNdMzarIekOaeCG6tm/RaHx9gVqldD+h74hO
         yBFkSDMzSUUNYO7QIQHPauuJg8duWWhAVM9VILnF/MCHZiXseSiF19li6XrUXJZYy3
         UlVmz7hhZFn8A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16B72E4F0DA;
        Wed, 22 Mar 2023 04:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net/sonic: use dma_mapping_error() for error check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167946001808.24938.4667309228151145576.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 04:40:18 +0000
References: <6645a4b5c1e364312103f48b7b36783b94e197a2.1679370343.git.fthain@linux-m68k.org>
In-Reply-To: <6645a4b5c1e364312103f48b7b36783b94e197a2.1679370343.git.fthain@linux-m68k.org>
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     tsbogend@alpha.franken.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhangchangzhong@huawei.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Mar 2023 14:45:43 +1100 you wrote:
> From: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> The DMA address returned by dma_map_single() should be checked with
> dma_mapping_error(). Fix it accordingly.
> 
> Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> Tested-by: Stan Johnson <userm57@yahoo.com>
> Signed-off-by: Finn Thain <fthain@linux-m68k.org>
> 
> [...]

Here is the summary with links:
  - [v2,net] net/sonic: use dma_mapping_error() for error check
    https://git.kernel.org/netdev/net/c/4107b8746d93

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


