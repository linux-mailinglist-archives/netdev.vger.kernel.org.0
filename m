Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B4C5FE9BB
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 09:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiJNHk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 03:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiJNHkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 03:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A876582F
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 00:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8C06B82262
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 07:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D5C7C433D7;
        Fri, 14 Oct 2022 07:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665733216;
        bh=nxDumI64fJ94EiV65kRrZaD/4ZT7CPh/00RbS3CPuFY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CQ6UG0Pt7GxgQ7SliEyMezNDW+kGBfoS5PcUEhdz3/ra7JotYlhKxV/oMv3DjnoGW
         CcT1WIvIKkmVYndxSOXrn7wcZB0EjKjmy/6+1x2UwyMR5G/HKPuvgHhmAHboI0yVKY
         IuNhh/fJ964haIqhd+v8l+pHzibai/qa1Z3ADT7rRMn+eD66fdbzZl2OIjAEJ7ISwI
         jcHUo6habJprdm+rO+ku5CEeqNhVeRTiD2TUn23d2KGM/Li/DR/+himZP2h1Mq15RB
         yvngCyVHgFt2Q0aPPJ9Z/3RgIzJtMzygqM62RnD9T+OfzQic2Qs8jsGXi5ruYwmmrV
         aNrZTodEHTiAQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E70AE270EF;
        Fri, 14 Oct 2022 07:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] i40e: Fix DMA mappings leak
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166573321631.24049.4200074316284119400.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Oct 2022 07:40:16 +0000
References: <20221012205440.3332570-1-jacob.e.keller@intel.com>
In-Reply-To: <20221012205440.3332570-1-jacob.e.keller@intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jan.sokolowski@intel.com, mateusz.palczewski@intel.com,
        chandanx.rout@intel.com, gurucharanx.g@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 12 Oct 2022 13:54:40 -0700 you wrote:
> From: Jan Sokolowski <jan.sokolowski@intel.com>
> 
> During reallocation of RX buffers, new DMA mappings are created for
> those buffers.
> 
> steps for reproduction:
> while :
> do
> for ((i=0; i<=8160; i=i+32))
> do
> ethtool -G enp130s0f0 rx $i tx $i
> sleep 0.5
> ethtool -g enp130s0f0
> done
> done
> 
> [...]

Here is the summary with links:
  - [net] i40e: Fix DMA mappings leak
    https://git.kernel.org/netdev/net/c/aae425efdfd1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


