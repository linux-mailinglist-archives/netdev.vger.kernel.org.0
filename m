Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF3A6C29C4
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 06:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCUFVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 01:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjCUFUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 01:20:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285083A842;
        Mon, 20 Mar 2023 22:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 484436195C;
        Tue, 21 Mar 2023 05:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96501C433D2;
        Tue, 21 Mar 2023 05:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679376018;
        bh=S9GHUupx4nJWxC/f5fvaTJWILdTr8VDvWt+37ywhyVo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kJY7AK0JTXDzcFlO/N1u31ZYlRNEZiTv4fAzaX1rb0SDnmRf53q6LVTGSTngR4/lk
         JxkO8QaZ7vuqVJ2xLHM1nfJug5DkXEXFPqPg2ZbzBcjvIe6v6DAJ7f6qMvL5lJVeJy
         wxe2p0PkRa9B2iPP/eHUnO8D00PU3cscIPipWQC0d4/PG1XQfZ+ymlpgn+9ymyL7lI
         Mhqd+OckgLEK15f3VmX3CMUoN9x950HtW2trHg2O0PDJ3FXYetWheBiXZmvDe+/sF1
         ebLKQ7nMmtwvq2A7V+AmjAiNy/eKnSm2fJ+hBO5IxwUyHw9GMyx5e9AMeyZP6U3tDI
         RwHUi8g+w4mQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 712BBE4F0DA;
        Tue, 21 Mar 2023 05:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/3] net: skbuff: skb bitfield compaction - bpf
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167937601845.15568.17972545639216235009.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Mar 2023 05:20:18 +0000
References: <20230321014115.997841-1-kuba@kernel.org>
In-Reply-To: <20230321014115.997841-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Mon, 20 Mar 2023 18:41:12 -0700 you wrote:
> I'm trying to make more of the sk_buff bits optional.
> Move the BPF-accessed bits a little - because they must
> be at coding-time-constant offsets they must precede any
> optional bit. While at it clean up the naming a bit.
> 
> v1: https://lore.kernel.org/all/20230308003159.441580-1-kuba@kernel.org/
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/3] net: skbuff: rename __pkt_vlan_present_offset to __mono_tc_offset
    https://git.kernel.org/bpf/bpf-next/c/04aae213e719
  - [bpf-next,v2,2/3] net: skbuff: reorder bytes 2 and 3 of the bitfield
    https://git.kernel.org/bpf/bpf-next/c/b94e032b7ad6
  - [bpf-next,v2,3/3] net: skbuff: move the fields BPF cares about directly next to the offset marker
    https://git.kernel.org/bpf/bpf-next/c/c0ba861117c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


