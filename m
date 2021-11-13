Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2982244F12C
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 05:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbhKMEXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 23:23:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235370AbhKMEXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 23:23:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AC29F61077;
        Sat, 13 Nov 2021 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636777209;
        bh=2aWRaDNe6g6kiWR3BICVaGbq4eXEtDG1Lf2Gu3D2aw0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bm3EeGAUTTk4QDn+6FOwu0YHH+ABXAkSeYyxL4HK80so6N+GG+1lxt4Zb8408jos1
         pRYpLubPJ66HDkoI4OQL7cZbtw3+Uyk32ZxIfqJw0OCUFBwN35SnVrHecZZKXlznCG
         vJpAfNNbj5X4In+YpRUvXu1fV4QpUtCFwiulk1DxeIoyzx8XL6DCd2betmDlTgEq3D
         9BW1GYu1e1Kk86qyDTgv1ogj3YDAcdTZC+LzLv0ZBUnASSna48Hgc8CAFajamCAyaW
         8nOVRcSoJ44AFStJgV0RMEnRYwWiUwxElVdWpgYS8nbbbKfy6dTVjMqh/inEnaJ8NY
         Ko8Lxguwsm3Ww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 94650609F7;
        Sat, 13 Nov 2021 04:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] ptp: ptp_clockmatrix: repair non-kernel-doc comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163677720960.27008.8189288307099433414.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Nov 2021 04:20:09 +0000
References: <20211111155034.29153-1-rdunlap@infradead.org>
In-Reply-To: <20211111155034.29153-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, lkp@intel.com, min.li.xe@renesas.com,
        richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 11 Nov 2021 07:50:34 -0800 you wrote:
> Do not use "/**" to begin a comment that is not in kernel-doc format.
> 
> Prevents this docs build warning:
> 
> drivers/ptp/ptp_clockmatrix.c:1679: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>     * Maximum absolute value for write phase offset in picoseconds
> 
> [...]

Here is the summary with links:
  - [v2] ptp: ptp_clockmatrix: repair non-kernel-doc comment
    https://git.kernel.org/netdev/net/c/87530779de04

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


