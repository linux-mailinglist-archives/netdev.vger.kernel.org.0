Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E473A07E3
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbhFHXl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234187AbhFHXl5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 19:41:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3D0AD61278;
        Tue,  8 Jun 2021 23:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623195604;
        bh=JumYyIwURcTnjjP/XTcO0I5yPTPsc44UpUoLGgb8KsU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X2X5kYol2h+W6MxwAFn7ZYe6zsPqKnPe4WqX9FA1079vIuUKmLANCSwRQmjhwqNGh
         IOGkDa0u7zfA0JsL+sl16DWokIuSyk2FbShdGTjBqA6heCZ63aQzoCzg1qTuj2dnog
         l9whgr8FIvQy7K6djJwwJ1zMpdSQ/dGyDq2Vw76k6AbAwhYPaYGPEWQGdGg6qmVM9l
         DjmKIJVkt0AsfgRSj04Ju/FfxnnpnlckuEhV4LWEbDSqtC68Y/QgFaLMedhT5xeKew
         jFD1wt1qGZe/ZWXwkd1Vrxyq4NaGz/E/kFX42bHvmEIWDKq3vyE/1wM7yPlOK3F5YP
         g21pVcDaY/0qQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 306C4609E3;
        Tue,  8 Jun 2021 23:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: rds: fix memory leak in rds_recvmsg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162319560419.24693.834854597233838069.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 23:40:04 +0000
References: <20210608080641.16543-1-paskripkin@gmail.com>
In-Reply-To: <20210608080641.16543-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  8 Jun 2021 11:06:41 +0300 you wrote:
> Syzbot reported memory leak in rds. The problem
> was in unputted refcount in case of error.
> 
> int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
> 		int msg_flags)
> {
> ...
> 
> [...]

Here is the summary with links:
  - [v2] net: rds: fix memory leak in rds_recvmsg
    https://git.kernel.org/netdev/net/c/49bfcbfd989a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


