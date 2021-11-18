Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4E9456295
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhKRSnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:43:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233688AbhKRSnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 13:43:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 98D0661A38;
        Thu, 18 Nov 2021 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637260809;
        bh=iF4Z5RWl50ky//lg5jK7ZJbLbHpxC9pKAYgd12fjw6I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V2Jf/KTz+o2xX1GegF8+R7wlrJXqv7TNQi6pJdivU8i0ehjQBr2C/um8Ap6iazoTb
         buE5PIp63nUxOt3C35Mp335KDKWlIB7cNzwuEcbSX9LXArM5jrIDRvawun5rhSXpDd
         Y+ZwimwReKexp2JcmIXsqcr7ZcMPO19Uub4tNRN9dBX6RY7mcCmYrImmrarX0Ap1SD
         v5rwF8IiHxUtV5RU5KzlqxOCpKTFbpGFv7AgZO8W1JlhvnOpFOuprSUcfYwTSfHjBy
         OGOS5KINoIV4vo1VPpAeO88ub11uyjlU4iztiUvLufxzLy5MM75MT/KHtjSZpjW9W+
         FUk8w5UpiWqKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8737160A54;
        Thu, 18 Nov 2021 18:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] selfetests/bpf: Adapt vmtest.sh to s390 libbpf CI changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163726080954.15870.4494646110308405839.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 18:40:09 +0000
References: <20211118115225.1349726-1-iii@linux.ibm.com>
In-Reply-To: <20211118115225.1349726-1-iii@linux.ibm.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kpsingh@kernel.org, bpf@vger.kernel.org, hca@linux.ibm.com,
        gor@linux.ibm.com, lmb@cloudflare.com, shuah@kernel.org,
        kernel-team@cloudflare.com, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrii@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Thu, 18 Nov 2021 12:52:25 +0100 you wrote:
> [1] added s390 support to libbpf CI and added an ${ARCH} prefix to a
> number of paths and identifiers in libbpf GitHub repo, which vmtest.sh
> relies upon. Update these and make use of the new s390 support.
> 
> [1] https://github.com/libbpf/libbpf/pull/204
> 
> Co-developed-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [bpf] selfetests/bpf: Adapt vmtest.sh to s390 libbpf CI changes
    https://git.kernel.org/bpf/bpf-next/c/29ad850a5cae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


