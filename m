Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66563369BE9
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244053AbhDWVLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244026AbhDWVKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 17:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 28AA261425;
        Fri, 23 Apr 2021 21:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619212216;
        bh=//zndic5OaoatcuZV8o1YzjYaE+8agomdw7EwmFNEUQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WBIVLUXBfDH/bKO/0A9dQYPoF3Kb/lLMiPBjsmepkbDh/4AWHllqJ3JlyCiAkiwu4
         1+/VBNal0tc5p/F85om3F5Y0SFGPvMjg9gf90GZeN/bj3lWDI8lhOWx0oMEPu3eUXH
         S2gAZCA0yETrxRZ+AkyElmtIdoTlnVg2FYhRTSy0eHN1c9RayuwYgKnCEj8BWRSK3X
         Ud92CSNykuAqxhB57lbKWcuVqSJDZWmzCWvfkiaK5ZRBVQqCQsBjAiIQU9WiNHz+K1
         b1iCXn6Uhqg6XLm0Hjmd4y7NLDFvPWGsOmmpDxbdLT8JyzR4u9AnZRgDdnrLCuy0Tp
         E1YwdhjfcQ3nQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1AA2560A52;
        Fri, 23 Apr 2021 21:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] mptcp: Compatibility with common msg flags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161921221610.24005.9792048959549257608.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 21:10:16 +0000
References: <20210423181709.330233-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210423181709.330233-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Apr 2021 11:17:04 -0700 you wrote:
> These patches from the MPTCP tree handle some of the msg flags that are
> typically used with TCP, to make it easier to adapt userspace programs
> for use with MPTCP.
> 
> Patches 1, 2, and 4 add support for MSG_ERRQUEUE (no-op for now),
> MSG_TRUNC, and MSG_PEEK on the receive side.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] mptcp: implement dummy MSG_ERRQUEUE support
    https://git.kernel.org/netdev/net-next/c/cb9d80f4940e
  - [net-next,2/5] mptcp: implement MSG_TRUNC support
    https://git.kernel.org/netdev/net-next/c/d976092ce1b0
  - [net-next,3/5] mptcp: ignore unsupported msg flags
    https://git.kernel.org/netdev/net-next/c/987858e5d026
  - [net-next,4/5] mptcp: add MSG_PEEK support
    https://git.kernel.org/netdev/net-next/c/ca4fb892579f
  - [net-next,5/5] selftests: mptcp: add a test case for MSG_PEEK
    https://git.kernel.org/netdev/net-next/c/df8aee6d6fa5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


