Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CA04424FD
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhKBBMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhKBBMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 21:12:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2060560F5A;
        Tue,  2 Nov 2021 01:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635815407;
        bh=O12uF1JBQWs28kpDy/iVxzqbAxtOEXsw536QdL1RVdE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SY9KNHpT43d7mX8RgwaetaiwBcoxc2ShWD1I+AHTUawLWunOKUWdXacMjdi7f8pbP
         +iRy8MVjLWg6uC824h1grxMZT+rV+SovOpGNZ/4uWXj7eB6cMOyExcqMSK6BvAO34w
         zCNu8S82SwODKdey7s1vhSSB7ocVJo/NjTAlyE+7+KeJLlINMoMB5oZqhBXyoVt3vC
         8LgoBFcw9XK1z2GeexJ5R3qa0PYtrk1N1fgFsFlMZmbsrA5agpHfH7R2zlcf28uMwa
         X4tei4ZtsBoSvlpMlwRjtLYylAY/fqitlRST0prhp4DML9FXRZDKWFO+Tkvm+3fjJk
         yPrC0l3uFHw+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1340660AA4;
        Tue,  2 Nov 2021 01:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Fix propagation of bounds from 64-bit
 min/max into 32-bit and var_off.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163581540707.24025.3258258421731339121.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Nov 2021 01:10:07 +0000
References: <20211101222153.78759-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20211101222153.78759-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon,  1 Nov 2021 15:21:51 -0700 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Before this fix:
> 166: (b5) if r2 <= 0x1 goto pc+22
> from 166 to 189: R2=invP(id=1,umax_value=1,var_off=(0x0; 0xffffffff))
> 
> After this fix:
> 166: (b5) if r2 <= 0x1 goto pc+22
> from 166 to 189: R2=invP(id=1,umax_value=1,var_off=(0x0; 0x1))
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,1/3] bpf: Fix propagation of bounds from 64-bit min/max into 32-bit and var_off.
    https://git.kernel.org/bpf/bpf-next/c/b9979db83401
  - [v2,bpf-next,2/3] bpf: Fix propagation of signed bounds from 64-bit min/max into 32-bit.
    https://git.kernel.org/bpf/bpf-next/c/388e2c0b9783
  - [v2,bpf-next,3/3] selftests/bpf: Add a testcase for 64-bit bounds propagation issue.
    https://git.kernel.org/bpf/bpf-next/c/0869e5078afb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


