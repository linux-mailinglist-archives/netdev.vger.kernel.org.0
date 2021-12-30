Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B02D481828
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 02:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbhL3BkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 20:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhL3BkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 20:40:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C5FC061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 17:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA9346145C
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 01:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F7FDC36AEA;
        Thu, 30 Dec 2021 01:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640828410;
        bh=lZY5gejYiqMM3l+PLcW50iJclYufm70/LmTlqrM0KXM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xx3ZBIyryI0vCLAmW6Ma1RUVuWfIc5jkpAo/sJN8UTL3l45BKWsIAWSUNZC4SWQWT
         mvyvuW0mc8Yj94l5k5Ll2aAdyQ3lAVTH1AWyVkIGXOyttN4Gn3SovIXDKLWSg3vcvD
         prZDlZpMHY9F8YGFuBTI4o6ZU6m7vBG9h7UdoI1S6WxGBtCZR6tCsSK55oKKyJ0NhL
         RToGGYlwo7RQm/mFfktFBkj8wPrMrqTSRwieZHbRWGcINThcvrQUJMu9DrvKsBD+Jz
         g0+Zv3P8yZkXYl9ou4qxCTIrJrP9coQD06W0VwjpLBUr3ZyurgRAXukDdsop40wNPx
         O3pCLJbdLOhFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE913C395E4;
        Thu, 30 Dec 2021 01:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: net: Fix a typo in udpgro_fwd.sh
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164082840990.20677.17367324818133078005.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 01:40:09 +0000
References: <d247d7c8-a03a-0abf-3c71-4006a051d133@163.com>
In-Reply-To: <d247d7c8-a03a-0abf-3c71-4006a051d133@163.com>
To:     Jianguo Wu <wujianguo106@163.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Dec 2021 15:27:30 +0800 you wrote:
> From: Jianguo Wu <wujianguo@chinatelecom.cn>
> 
> Fixes: a062260a9d5f ("selftests: net: add UDP GRO forwarding self-tests")
> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
> ---
>  tools/testing/selftests/net/udpgro_fwd.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - selftests: net: Fix a typo in udpgro_fwd.sh
    https://git.kernel.org/netdev/net/c/add25d6d6c85

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


