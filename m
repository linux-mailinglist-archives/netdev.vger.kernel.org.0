Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3A84D1AF5
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347535AbiCHOvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234882AbiCHOvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:51:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21923916C;
        Tue,  8 Mar 2022 06:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E6213CE16C0;
        Tue,  8 Mar 2022 14:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12346C340F4;
        Tue,  8 Mar 2022 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646751010;
        bh=a7oTzDNK1Df7u0KQ+Jv0WvIy358t9zua3Q7ZJYXsXjw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yj/6ePDQXHp4QyGJ40Imt/MLuwjVLLK7SHgLpxFmMFn9AxNqdxP4xs2WAtq0KgTFe
         Spuo83ArJFC600uYHD4V8JRFK4xdm7y8WsjkLCMb75pjLVfKkxNC8zknyA/MqMy+wa
         Tk6spzRgifgFJq5ccx4IKx95/LwTvz3tD3Re6VJ2aqy46RJQ1ZXL2qZY6Kd010paQ/
         Q5brqSzUJPt/av95WQ57gWz/Nk7zkiBWbA53UVLJQ/1q2YSFRSI3Hh0lMRaiPQtprM
         fC+BK76GRkvzfgwNrtfFPjlaAShTBZtr9uPaZy4eBirb9Mlfa6a3dYW3GPi77BYgTO
         SH3b/B/EKBVJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA236E6D3DD;
        Tue,  8 Mar 2022 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: determine buf_info inside check_buffer_access()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164675100988.18270.17850383970446997392.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Mar 2022 14:50:09 +0000
References: <YiWYLnAkEZXBP/gH@syu-laptop>
In-Reply-To: <YiWYLnAkEZXBP/gH@syu-laptop>
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 7 Mar 2022 13:29:18 +0800 you wrote:
> Instead of determining buf_info string in the caller of
> check_buffer_access(), we can determine whether the register type is read-only
> through type_is_rdonly_mem() helper inside check_buffer_access() and construct
> buf_info, making the code slightly cleaner.
> 
> Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: determine buf_info inside check_buffer_access()
    https://git.kernel.org/bpf/bpf-next/c/44e9a741cad8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


