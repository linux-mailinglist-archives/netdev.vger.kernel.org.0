Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782A1572AB8
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 03:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiGMBUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 21:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiGMBUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 21:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A7157260
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 18:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85E6E618CD
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 01:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5F93C341C0;
        Wed, 13 Jul 2022 01:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657675213;
        bh=UfTReHRnVHsyivkB0zhHiIB3o4lJ0E56n15iVoUV5B4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dvLLIIK/qR+pg3YdumPMWRdFWaIOgTv6dbmB/zQ9ggamh6bk5RFl20sAO6va2fNCG
         0zFBkFFw7dfbCzkXL8IVpx+Ab7pdBPuhZZKFMHsFKtFkWvWgnptfmL3hFtkPf2L/99
         kcfcgmrRrXtk4GFPp3rTFcSnjrmYOrIXR0SE4QRrPuyvQLeVukZjwaTfAoRZ+OD40l
         K4nDEncjAH7FYio3+Z7N42onrHiKigudYhpal3n9pMBjRouzt+uUhsucet55+CABDF
         8s+EEp1O6UvWRYmzLqc6iKPA5rewx7H1FZoOTvkXjZFpXL5q1onkWhtlJxE27L4fLe
         da3yi2WRs4T3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE0CBE45227;
        Wed, 13 Jul 2022 01:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: support TX VLAN ctag insert in NFDK
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165767521370.10120.11382442320549276878.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 01:20:13 +0000
References: <20220711093048.1911698-1-simon.horman@corigine.com>
In-Reply-To: <20220711093048.1911698-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        na.wang@corigine.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 11 Jul 2022 11:30:48 +0200 you wrote:
> From: Diana Wang <na.wang@corigine.com>
> 
> Add support for TX VLAN ctag insert
> which may be configured via ethtool.
> e.g.
>      # ethtool -K $DEV tx-vlan-offload on
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: support TX VLAN ctag insert in NFDK
    https://git.kernel.org/netdev/net-next/c/eca250b16690

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


