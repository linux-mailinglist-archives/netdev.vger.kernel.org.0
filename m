Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A4961A3FF
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 23:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiKDWUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 18:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKDWUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 18:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013292D1CC;
        Fri,  4 Nov 2022 15:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C7C0B82FEA;
        Fri,  4 Nov 2022 22:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2901BC433D7;
        Fri,  4 Nov 2022 22:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667600415;
        bh=cCykTbP6zEg5ECu3S0odkzRlQ+fjcHCMBSJAQAl4kLs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I1vP5e44jWX6GaKZ1K+qbEbFi2tZPvXd+ioxISI4Xo+Cs9Kp+GGQhDMX4tGHa6oHX
         NKS+PD53cpEhiB92/LGreOxCCDKIqdWaq8bpoj6KBLBjzrSCye4RwDWn/NjPe/stWw
         jPH2s/xRaNJRsPQ0sYhkNMGlOclc/19DZGJ8rr0YfNGF7TX/q62AXA3hH5De04hUcb
         OnFwQVzqz/BIXpQOxWLX31LH7E20b4lrsbjWR23LNB60tLxh0/C+0i6XxahDeNujCa
         LgarG8/ptKa1c2EC+0w0LkLXLfhQdXOf7zUJ4jmHW+8Cx5xUMkr2x5dvb6Zr0wu7Ru
         TixLNK4T2oGRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A8DAE29F4C;
        Fri,  4 Nov 2022 22:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] bpf: Yet another approach to fix the BPF dispatcher thing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166760041503.11044.8727035971633367268.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 22:20:15 +0000
References: <20221103120012.717020618@infradead.org>
In-Reply-To: <20221103120012.717020618@infradead.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     olsajiri@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn@kernel.org, toke@redhat.com,
        David.Laight@aculab.com, rostedt@goodmis.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 03 Nov 2022 13:00:12 +0100 you wrote:
> Hi!
> 
> Even thought the __attribute__((patchable_function_entry())) solution to the
> BPF dispatcher woes works, it turns out to not be supported by the whole range
> of ageing compilers we support. Specifically this attribute seems to be GCC-8
> and later.
> 
> [...]

Here is the summary with links:
  - [1/2] bpf: Revert ("Fix dispatcher patchable function entry to 5 bytes nop")
    (no matching commit)
  - [2/2] bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)
    https://git.kernel.org/bpf/bpf/c/c86df29d11df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


