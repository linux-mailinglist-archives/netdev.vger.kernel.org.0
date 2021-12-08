Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68A746D616
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbhLHOxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbhLHOxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:53:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3FBC061746;
        Wed,  8 Dec 2021 06:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0C28ACE21D0;
        Wed,  8 Dec 2021 14:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1EC12C341C3;
        Wed,  8 Dec 2021 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638975009;
        bh=daaTEf+M4v1zCy7DPdtO2FVb+KY803anfeGT1eC8lN4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hiFyL9t/0LfISVFkcxu+pNwMil86jyYkRBfbcGyfWpLqAxqAzdl+tK8QNlr1V8VmX
         aET6FTkKwxELJtKtCxWxjQRTH7tGN6xveAwjDDAKcRqwVSIY0f/IaWdxdSSm3Qczyd
         sWf7SL4dfBajjdx+ZtiyfuSJxAS/UUiVA4+rXHT+QHz0tdrw+tXAfyvk+b1nrCcfZ8
         IAzk891f230DYXGTCRVsR9f/JmFgl3VDo5ps3Z2C1sy+VuEBdaCgYmfQT9AOMdNEfq
         WOdVCtUuGA/Qyoy6NR3e4uodmXu9DAOBXT+t+6iDm5KGfsDRZUMP6tQgVA21oWcKYE
         uRSO8wpHp096A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 07CF260A36;
        Wed,  8 Dec 2021 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpf: Add selftests to cover packet access corner cases
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163897500902.29831.2324466346269128478.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Dec 2021 14:50:09 +0000
References: <20211207081521.41923-1-maximmi@nvidia.com>
In-Reply-To: <20211207081521.41923-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 7 Dec 2021 10:15:21 +0200 you wrote:
> This commit adds BPF verifier selftests that cover all corner cases by
> packet boundary checks. Specifically, 8-byte packet reads are tested at
> the beginning of data and at the beginning of data_meta, using all kinds
> of boundary checks (all comparison operators: <, >, <=, >=; both
> permutations of operands: data + length compared to end, end compared to
> data + length). For each case there are three tests:
> 
> [...]

Here is the summary with links:
  - [bpf] bpf: Add selftests to cover packet access corner cases
    https://git.kernel.org/bpf/bpf/c/b560b21f71eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


