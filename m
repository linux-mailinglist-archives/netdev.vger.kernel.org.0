Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BBD513861
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 17:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349205AbiD1Pde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 11:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbiD1Pda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 11:33:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D26E0A8;
        Thu, 28 Apr 2022 08:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95474B82E4F;
        Thu, 28 Apr 2022 15:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31AEFC385AA;
        Thu, 28 Apr 2022 15:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651159812;
        bh=T+WZ741ROL6RC6V663uGNmJr88+g1OnBpfCrdEBCD0Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fOt2pYzdJAA91dl2eWxmBnMYmvoCyC52GrMib/VTgrtNBgD0Eu7cprNCpM7MxhEwY
         5piIM0rnXDc2agyzdojvnuSQZD9G9LmFVs4Er6pXtw4XefaSqCvCzWaa9TsVm1Ixcs
         vUYfxqXALDc8TiMpgfir75UP7P9aoesJIB66x6+OG8+HSECpPrHhattciLpB4YmYMx
         nLh6KGtyixWffn8EHk+ljTZ3ZSM4XH/acGTen0KV1NarT9/7Cr2g9VIjcAUTiUsAe8
         +eRod0Or2k9kDklwHtHPfYLoY0NHO/34jPUwaOPD/+Rmgqf7f0v1OjsPCOZpJAw9PT
         YfHtzK5w1putw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 135FDE8DD85;
        Thu, 28 Apr 2022 15:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/3] bpf, docs: Fix typos in instruction-set.rst
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165115981207.8186.1086744167638703650.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 15:30:12 +0000
References: <1651139754-4838-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1651139754-4838-1-git-send-email-yangtiezhu@loongson.cn>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        corbet@lwn.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 28 Apr 2022 17:55:51 +0800 you wrote:
> v2:
>   -- update the commit message of patch #2
>   -- add new patch #3
> 
> Tiezhu Yang (3):
>   bpf, docs: Remove duplicated word "instructions"
>   bpf, docs: BPF_FROM_BE exists as alias for BPF_TO_BE
>   bpf, docs: Fix typo "respetively" to "respectively"
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/3] bpf, docs: Remove duplicated word "instructions"
    https://git.kernel.org/bpf/bpf-next/c/67b97e584232
  - [bpf-next,v2,2/3] bpf, docs: BPF_FROM_BE exists as alias for BPF_TO_BE
    https://git.kernel.org/bpf/bpf-next/c/c821d80bb890
  - [bpf-next,v2,3/3] bpf, docs: Fix typo "respetively" to "respectively"
    https://git.kernel.org/bpf/bpf-next/c/9a9a90ca1327

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


