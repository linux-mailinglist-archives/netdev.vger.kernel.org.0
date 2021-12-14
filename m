Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B824742CA
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbhLNMkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbhLNMkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 07:40:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B69C061748
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 04:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78F83614E7
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9E07C34614;
        Tue, 14 Dec 2021 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639485611;
        bh=/9QHX94t8caudLVmI77ZPEkCyDELYIeMdiJZKPRgfYY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GSxO+ZD8x+bHIUF1cJDGvGfrdzvehfQgnIsYdoGXglm6rEonOIctbkBUJpjTwpe17
         QA80koVcr/eUjMMBDk4Lz5NShp46rRVFy0tu6ERIYnrC1r7Mjus3Jc5eUfZ+uBFkDI
         45RVXJb7ca9mjY+d6/+injKXyAl0HIjZ4GSoUb5dQUayH6XYFlzJLm+EO+8FH7HLAK
         R39+SqxEtzelogSMtOjTv13o3Iv+YmRc3tCRyXyYZrW2rTVoQdSc9G6I9dvuVlXgwo
         vQRc867OIl0zNA4FbwxFt3fr7va9ubeDhx4cjKvtAHqLe6WtNLD81ufpKm5T+DRaL9
         71kwN4loPd8Tg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C5BE260A39;
        Tue, 14 Dec 2021 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethtool: fix null-ptr-deref on ref tracker
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163948561180.12013.15075662678815866510.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Dec 2021 12:40:11 +0000
References: <20211214013902.386186-1-kuba@kernel.org>
In-Reply-To: <20211214013902.386186-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, eric.dumazet@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Dec 2021 17:39:02 -0800 you wrote:
> dev can be a NULL here, not all requests set require_dev.
> 
> Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ethtool/netlink.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] ethtool: fix null-ptr-deref on ref tracker
    https://git.kernel.org/netdev/net-next/c/0976b888a150

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


