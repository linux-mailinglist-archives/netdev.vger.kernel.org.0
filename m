Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F43A35235D
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbhDAXUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235869AbhDAXUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 917DC6112E;
        Thu,  1 Apr 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617319209;
        bh=NIo81nfxJ+XWLbdbrh9gNElTffzRCzFV+fctkBFVqgg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cATh7/iv3nOorsWgEYQM/Aw7wwbfuxhlf9+GVwKjigEvUAeJI7acpgSNVU+u1wn+7
         SXek+JhG7qLmLFp4Zx30P4MtQ4RzUejfgtwbWZnrVn7MfA9o9v5QNzSoDJLwfphuos
         cx+7JjMdAyFz4r8zqSrJnTFWObfl83Z3qjl3mg458NkqMfgz58+z/hK3aBuOrmTmgg
         RIb5e+zFMUBMLzpkgC22umhsgdZPhG1MuRjlSixsYW8zGSaMjYQeRtjBaJ+6Vp1S5P
         yHPAzcn/l4+L8IAXQNqRXUdFQsMUDyKwX2bPzO3m6YANWeU02vATRIhCAvbcXXYAec
         H6Yh11070JqNg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8B90E609CF;
        Thu,  1 Apr 2021 23:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: smc: Remove repeated struct declaration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731920956.16404.6616325993338673178.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 23:20:09 +0000
References: <20210401084030.1002882-1-wanjiabing@vivo.com>
In-Reply-To: <20210401084030.1002882-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  1 Apr 2021 16:40:29 +0800 you wrote:
> struct smc_clc_msg_local is declared twice. One is declared at
> 301st line. The blew one is not needed. Remove the duplicate.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  net/smc/smc_core.h | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - net: smc: Remove repeated struct declaration
    https://git.kernel.org/netdev/net-next/c/ec7e48ca4bc7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


