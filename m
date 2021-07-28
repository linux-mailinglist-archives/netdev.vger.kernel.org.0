Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A8E3D96C4
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 22:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhG1UaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 16:30:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhG1UaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 16:30:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3EA2C60F45;
        Wed, 28 Jul 2021 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627504205;
        bh=tQVIUSpXgbl4/RWPNrQFzv/Jv9j02FBGnc23zK/XCLc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qluJ2bWN+q5LN8Hu2yn/5AqzRxoED0mbtjsz3VW5ntxAT1iadNIEeEt13qaghV3mM
         QSmFjbyWwihp3NdR1iShQ2bwkQ1ESQlR3AGqeQeLuPXhVNMy+yrTXl1s01RG3aeXuZ
         /JKmVavb/58AdwdWL/b0ysnZ7LCplKgtXnX4mst1kSHmRoCHfLVsesT7vSlX7AnlNa
         XilEOtFuBGsPGXFHtHZGZrfMvRVTgDFI5UxOZ8uQ+toUSMX31DZlW80v9E4BlLWEy/
         TNiRa340Yk1vjf4g9M7N7cG7nQnHHCqGDo0t742yob3K7r19A8j/LHwPdtf3BbYmam
         Zq6m6O8LHztCQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 33A8160A6C;
        Wed, 28 Jul 2021 20:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Documentation: networking: add ioam6-sysctl into index
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162750420520.29434.16308677128075780058.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Jul 2021 20:30:05 +0000
References: <20210728155912.9293-1-src.res@email.cn>
In-Reply-To: <20210728155912.9293-1-src.res@email.cn>
To:     Hu Haowen <src.res@email.cn>
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 28 Jul 2021 23:59:12 +0800 you wrote:
> Append ioam6-sysctl to toctree in order to get rid of building warnings.
> 
> Signed-off-by: Hu Haowen <src.res@email.cn>
> ---
>  Documentation/networking/index.rst | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - Documentation: networking: add ioam6-sysctl into index
    https://git.kernel.org/netdev/net-next/c/883d71a55e96

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


