Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86ECC3DC145
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 00:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbhG3WuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 18:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229604AbhG3WuM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 18:50:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0510C6103B;
        Fri, 30 Jul 2021 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627685407;
        bh=KrgDcsnEA0xiT/fNwiHZ2n8yXqP2ojwtZC9H9FeteeY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bsSQyIfeVWAdrC8aa/Grw8ap7VuAEHwvBpkl5yoW5AI88GOnJSQlBg9PXEOlnassy
         FLpINXF4/KZfRtAkzdejicONiQoAYvDpa1vTn6Rap9zojjADoY3eezg2/i24uC3r+O
         BA6ACXgS9u2eB7YDXW8XYp/Z+1+pMlrjvPJf+RjIwRXjbmIzuNSuBBa8tV6m3xqu6D
         bRL5CtE5b3ydocvVy3OiDMN9XJB6h6scJjjdCpomStaSpkQsgHrFpauMDc5t8jADKG
         tNd2si7+0OMljYL5Nk84Pa6waut5LlYuWNVbmomipFs6RFhKT6XRJQwVZxCJfUNAGo
         XO6xTh3rVdOPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EADD060A7F;
        Fri, 30 Jul 2021 22:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/7] tools: bpftool: update,
 synchronise and validate types and options
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162768540695.9078.16392492200639204040.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Jul 2021 22:50:06 +0000
References: <20210730215435.7095-1-quentin@isovalent.com>
In-Reply-To: <20210730215435.7095-1-quentin@isovalent.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Fri, 30 Jul 2021 22:54:28 +0100 you wrote:
> To work with the different program types, map types, attach types etc.
> supported by eBPF, bpftool needs occasional updates to learn about the new
> features supported by the kernel. When such types translate into new
> keyword for the command line, updates are expected in several locations:
> typically, the help message displayed from bpftool itself, the manual page,
> and the bash completion file should be updated. The options used by the
> different commands for bpftool should also remain synchronised at those
> locations.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/7] tools: bpftool: slightly ease bash completion updates
    https://git.kernel.org/bpf/bpf-next/c/510b4d4c5d4c
  - [bpf-next,v2,2/7] selftests/bpf: check consistency between bpftool source, doc, completion
    https://git.kernel.org/bpf/bpf-next/c/a2b5944fb4e0
  - [bpf-next,v2,3/7] tools: bpftool: complete and synchronise attach or map types
    https://git.kernel.org/bpf/bpf-next/c/b544342e52fc
  - [bpf-next,v2,4/7] tools: bpftool: update and synchronise option list in doc and help msg
    https://git.kernel.org/bpf/bpf-next/c/c07ba629df97
  - [bpf-next,v2,5/7] selftests/bpf: update bpftool's consistency script for checking options
    https://git.kernel.org/bpf/bpf-next/c/da87772f086f
  - [bpf-next,v2,6/7] tools: bpftool: document and add bash completion for -L, -B options
    https://git.kernel.org/bpf/bpf-next/c/8cc8c6357c8f
  - [bpf-next,v2,7/7] tools: bpftool: complete metrics list in "bpftool prog profile" doc
    https://git.kernel.org/bpf/bpf-next/c/475a23c2c15f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


