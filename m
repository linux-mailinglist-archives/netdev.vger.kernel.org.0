Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374152D463D
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 17:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732084AbgLIQAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 11:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbgLIQAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 11:00:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607529607;
        bh=nPYVPZb8lF5AdNA/ZSa58MqKVIKgV5e+WU4mYaQy1hY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O4pqR+kgMVViT91hgn8Dhj5xDIqGJ9+wWNjcsRPwEA6FYVyMBE0VjqXJxL2eVKZtR
         DXXIXD5/q8Nv66w7ut1Tnh9o4gz0R5RRqV43VYItyLwRjthnNqV2Z2d6fvKc4wii2w
         DFHDua+6I6cMXi6Ql/hd8gL2K2Y0JaVYYxfcCa8Lw5WH0sQc8DkUaAkDxZfdYopJBo
         hw4AKSSLNJ6WO5we5tC3rLmQ1Ybz38v4BxNjUMUVEL/O8gGSregRRIw2PlZf6KMaAd
         5WEqiMsd3OhBJW6QbT2zM84lVD8an0SbyO1Pp4/Y+dzS5sKa5HuHFiJFETnfBzwRBT
         hDEKH6TpofVXg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v4 0/5] selftests/bpf: xsk selftests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160752960729.12976.12661383715171656742.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Dec 2020 16:00:07 +0000
References: <20201207215333.11586-1-weqaar.a.janjua@intel.com>
In-Reply-To: <20201207215333.11586-1-weqaar.a.janjua@intel.com>
To:     Weqaar Janjua <weqaar.janjua@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, yhs@fb.com, magnus.karlsson@gmail.com,
        bjorn.topel@intel.com, weqaar.a.janjua@intel.com, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Mon,  7 Dec 2020 21:53:28 +0000 you wrote:
> This patch set adds AF_XDP selftests based on veth to selftests/bpf.
> 
> # Topology:
> # ---------
> #                 -----------
> #               _ | Process | _
> #              /  -----------  \
> #             /        |        \
> #            /         |         \
> #      -----------     |     -----------
> #      | Thread1 |     |     | Thread2 |
> #      -----------     |     -----------
> #           |          |          |
> #      -----------     |     -----------
> #      |  xskX   |     |     |  xskY   |
> #      -----------     |     -----------
> #           |          |          |
> #      -----------     |     ----------
> #      |  vethX  | --------- |  vethY |
> #      -----------   peer    ----------
> #           |          |          |
> #      namespaceX      |     namespaceY
> 
> [...]

Here is the summary with links:
  - [bpf-next,v4,1/5] selftests/bpf: xsk selftests framework
    https://git.kernel.org/bpf/bpf-next/c/a89052572ebb
  - [bpf-next,v4,2/5] selftests/bpf: xsk selftests - SKB POLL, NOPOLL
    https://git.kernel.org/bpf/bpf-next/c/facb7cb2e909
  - [bpf-next,v4,3/5] selftests/bpf: xsk selftests - DRV POLL, NOPOLL
    https://git.kernel.org/bpf/bpf-next/c/9103a8594d93
  - [bpf-next,v4,4/5] selftests/bpf: xsk selftests - Socket Teardown - SKB, DRV
    https://git.kernel.org/bpf/bpf-next/c/6674bf66560a
  - [bpf-next,v4,5/5] selftests/bpf: xsk selftests - Bi-directional Sockets - SKB, DRV
    https://git.kernel.org/bpf/bpf-next/c/7d20441eb05e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


