Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5785A2B2E7C
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 17:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgKNQkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 11:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgKNQkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 11:40:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605372005;
        bh=mwwg/+Gy1DT5AFzAT3bT88xmvvoG9NdzJCFHC1M2j8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YElGu6a5HF80RwG1h+FPfaESqCzIEuQk/UGOPQO2xEnymP8mgPjCotvSfEDqmiUQX
         NUg3Hslin7kDqZHNmCCu1hmYxOKDK8ueZ6QYCx38HhFq2pQUvM0omNbHGYrQJEWPYG
         ARb/HKO58AhKO8h+yK1We4OOxNi096CTVhoG/voA=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2] bpf: relax return code check for subprograms
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160537200528.5559.11558269272762052804.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Nov 2020 16:40:05 +0000
References: <20201113171756.90594-1-me@ubique.spb.ru>
In-Reply-To: <20201113171756.90594-1-me@ubique.spb.ru>
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     bpf@vger.kernel.org, kernel-team@fb.com, rdna@fb.com,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org, toke@redhat.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Fri, 13 Nov 2020 17:17:56 +0000 you wrote:
> Currently verifier enforces return code checks for subprograms in the
> same manner as it does for program entry points. This prevents returning
> arbitrary scalar values from subprograms. Scalar type of returned values
> is checked by btf_prepare_func_args() and hence it should be safe to
> allow only scalars for now. Relax return code checks for subprograms and
> allow any correct scalar values.
> 
> [...]

Here is the summary with links:
  - [bpf,v2] bpf: relax return code check for subprograms
    https://git.kernel.org/bpf/bpf/c/f782e2c300a7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


