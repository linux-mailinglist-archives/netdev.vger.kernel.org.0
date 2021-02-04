Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B90430EA6D
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 03:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbhBDCut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 21:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231177AbhBDCur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 21:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B87E864F5D;
        Thu,  4 Feb 2021 02:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612407006;
        bh=L6ob6WZYh0e3GrHFygE8FBqce2CZxsaz1ACiXdZXjno=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N7QSA8djxTkQ5FpY5xX1tIWgLpeDST3SJuUstZeHzopeu/CzpOAYz6zBWPjlMu5ft
         vLLPt2ZIWbUgu+Fz0OS6KLUZrxPhIc+T0XZHP7RbugPmSaiMt1WnW96cM5mbWlS5To
         cAvWB/4K/pywWebO/owYxx9DTFU8B2VwvGOSd/LQM2XknflS5fkWRSIJKkeLXAopeA
         Eb7oNta7CIIOyu4WrS/8597/3WPtnxbcv6VyVLsW0sKSBQnwGTL8D/kwCH+O28LNOf
         cOQZ7y31ORXyTEmMBPnT1g7He91mJr6ykKzc07hINJB9Mt2rGG++xS2czODYW0wPta
         iRqzhymw/hzpw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A693B609EB;
        Thu,  4 Feb 2021 02:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] selftests/tls: fix selftest with CHACHA20-POLY1305
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161240700667.12705.4583217136956438727.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Feb 2021 02:50:06 +0000
References: <1612384634-5377-1-git-send-email-vfedorenko@novek.ru>
In-Reply-To: <1612384634-5377-1-git-send-email-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     kuba@kernel.org, borisp@nvidia.com, rong.a.chen@intel.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  3 Feb 2021 23:37:14 +0300 you wrote:
> TLS selftests were broken also because of use of structure that
> was not exported to UAPI. Fix by defining the union in tests.
> 
> Fixes: 3502bd9b5762 (selftests/tls: fix selftests after adding ChaCha20-Poly1305)
> Fixes: 4f336e88a870 (selftests/tls: add CHACHA20-POLY1305 to tls selftests)
> Reported-by: Rong Chen <rong.a.chen@intel.com>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> 
> [...]

Here is the summary with links:
  - [net-next] selftests/tls: fix selftest with CHACHA20-POLY1305
    https://git.kernel.org/netdev/net/c/d795cc02a297

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


