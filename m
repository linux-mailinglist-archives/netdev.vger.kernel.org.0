Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857A64EEBEA
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 13:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345285AbiDALCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 07:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345275AbiDALCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 07:02:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0914103DAD;
        Fri,  1 Apr 2022 04:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60256B82480;
        Fri,  1 Apr 2022 11:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 168B7C34113;
        Fri,  1 Apr 2022 11:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648810812;
        bh=NXcJ74xjotiGT+sguDvAml77hcKVu7uhqfFa6KCk7D4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vcycb6crTjVt6xUcVk1p4k2iLTsJgnG++m8gGY238PNwZeqctQD0dcG/PSOYTtAHt
         rp4cUj44JAqKB49ynxMkQS9MOgp7wWJRauRCP3LFkyi6djgL07Wby3sb0xECmP1/JZ
         A/RhJTUcw3F+iSFhfF0CaFLhAAq50Zp8IUi3aWC7LU+sa1V1IcnDxJzOF2T5V5hClR
         PbjR41vcerhy8ika0ZsSKsOyhGyTclsTR9ntUllDpLyax5jlTQIzUUCEzlemNO7+pZ
         iHspWrRJzMOMiWbsnL7vTTddLTYMKUCh14FE0kGkzDF5jv1ZpcxeTix/ne3VPREbjH
         7lVM0v0X3HnOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E600AF0384A;
        Fri,  1 Apr 2022 11:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: sfc: add missing xdp queue reinitialization
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164881081193.13357.15286067348950686490.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Apr 2022 11:00:11 +0000
References: <20220330163703.25086-1-ap420073@gmail.com>
In-Reply-To: <20220330163703.25086-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        cmclachlan@solarflare.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 30 Mar 2022 16:37:03 +0000 you wrote:
> After rx/tx ring buffer size is changed, kernel panic occurs when
> it acts XDP_TX or XDP_REDIRECT.
> 
> When tx/rx ring buffer size is changed(ethtool -G), sfc driver
> reallocates and reinitializes rx and tx queues and their buffer
> (tx_queue->buffer).
> But it misses reinitializing xdp queues(efx->xdp_tx_queues).
> So, while it is acting XDP_TX or XDP_REDIRECT, it uses the uninitialized
> tx_queue->buffer.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: sfc: add missing xdp queue reinitialization
    https://git.kernel.org/netdev/net/c/059a47f1da93

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


