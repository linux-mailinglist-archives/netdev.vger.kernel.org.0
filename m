Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C847D357708
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 23:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhDGVkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 17:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233744AbhDGVkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 17:40:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3319C61260;
        Wed,  7 Apr 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617831609;
        bh=+QmHG3mVQ1HXT9w/14WpnVIib8upPRXb83rg+lOFWmw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CSi2rnv+E5zZbXVDq6SLmgMd2X6xE/BIr7Fkt6MfGWJuD0JjOW7x/5TSZSNMKANh7
         ZfKT9yzMAw7Z1Gdrsr5P4ApJ9er89s1gyug3HHN2J345BN3n+tYNvBaJyWvfbOwW4d
         jQYKJKPGLde1JL9fuv6Zrp/JNJbO2C5i7KWWRm6qtTS06OW0LlJ6kybc/Gv9mMiqMp
         hA35rV7Gnb9fmqiK/Bdn3wWXGXcKaNnVooblQgjYPfbMFGkJAVXcvVA96NgVrxTyf2
         afiWXXQKzlAxcyUG64BAwsC4LjMrKvwAYX+NvrbDR2VhFciQKegUSMNrOYFMd82Ud6
         /sVPEw8FRRH/g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 24CBB60BE6;
        Wed,  7 Apr 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc/fdp: remove unnecessary assignment and label
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783160914.25121.16936488785375619390.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 21:40:09 +0000
References: <20210407031638.4416-1-samirweng1979@163.com>
In-Reply-To: <20210407031638.4416-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     davem@davemloft.net, rdunlap@infradead.org, unixbhaskar@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  7 Apr 2021 11:16:38 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> In function fdp_nci_patch_otp and fdp_nci_patch_ram，many goto
> out statements are used, and out label just return variable r.
> in some places,just jump to the out label, and in other places,
> assign a value to the variable r,then jump to the out label.
> It is unnecessary, we just use return sentences to replace goto
> sentences and delete out label.
> 
> [...]

Here is the summary with links:
  - nfc/fdp: remove unnecessary assignment and label
    https://git.kernel.org/netdev/net-next/c/872fff333fb1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


