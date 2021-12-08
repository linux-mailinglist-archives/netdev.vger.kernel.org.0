Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB8446DF05
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 00:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241165AbhLHXdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 18:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbhLHXdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 18:33:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEA6C061746;
        Wed,  8 Dec 2021 15:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BD3FFCE241B;
        Wed,  8 Dec 2021 23:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6E4FC341C7;
        Wed,  8 Dec 2021 23:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639006208;
        bh=zgP5QCJqd/8oiKnfN6hA3tLRCLz1+M/hrXqkeoeVocM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eC/SuBlXTH1/n0B1xlUB8SvwRybhcmPguwtZ3QuyiCp+7pPi/KY2GgxBhOK1r/GqU
         oe5GWFRknskvJxkC4Qjaa4U2FMmOK2m/pNe/Zy6zoCGniB52jZBKeG98RThWlBeEtt
         EVckEWY8x/iCZI514Vxe4h7AIhe1ZjMSM/x6J6Vp+fwfS/dua6FYB5Oj5Dy/zhTiIT
         ex6OBK17csfFXqcfkQcSfQ8arW2Pna94SZiS/B8nh0isQSxLVNpdLucUW5kAC/a7Mp
         7YYN04wA1//Jk1Q23O+eHz7MLIgs8kZ6bo1x8LO95Cd6+RyHTuqIYgcewhyGN43Dw/
         YYkXFK58s3vtg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CE44B60966;
        Wed,  8 Dec 2021 23:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next] perf/bpf_counter: use bpf_map_create instead of
 bpf_create_map
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163900620884.22414.3996058190598684198.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Dec 2021 23:30:08 +0000
References: <20211207232340.2561471-1-song@kernel.org>
In-Reply-To: <20211207232340.2561471-1-song@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kernel-team@fb.com,
        acme@kernel.org, acme@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Tue, 7 Dec 2021 15:23:40 -0800 you wrote:
> bpf_create_map is deprecated. Replace it with bpf_map_create. Also add a
> __weak bpf_map_create() so that when older version of libbpf is linked as
> a shared library, it falls back to bpf_create_map().
> 
> Fixes: 992c4225419a ("libbpf: Unify low-level map creation APIs w/ new bpf_map_create()")
> Signed-off-by: Song Liu <song@kernel.org>
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next] perf/bpf_counter: use bpf_map_create instead of bpf_create_map
    https://git.kernel.org/bpf/bpf-next/c/8d0f9e73efe7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


