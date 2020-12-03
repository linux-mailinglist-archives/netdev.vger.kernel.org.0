Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461452CCC63
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 03:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387781AbgLCCUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 21:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387480AbgLCCUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 21:20:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606962006;
        bh=PmOR/3Jwy2DiXfBoFoyNSkupSCUYoWEfmZe/pfqfWn4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nR0IQTt0AZ37GNilZIj6cLRhukpv5C4dXUUqzB4mAMj5Co/3gk+S15Ay0MOxuA47o
         gwNMeO0Z3YoErjaIs0NrIERKb/pDtGv+aQNHmWJP53o57GuweqFFJwDLjwmIX2MWyN
         8uqKFv7IjUSdGLuXB4PDoE7MCf1jWdllkCYWHbP6qKjWqHoLbts28/HigGqVm8P4bv
         TnnWPuTwJc/Ga9AoGwWAEnz+q2ZFSE128ho9TqcsbaReDyckdTUcRw89kZF/nKwe6z
         FWCT70bqtxzVtG76v+Y4nlD4Jhjssc4AqYDA4k72kXibUFUFA+l4ugIdH1h2t8lyED
         dQ4b2xLChAiuA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: pasemi: fix error return code in pasemi_mac_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160696200668.5625.17402221031379450900.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Dec 2020 02:20:06 +0000
References: <1606903035-1838-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1606903035-1838-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jeff@garzik.org,
        olof@lixom.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 2 Dec 2020 17:57:15 +0800 you wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 72b05b9940f0 ("pasemi_mac: RX/TX ring management cleanup")
> Fixes: 8d636d8bc5ff ("pasemi_mac: jumbo frame support")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: pasemi: fix error return code in pasemi_mac_open()
    https://git.kernel.org/netdev/net/c/aba84871bd4f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


