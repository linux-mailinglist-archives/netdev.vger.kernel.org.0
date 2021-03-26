Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7D234ACD8
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 17:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhCZQul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 12:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230159AbhCZQuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 12:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C1D2861A1A;
        Fri, 26 Mar 2021 16:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616777409;
        bh=dC8qNfBquoDe5YssBmbRMDxrHbMPHBJWi6Rq0fv2cAI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XXOv+S8e/EoDZnPtJhO9hkrpWcQ2bybOIyoXkLgsJVfs4FncBmZH9AF2QFIR5O/Gk
         qmwSdwleV5/WkMCAJ2zRKdRlr3tGQ+eXpe4gefEPsfSxQeF8GSoOnpWbVWhiEYLNfl
         laiQuVteRgqa+Am6L5zjIDwixRYhycJV5dlR0coaIL9Bwh61E0zi0q1+z/NmEtQPHo
         zZzINysGlzrYLDa2EwvA9VV/2872n/JcVSxeNBLWAfPPy84nNt7s1Z9g8Ih0m90FJr
         5BKeP6o4kNbp5LY0+KchcLwz8yGlYhtuB1AgO8WJsOyX4VG/In+39zbSqekDH2P5UM
         d9ANglKtOqATw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A483460192;
        Fri, 26 Mar 2021 16:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next] libbpf: preserve empty DATASEC BTFs during static
 linking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161677740966.24745.8034280482813674858.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 16:50:09 +0000
References: <20210326043036.3081011-1-andrii@kernel.org>
In-Reply-To: <20210326043036.3081011-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com, yhs@fb.com,
        ast@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 25 Mar 2021 21:30:36 -0700 you wrote:
> Ensure that BPF static linker preserves all DATASEC BTF types, even if some of
> them might not have any variable information at all. This may happen if the
> compiler promotes local initialized variable contents into .rodata section and
> there are no global or static functions in the program.
> 
> For example,
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next] libbpf: preserve empty DATASEC BTFs during static linking
    https://git.kernel.org/bpf/bpf-next/c/36e798516078

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


