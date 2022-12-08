Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35155647564
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiLHSKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiLHSKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:10:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E2C52145;
        Thu,  8 Dec 2022 10:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8482B825D8;
        Thu,  8 Dec 2022 18:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 954FCC433F1;
        Thu,  8 Dec 2022 18:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670523015;
        bh=ZwoLITpYJUg/4eyY8ICNvEFmUk3kJC1ymqqYSVhpR6A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JIoKYn48FoPTix+ULlNoYrAtp/nL+Ult1yLRM5p0VLYdwG/sagZsuWmcJnHdS3dhX
         zhBTC0GJtc6/M0OC//5nlvfFD6D7BN5ba2I0vZu6ZJuIA54n0lwFQrsvQ/VJdAGEKi
         URHi8We4+C8qA4yyEdg8s9lbLakGEFlGht/Slo7kIRnHCvRuq769GJUDjCKAYduBnx
         ECqzYrx54RWvtc9V83XfHj56UwWVnzGm3qRftbZtA922UWiBC1VQ9/ws+4nxZLPUi+
         BJqlfzwltsT32x4Jfp/wC/m8ElUR1UL8yBFPK2LTyFEPSPnFhL/X6vnH/56oyz9gts
         Qw7JJMsIofklA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D205C433D7;
        Thu,  8 Dec 2022 18:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2] bpf: Do not zero-extend kfunc return values
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167052301550.11439.10680948622430616083.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 18:10:15 +0000
References: <20221207103540.396496-1-bjorn@kernel.org>
In-Reply-To: <20221207103540.396496-1-bjorn@kernel.org>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm5Aa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn@rivosinc.com,
        iii@linux.ibm.com, jackmanb@google.com, yhs@meta.com,
        yangjihong1@huawei.com
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

On Wed,  7 Dec 2022 11:35:40 +0100 you wrote:
> From: Björn Töpel <bjorn@rivosinc.com>
> 
> In BPF all global functions, and BPF helpers return a 64-bit
> value. For kfunc calls, this is not the case, and they can return
> e.g. 32-bit values.
> 
> The return register R0 for kfuncs calls can therefore be marked as
> subreg_def != DEF_NOT_SUBREG. In general, if a register is marked with
> subreg_def != DEF_NOT_SUBREG, some archs (where bpf_jit_needs_zext()
> returns true) require the verifier to insert explicit zero-extension
> instructions.
> 
> [...]

Here is the summary with links:
  - [bpf,v2] bpf: Do not zero-extend kfunc return values
    https://git.kernel.org/bpf/bpf-next/c/d35af0a7feb0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


