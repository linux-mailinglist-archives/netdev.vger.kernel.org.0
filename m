Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96847354745
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 22:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240372AbhDEUA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 16:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233196AbhDEUAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 16:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AA8C3613BE;
        Mon,  5 Apr 2021 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617652809;
        bh=o9HrX1rSuXyEHqVB4rPE/DO5+NHbVpOBGotH5ThkGIA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h1f/xvXIOcuMPMizBgkUbFknrKexHZQ/veVvvOjjkOk/1I21iLyvGso8GWqA3K0uc
         dsSTX3VZe40f9SmMUtYsRYSdO4t3odn9+eMU7HU4Mpn2ATQnHBDYOpGFVs7arD3b9E
         lARcmT+4PBDzUIQlcgXIfZ7ZNClgrQOJiYrgjkxmcyttzKeuYIIJc+gw8fIR6Nf+dg
         HQvOaaJ/dGFRMenwnBzS6qaT2VV2OkKDfTU0nHpOLeFXB455kMbP2W65pCfhMCSkAq
         6kLLBZqfEcFF1f6c1bWNdUCQCTzUd6JxCzDdqPoDcA2pr+tlRdg++aMNbFOGXCTMd/
         fMMQkRZGTatsA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9D45360A2A;
        Mon,  5 Apr 2021 20:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tipc: Fix a kernel-doc warning in name_table.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161765280963.6353.12428532938155099551.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 20:00:09 +0000
References: <20210404142313.GA2471@bobwxc.top>
In-Reply-To: <20210404142313.GA2471@bobwxc.top>
To:     Wu XiangCheng <bobwxc@email.cn>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 4 Apr 2021 22:23:15 +0800 you wrote:
> Fix kernel-doc warning:
> 
> Documentation/networking/tipc:66: /home/sfr/next/next/net/tipc/name_table.c
>   :558: WARNING: Unexpected indentation.
> Documentation/networking/tipc:66: /home/sfr/next/next/net/tipc/name_table.c
>   :559: WARNING: Block quote ends without a blank line; unexpected unindent.
> 
> [...]

Here is the summary with links:
  - [net-next] tipc: Fix a kernel-doc warning in name_table.c
    https://git.kernel.org/netdev/net-next/c/85d091a794f8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


