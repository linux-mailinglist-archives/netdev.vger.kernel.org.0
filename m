Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9996D8758
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 21:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbjDETvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 15:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbjDETu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 15:50:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9EA83E8;
        Wed,  5 Apr 2023 12:50:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4C15640E6;
        Wed,  5 Apr 2023 19:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D594C4339C;
        Wed,  5 Apr 2023 19:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680724219;
        bh=sJprvVjFu7eTeNtRU2SllTC316R4pT5/9QEMKa99s9c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dDNCAYbSq51IQ82/Il9ty/kohsmaqUOw5/76Tk81ki96fD+5AqVdEhzzNBuf+VZKS
         IhpJ0+D6ttg4fGbv8pn5tPZy2ZPqnUQ5FhN6KWnlv2X/jtB4WQ6goZP9qlUDO0Fu6s
         1QZa59tL+CgnLAJg+KwBqbLq4gCPtZS0+fjJU6HQ969YkgBCtCQRxi9srKaZnRM4+b
         GHMcC+JLQj8mBIGPzZl5kV049TVouOuVAkrb6iXBqXGQDY/GSAXn3Z9vLxDWRBFjHf
         +mSkLILVQzn8esz61WHjfkGEgRSbqugU0fdZCsekVO22lc4vQKXbiNY6BkWbl0+rDe
         McKAxYuxbj4cA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F33C2E2A033;
        Wed,  5 Apr 2023 19:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests: xsk: Disable IPv6 on VETH1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168072421899.28321.8394298131712932461.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Apr 2023 19:50:18 +0000
References: <20230405082905.6303-1-kal.conley@dectris.com>
In-Reply-To: <20230405082905.6303-1-kal.conley@dectris.com>
To:     Kal Cutter Conley <kal.conley@dectris.com>
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        andrii@kernel.org, mykolal@fb.com, ast@kernel.org,
        daniel@iogearbox.net, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        shuah@kernel.org, weqaar.janjua@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Wed,  5 Apr 2023 10:29:04 +0200 you wrote:
> This change fixes flakiness in the BIDIRECTIONAL test:
> 
>     # [is_pkt_valid] expected length [60], got length [90]
>     not ok 1 FAIL: SKB BUSY-POLL BIDIRECTIONAL
> 
> When IPv6 is enabled, the interface will periodically send MLDv1 and
> MLDv2 packets. These packets can cause the BIDIRECTIONAL test to fail
> since it uses VETH0 for RX.
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests: xsk: Disable IPv6 on VETH1
    https://git.kernel.org/bpf/bpf-next/c/f2b50f172683

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


