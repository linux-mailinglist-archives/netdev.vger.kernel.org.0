Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F71F2D6081
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392069AbgLJPu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 10:50:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391220AbgLJPur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 10:50:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607615406;
        bh=0qJqGR7NJ6MrKTHUAiHQXL8i++tVg1cPBL40mBH3AEU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i7i3tb7perYB5FJJjd8fCJ2knALY4t0KfXCZrLn84PfaLyM1KJmVOx+ki6PUyTcsD
         tCRcGzygLM0nLipr7bGooES77DofSmR2HM28femy0qSBlZzSC41CF1Hg7pXQ1dz4dv
         XIcLHzQmh1v1oXtf7UOlm4Ni4t3W/IfGtJKJo6/Z4Yysri/KfYvPpWlA6BmwWPUZVC
         NrHbrbVOUbWLCNOLy2NohQWBjRt7T7dX9dyWm4bFo81dsaIE+zo01Z4751jQVLSR+3
         P/VqB6HFZqN6pOgBn5qnE1cBGKyNuPCnwLoXxIlO6BeD9lTVsQo8sGdaR0TqOnEFSK
         rjnkjY3J2sgFw==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: xsk selftests - adding xdpxceiver to
 .gitignore
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160761540641.22459.4581872627602354561.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Dec 2020 15:50:06 +0000
References: <20201210115435.3995-1-weqaar.a.janjua@intel.com>
In-Reply-To: <20201210115435.3995-1-weqaar.a.janjua@intel.com>
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

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 10 Dec 2020 11:54:35 +0000 you wrote:
> This patch adds *xdpxceiver* to selftests/bpf/.gitignore
> 
> Reported-by: Yonghong Song <yhs@fb.com>
> Suggested-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
> ---
>  tools/testing/selftests/bpf/.gitignore | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [bpf-next] selftests/bpf: xsk selftests - adding xdpxceiver to .gitignore
    https://git.kernel.org/bpf/bpf-next/c/7535a3526dfe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


