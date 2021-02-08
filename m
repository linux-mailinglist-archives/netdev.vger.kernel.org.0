Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94DD3143C9
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 00:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhBHXaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 18:30:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230329AbhBHXar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 18:30:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DD0D964E31;
        Mon,  8 Feb 2021 23:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612827006;
        bh=zEgOiCBvi/VM/2tB7A5eyaHGrWb8fEGN7xDrTiJE0ks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XqAhlVYkVetKdSOPm3qJI6FqgErQpolG1zNRlzobTjyiYsZ7SGgQORIHIwv6maNuJ
         GiitSxhAzvm0afdEwamvSyDdBWVLTd6+UG8hea9XJ+FdPeiW518BPqPBDP/BCxKWCW
         BNtZDubMwKiEVSSlO/EZ4V4/2OO4RN0Unw4qomGfcEwVkPU842QUIkpVEaYQuMYH4C
         L0MqljXOr/RzyjrjjDnY5gkXl6g4w4t+Wz90RwEIbv1peFKVvu5q776njA4u0EJJvT
         Hjmxvre7/u/xROfkw79jFz7JGIypMq1NdWIwjYyLaTvnZqUdcMTnevBbnOwADMgmSx
         07oRb3BqksF5g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CC695609D2;
        Mon,  8 Feb 2021 23:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: tc-testing: u32: Add tests covering sample option
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161282700683.2204.14293410276954690015.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Feb 2021 23:30:06 +0000
References: <20210208151004.26501-1-phil@nwl.cc>
In-Reply-To: <20210208151004.26501-1-phil@nwl.cc>
To:     Phil Sutter <phil@nwl.cc>
Cc:     shuah@kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, stephen@networkplumber.org,
        jhs@mojatatu.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  8 Feb 2021 16:10:04 +0100 you wrote:
> Kernel's key folding basically consists of shifting away least
> significant zero bits in mask and masking the resulting value with
> (divisor - 1). Test for u32's 'sample' option to behave identical.
> 
> Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> [...]

Here is the summary with links:
  - selftests: tc-testing: u32: Add tests covering sample option
    https://git.kernel.org/netdev/net-next/c/373e13bc6363

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


