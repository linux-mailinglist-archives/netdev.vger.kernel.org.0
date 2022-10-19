Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93458604F43
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiJSSA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiJSSAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:00:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72D0172B42;
        Wed, 19 Oct 2022 11:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67BFCB825A1;
        Wed, 19 Oct 2022 18:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 294E6C433D7;
        Wed, 19 Oct 2022 18:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666202421;
        bh=3qlwPYdo4AH1rOJ4Qwo58NvZGVVrLslkF74sD0bYpOg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LLx6h0OkkrwaXgPFGBzejG2Vz1VCTBwIoGrW91m0EqnXsEz8qPDPu40KgBojhZ6gH
         3vbE3U7SPwEMytvZLJgaAM9iOjkIFpaZ6yJSQ5KpjYoK+KRgRAJtH2r3BaANXpi14P
         7aVsWMNCk0BS9Ie2k/9LQMiK1xechFWtF9TOBgkPCf6R1e+1PqxTvrlito58B0dJIR
         wTf3nd6+yDpKQebvMRYOz0opdHTs8f267Ar0lo7XpVSrA59tHUwHKzB1c1RYbsF3De
         MJiosaUppAExYDlkiMpotXZS2qYjEUd5zhnDNUKyHlK3cIGy2ccgvCrzLinnKDGrHL
         vrTaE1NXURBzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0AF9BE270EA;
        Wed, 19 Oct 2022 18:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] samples/bpf: Fix map interation in xdp1_user
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166620242101.8250.6135773803189204405.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 18:00:21 +0000
References: <20221013200922.17167-1-gerhard@engleder-embedded.com>
In-Reply-To: <20221013200922.17167-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Thu, 13 Oct 2022 22:09:22 +0200 you wrote:
> BPF map iteration in xdp1_user results in endless loop without any
> output, because the return value of bpf_map_get_next_key() is checked
> against the wrong value.
> 
> Other call locations of bpf_map_get_next_key() check for equal 0 for
> continuing the iteration. xdp1_user checks against unequal -1. This is
> wrong for a function which can return arbitrary negative errno values,
> because a return value of e.g. -2 results in an endless loop.
> 
> [...]

Here is the summary with links:
  - [net-next] samples/bpf: Fix map interation in xdp1_user
    https://git.kernel.org/bpf/bpf-next/c/05ee658c654b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


