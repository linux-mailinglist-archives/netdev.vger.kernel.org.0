Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3B548647A
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbiAFMkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:40:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33164 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbiAFMkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:40:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55B4AB82105;
        Thu,  6 Jan 2022 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15AFDC36AE5;
        Thu,  6 Jan 2022 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641472810;
        bh=iYVXR1/jMb2yOfxvkHeqvYiW+jJC5r8+OBpy6VTftsE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T7EtfUhDsdvtV9+orJnQRMmmuuGs15fAUE+RbY3j6nN50QigjG+4BdOEwLp9GVrqn
         pS8xrfgAFfMHGkMCB58oNw63/1FihkGOyEMm/mMoRzP5kmI81DWJkqcLDuNccX4aNz
         WfuASaPkv1NhBtQXTwk4k5d0MXXWc4XHUmmEEIKDpusetQrvRJS2QDHyhiNyvumLk9
         A81XWZ0qmT/cpVoQMDnC5p7N5/p70EEEwqEG15/XjUCJ3f10/UKbcpCst9g5i27dU0
         hFf1jgvMVDNc7C0M3ZdkLnXXPRMjpaQB4Xosm7h1o7ImoH1ymGp6kABdQiVMYZUuz3
         rihrQttOEvyCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1544F7940B;
        Thu,  6 Jan 2022 12:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ppp: ensure minimum packet size in ppp_write()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147280998.4515.278949153380990499.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 12:40:09 +0000
References: <20220105114842.2380951-1-eric.dumazet@gmail.com>
In-Reply-To: <20220105114842.2380951-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, paulus@samba.org, linux-ppp@vger.kernel.org,
        syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  5 Jan 2022 03:48:42 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> It seems pretty clear ppp layer assumed user space
> would always be kind to provide enough data
> in their write() to a ppp device.
> 
> This patch makes sure user provides at least
> 2 bytes.
> 
> [...]

Here is the summary with links:
  - [net] ppp: ensure minimum packet size in ppp_write()
    https://git.kernel.org/netdev/net/c/44073187990d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


