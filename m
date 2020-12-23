Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D39F2E15A9
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731245AbgLWCuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:50:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731204AbgLWCur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4D361225AC;
        Wed, 23 Dec 2020 02:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608691807;
        bh=EruoWiD1ZGUu19U4yzQcVQuC6+SMrJ/mGfMf7C/GlDs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HXSODSFnp3jO8lbeRtKV4h98ySlW1BCP+7DyRIgRI6TqNcPv1lPu6dEPvPLlCSCGS
         gegZA2yVLyO3PFrD9AYbwR/Kt6s3BpHDeaHCgsFFNFpn645lqstG3VBQXMKvaE8HYN
         KgFzTnOUJ2rZN0Mm9/0IFGfK5+RtnoxHRI5muAJ/4Oeo3/sp+VCx4hFwGzciuQETfT
         edMF2dcCfrKoaPKyszYxUwxTE71v/31pufC0JR9rukn+7TTGHxFNJIu+QL9f8g2R60
         IIJIbS7GG73DJ/xPzqhd/A6yjRRBkixQ4sUfNX7kDSvrPut/KrxEOAV7dcWBv9XY88
         NB7WGTPqXPRQA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 3E05660113;
        Wed, 23 Dec 2020 02:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ibmvnic: fix login buffer memory leak
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160869180724.29227.18193097363858256471.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Dec 2020 02:50:07 +0000
References: <20201219213919.21045-1-ljp@linux.ibm.com>
In-Reply-To: <20201219213919.21045-1-ljp@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 19 Dec 2020 15:39:19 -0600 you wrote:
> Commit 34f0f4e3f488 ("ibmvnic: Fix login buffer memory leaks") frees
> login_rsp_buffer in release_resources() and send_login()
> because handle_login_rsp() does not free it.
> Commit f3ae59c0c015 ("ibmvnic: store RX and TX subCRQ handle array in
> ibmvnic_adapter struct") frees login_rsp_buffer in handle_login_rsp().
> It seems unnecessary to free it in release_resources() and send_login().
> There are chances that handle_login_rsp returns earlier without freeing
> buffers. Double-checking the buffer is harmless since
> release_login_buffer and release_login_rsp_buffer will
> do nothing if buffer is already freed.
> 
> [...]

Here is the summary with links:
  - [net] ibmvnic: fix login buffer memory leak
    https://git.kernel.org/netdev/net/c/a0c8be56affa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


