Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B268837B29B
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhEKXeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:34:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229952AbhEKXeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 19:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B37226162B;
        Tue, 11 May 2021 23:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620775989;
        bh=uqexOSN0PGIDkMEwL+EsM7yRoQqVZHcrpOKMprylBYg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g2BtB99tGBhQaO+QzZiVRTLztvKS1JfeigjaGIRc96T/PfNznx6IDy8CJuIVafb7P
         CZxoJMoEbSV12+T6ffG73p1ZUM9NVi5mhBkF8VkgmadSUwUCg2kK2Y6R6F7aJYOn3A
         QUI5cvYIPNv1wDyvpkhSWFrZOk3YvJYWyDlpkNK1cMVs31LNGu/YnMrAS5WSZfKdF+
         L8lEIpS1VZa4mEarjKofTeDCGMB9WHc6v280Ln+y2NoCu22Mt+5qXYtVwX0oPLJ1q6
         VWP6fe014vY3LzTkCxeENXtEuHZTOtRwbUgZqhKIfHnIg5Ew/GBNILP0i3UD3wzcmn
         NDSFLe2TSH0SA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A16EA60CD3;
        Tue, 11 May 2021 23:33:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] mptcp: fix data stream corruption
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162077598965.17752.6409841760129894025.git-patchwork-notify@kernel.org>
Date:   Tue, 11 May 2021 23:33:09 +0000
References: <0c393b7ad78e0bab142f48d53995aaa8636b44d9.1620753167.git.pabeni@redhat.com>
In-Reply-To: <0c393b7ad78e0bab142f48d53995aaa8636b44d9.1620753167.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        max@internet.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue, 11 May 2021 19:13:51 +0200 you wrote:
> Maxim reported several issues when forcing a TCP transparent proxy
> to use the MPTCP protocol for the inbound connections. He also
> provided a clean reproducer.
> 
> The problem boils down to 'mptcp_frag_can_collapse_to()' assuming
> that only MPTCP will use the given page_frag.
> 
> [...]

Here is the summary with links:
  - [v2,net] mptcp: fix data stream corruption
    https://git.kernel.org/bpf/bpf/c/29249eac5225

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


