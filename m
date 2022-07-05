Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1287E566733
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiGEKAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiGEKAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B2A1086;
        Tue,  5 Jul 2022 03:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90E4E619A9;
        Tue,  5 Jul 2022 10:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E40B0C341CB;
        Tue,  5 Jul 2022 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657015213;
        bh=NNs/Sfb/Zmnb/a+ZLP2b/3jAoI/7bLbn0FZIBanY5Mk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jRxUjEd445TIxHLH17oLJNDelmTmqvXcMn/ISyuHIDwLH2PdAEx7em9WrQYTEilrT
         4+4OfuXunpRpl52rwJ4ussO2XRgqv+SqAps7Bo+L908yJlgIgZgp1u837zSnQL8ZWN
         85UvVdKYHQ+kD3K+mVR4eNIAx3tUon/aZDqF4+oKNNzk+NVs3iC5R0jabebchmh3/j
         lk9T6FMZoolh0mYeYJfy/pThqKyokvSPXEBM4nHUxXPDUpBFmgun8euIA4wjYa5/GQ
         ItaNeqRhwNy0DoC5KD89Y0jkMOIhKdnFX1oTP/heuEmhMFebEv+bReZMzQmkDvLY7P
         9mC9+ESvPLISA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5281E45BDB;
        Tue,  5 Jul 2022 10:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests, bpf: remove AF_XDP samples
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165701521280.30326.4501585517121524437.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jul 2022 10:00:12 +0000
References: <20220630093717.8664-1-magnus.karlsson@gmail.com>
In-Reply-To: <20220630093717.8664-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        andrii@kernel.org, hawk@kernel.org, toke@redhat.com,
        bpf@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 30 Jun 2022 11:37:17 +0200 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Remove the AF_XDP samples from samples/bpf as they are dependent on
> the AF_XDP support in libbpf. This support has now been removed in the
> 1.0 release, so these samples cannot be compiled anymore. Please start
> to use libxdp instead. It is backwards compatible with the AF_XDP
> support that was offered in libbpf. New samples can be found in the
> various xdp-project repositories connected to libxdp and by googling.
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests, bpf: remove AF_XDP samples
    https://git.kernel.org/bpf/bpf-next/c/cfb5a2dbf141

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


