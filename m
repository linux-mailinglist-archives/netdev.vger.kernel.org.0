Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F6F3A07F4
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbhFHXmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235579AbhFHXmA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 19:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 351A6613BC;
        Tue,  8 Jun 2021 23:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623195606;
        bh=HPTe0Pt7xPO/bl7CBFMALBHy6E9DK2spYtNrVR7lD64=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NS4WQAh6pR7VIFBhxyScpAVgd1X7k5pXxV8I7sd4URMUOgshhq/Y3V6p+AIBLCwFs
         SS8m0J3gmQJ9xQKVN34tKw6VNZotZN1b/77IxYUqBJNC8QFCMmT8NHQG4ftydryipi
         apA8qfM7WBaaBMvm+VQ34oS+SfkeZ2D6q7/kTv75vYgnEq+wVrIdaW4DtZokEQL3bf
         yMM2I5bc/j2Tgm9cX8v6AdnQ/PzcQ/Ya80znUa5j20maS+rMH9c7X8mNWKSlFZQPon
         k09lB3WjXQjgabYMbvCe2YXuOqcGrBMLE2bRe3qaGHWi+faWOE7oLDFWZ2y56UHWyH
         86wH1WsPe0KAQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2A6C7609E3;
        Tue,  8 Jun 2021 23:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: x25: Use list_for_each_entry() to simplify code
 in x25_forward.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162319560616.24693.4749938341746092636.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 23:40:06 +0000
References: <20210608133007.69476-1-wanghai38@huawei.com>
In-Reply-To: <20210608133007.69476-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ms@dev.tdt.de,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 8 Jun 2021 13:30:07 +0000 you wrote:
> Convert list_for_each() to list_for_each_entry() where
> applicable. This simplifies the code.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/x25/x25_forward.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net-next] net: x25: Use list_for_each_entry() to simplify code in x25_forward.c
    https://git.kernel.org/netdev/net-next/c/96bffe70231c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


