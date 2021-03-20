Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD5D342A11
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 03:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhCTCkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 22:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229708AbhCTCkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 22:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2301A6197F;
        Sat, 20 Mar 2021 02:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616208008;
        bh=hb0wqum/nW5uWJQumue32soPp+RFzIfNYGbZwuICIWo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fVRJBTjEuicB4fd2NLj4IsYOd4JRAskk359ch54PgdJuXe9J3eN08K8thDaPyolgV
         eNgBSSbs8eac0ph0awwuL5XVrexjOkNCIzEzIPCwJZOy8/69kar2I619mw5iNybeDT
         Wj97kRRfr4mxAZG6PPmHwvx/ltm8SeTZv8e1sWHB3E5ktjEheyqEYwG05NYIEvvuWu
         l/ZXbwtcsJiRT/C8b5YnbDdKtfg9ooZTLoxmgdpmkxE1AGbtsaIBp06yLSHjV/x/fb
         SPng2PKbe/+q3FvsKJk+ddgJ3v+QMoPSh8hb/Xz/pCRZeVRyYi/Nlf9BNFAu9NZFU4
         ue8Q/74SjoOZQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 15765626EC;
        Sat, 20 Mar 2021 02:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpf: use NOP_ATOMIC5 instead of emit_nops(&prog,
 5) for BPF_TRAMP_F_CALL_ORIG
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161620800808.16689.10509745664512400022.git-patchwork-notify@kernel.org>
Date:   Sat, 20 Mar 2021 02:40:08 +0000
References: <20210320000001.915366-1-sdf@google.com>
In-Reply-To: <20210320000001.915366-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Fri, 19 Mar 2021 17:00:01 -0700 you wrote:
> __bpf_arch_text_poke does rewrite only for atomic nop5, emit_nops(xxx, 5)
> emits non-atomic one which breaks fentry/fexit with k8 atomics:
> 
> P6_NOP5 == P6_NOP5_ATOMIC (0f1f440000 == 0f1f440000)
> K8_NOP5 != K8_NOP5_ATOMIC (6666906690 != 6666666690)
> 
> Can be reproduced by doing "ideal_nops = k8_nops" in "arch_init_ideal_nops()
> and running fexit_bpf2bpf selftest.
> 
> [...]

Here is the summary with links:
  - [bpf] bpf: use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG
    https://git.kernel.org/bpf/bpf/c/b90829704780

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


