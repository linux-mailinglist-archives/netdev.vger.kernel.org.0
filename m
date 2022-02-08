Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0D14ADFAD
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383667AbiBHRaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239079AbiBHRaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:30:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459FDC061578;
        Tue,  8 Feb 2022 09:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A2FBB81765;
        Tue,  8 Feb 2022 17:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A83EDC340ED;
        Tue,  8 Feb 2022 17:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644341410;
        bh=VL3bxtmBVPxXL2B9+5hLYqQUg87OKbWGVVjtrApUwZI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aA0GnGpPqVRjN8/RIQawGGckV56S79l8l3ZbZZZjGc8q8VCUClE9SS9/BlQHw0KwR
         R0zwUENINtnnfvEcM9jpFhirJtKMLtUkPmTks/qbriIrVo+Ex1OGs0zJqN9xlltSvo
         1XUj8uyDeTDCJ0/5ycQ5FMKjXP0krCN1qfvOgzGo06j+eAQNlNlXPhLEcvKTHzFxml
         jFClYH7mJhbQ4iqvdgeQ02bHztK647eu7nuvJEQSrRfw++OHeZrpn/xuG3v0H0Rrm0
         QhN+7lEyORZAUBjuDRsVN1zmVTNORBCvPSsr15kUKYCbeildpookkCx6FwbY9lctob
         oiL2fPQ2QUNpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91042E6BB38;
        Tue,  8 Feb 2022 17:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf,
 x86_64: fail gracefully on bpf_jit_binary_pack_finalize failures
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164434141058.27587.8733162948879908140.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Feb 2022 17:30:10 +0000
References: <20220208062533.3802081-1-song@kernel.org>
In-Reply-To: <20220208062533.3802081-1-song@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kernel-team@fb.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Alexei Starovoitov <ast@kernel.org>:

On Mon, 7 Feb 2022 22:25:33 -0800 you wrote:
> Instead of BUG_ON(), fail gracefully and return orig_prog.
> 
> Fixes: 1022a5498f6f ("bpf, x86_64: Use bpf_jit_binary_pack_alloc")
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  arch/x86/net/bpf_jit_comp.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [bpf-next] bpf, x86_64: fail gracefully on bpf_jit_binary_pack_finalize failures
    https://git.kernel.org/bpf/bpf-next/c/f95f768f0af4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


