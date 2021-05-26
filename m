Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8062390D8B
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 02:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhEZAvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 20:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230157AbhEZAvl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 20:51:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A7C4361429;
        Wed, 26 May 2021 00:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621990210;
        bh=yAYBMJ8qyiWWdr2/fBkHmslBIyaLsEVu3IvKEjFLQro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b0U3ZxB6R8xZakxYg5s5lWQcG6jdkpRSvBR9+J+dH/A8AvFhTh7HsRfduSeY8UQ+X
         b1bRs3V6/WHX2XCEyCmEhgKb6TKZ0TRkgm8GeHcRT5UZRe1agoeTMeJ5nmky2Y3ZAW
         BZyhh/lppuQBYSyhP8Hp+NHnyxQJCAmBXq7k0Zx+rVS/MA8+7c5fMNAZS3gFbFnmcV
         XmkYJHofC8FJ/ApsEKzjErjwP4mTTFj0ECnIRptOjU4oVxWEV2bi0WETK9YXD6/yTZ
         l/0cTnR3n0D8KWLf3m78h9A6UqgRA6JCqQsikiMnQ/Sd6O7KKBt+QaUJnx36SrFwHh
         ovbYP0x+OciYA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9A77260A16;
        Wed, 26 May 2021 00:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 0/5] libbpf: error reporting changes for v1.0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162199021062.14557.15284960959695800366.git-patchwork-notify@kernel.org>
Date:   Wed, 26 May 2021 00:50:10 +0000
References: <20210525035935.1461796-1-andrii@kernel.org>
In-Reply-To: <20210525035935.1461796-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 24 May 2021 20:59:30 -0700 you wrote:
> Implement error reporting changes discussed in "Libbpf: the road to v1.0"
> ([0]) document.
> 
> Libbpf gets a new API, libbpf_set_strict_mode() which accepts a set of flags
> that turn on a set of libbpf 1.0 changes, that might be potentially breaking.
> It's possible to opt-in into all current and future 1.0 features by specifying
> LIBBPF_STRICT_ALL flag.
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,1/5] libbpf: add libbpf_set_strict_mode() API to turn on libbpf 1.0 behaviors
    https://git.kernel.org/bpf/bpf-next/c/5981881d21df
  - [v2,bpf-next,2/5] selftests/bpf: turn on libbpf 1.0 mode and fix all IS_ERR checks
    https://git.kernel.org/bpf/bpf-next/c/bad2e478af3b
  - [v2,bpf-next,3/5] libbpf: streamline error reporting for low-level APIs
    https://git.kernel.org/bpf/bpf-next/c/f12b65432728
  - [v2,bpf-next,4/5] libbpf: streamline error reporting for high-level APIs
    https://git.kernel.org/bpf/bpf-next/c/e9fc3ce99b34
  - [v2,bpf-next,5/5] bpftool: set errno on skeleton failures and propagate errors
    https://git.kernel.org/bpf/bpf-next/c/9c6c0449deb4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


