Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA08C3D43F9
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 02:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhGWXtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 19:49:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232724AbhGWXtb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 19:49:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4795760EB5;
        Sat, 24 Jul 2021 00:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627086604;
        bh=0hXkij/G2ZY4wrpwuULYGdWmeptfSHbB6RNzayyFW7c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g2cc3KcEmWuKRSzCfukUQ2rz2n3qVXvlLDa2COBqA+IZMII0lm3j7PpsU5wihH/qv
         jk6YiOLTg3KjM9VpJX7Pb0guUHaUjj2k194wa+fBJzT5PiHJDn2lUfiD/0tnPbYXVl
         Cvs3R6PZ3NmYhxUL93UuwheWmmmSGCePy9Ml7dRHA0aN7I/xtF3Dsf6b1GQ8LYgyv/
         KQLO69ZZGaixTFZD+v96U7KC0HGDQ3xtLR8v+OVPjFJiH8bA6HAgOx8sUGWQtFyevV
         McGe+VvDGK/UADO6bAa1kAbTSclOQDNtSClMux7eJTfbiLxw8Ks88kHX1QQRtIPqKF
         0UN7jdwQh6QlQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3A10A60721;
        Sat, 24 Jul 2021 00:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf/tests: do not PASS tests without actually testing the
 result
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162708660423.10005.5949427979169570088.git-patchwork-notify@kernel.org>
Date:   Sat, 24 Jul 2021 00:30:04 +0000
References: <20210721103822.3755111-1-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20210721103822.3755111-1-johan.almbladh@anyfinetworks.com>
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 21 Jul 2021 12:38:22 +0200 you wrote:
> Each test case can have a set of sub-tests, where each sub-test can
> run the cBPF/eBPF test snippet with its own data_size and expected
> result. Before, the end of the sub-test array was indicated by both
> data_size and result being zero. However, most or all of the internal
> eBPF tests has a data_size of zero already. When such a test also had
> an expected value of zero, the test was never run but reported as
> PASS anyway.
> 
> [...]

Here is the summary with links:
  - bpf/tests: do not PASS tests without actually testing the result
    https://git.kernel.org/bpf/bpf-next/c/2b7e9f25e590

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


