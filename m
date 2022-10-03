Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9752D5F3356
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 18:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiJCQU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 12:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiJCQUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 12:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F219715FF4;
        Mon,  3 Oct 2022 09:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5631C61152;
        Mon,  3 Oct 2022 16:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A758BC433C1;
        Mon,  3 Oct 2022 16:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664814015;
        bh=o82mYUcMzZJ88bp9X2SIyeZOFEstJnAckAGwFH9r32k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NCrsFb7wlu0Dw+DyPRN18s/WcSrwLtwUXOYwniQVuO0JTwbAFl4rkehuamgfOm4/l
         lUKYxbUNA0r2fEB1sPtWMsPWhWkw8+W6bSKzyluT0asrHAI1UFGSEk8zgh+BVaUKOB
         kZd+dWpg8FawsUjM+Fn4r5YlCZLMWBP5VwdLKfSaVAEPsi03l5c/67ELJZNnH4+XWW
         310xpaLzPX8Zih2R6vKaMnrrWnTvjM/z0P8vPWam3CKYy4N9NaJLl4U5kUgIJ1oHob
         jytRiiTCMpKMTx0ryf2T6dW8Y7K2mdImmjCmG62QsJJFXlhIRz87QsWq1Y+R/KHu+G
         s9bsq/Cg3kKpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 897E6E4D03C;
        Mon,  3 Oct 2022 16:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next] net: netfilter: move bpf_ct_set_nat_info kfunc in
 nf_nat_bpf.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166481401555.8397.6441469984124928795.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 16:20:15 +0000
References: <51a65513d2cda3eeb0754842e8025ab3966068d8.1664490511.git.lorenzo@kernel.org>
In-Reply-To: <51a65513d2cda3eeb0754842e8025ab3966068d8.1664490511.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, nathan@kernel.org, martin.lau@linux.dev,
        ykaliuta@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Fri, 30 Sep 2022 00:38:43 +0200 you wrote:
> Remove circular dependency between nf_nat module and nf_conntrack one
> moving bpf_ct_set_nat_info kfunc in nf_nat_bpf.c
> 
> Fixes: 0fabd2aa199f ("net: netfilter: add bpf_ct_set_nat_info kfunc helper")
> Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Yauheni Kaliuta <ykaliuta@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next] net: netfilter: move bpf_ct_set_nat_info kfunc in nf_nat_bpf.c
    https://git.kernel.org/bpf/bpf-next/c/820dc0523e05

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


