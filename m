Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003124A5710
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 06:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiBAFuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 00:50:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50328 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbiBAFuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 00:50:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD709B82D0A;
        Tue,  1 Feb 2022 05:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B15BC340F0;
        Tue,  1 Feb 2022 05:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643694609;
        bh=GU5Ibm5TNI3Rd9juV28zmB6oREvTqyPiwFkXtQsQXNk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EEQBeH34J7E6pOtOOa1FNRl9Kr/aBVxlxy/ZJiOyTAe8Ypu69Qg8Kkhvi1xI/lWvL
         uXlUrRosyxVUJu3WjmmeC3gBIYYnlp4IHhUO4EPqkPmlAW5DsgC2rhAY0aWNIm9N2a
         FqE/x12Kh1KMOVqpdOoCsZ20j/QGKtKTpCnFPsfLgMF/0W2W+ypLGQc23KYBYaBlRY
         rZ6IK3jTTrBJLffKNAAPtuPlQ/9iYKdPAxGXNg3Up8wlmAt7QoHsWSssvQR/MARLjR
         JfTB4Ku06imtSvgVVrUJpmhchgbVAb/NJmFe3tncRLM1WxErasK7oHxYj7PRFL+dPV
         7pXfES0mNqM5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 495E1E6BB3D;
        Tue,  1 Feb 2022 05:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sh_eth: kill useless initializers in
 sh_eth_{suspend|resume}()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164369460929.12551.11792109303822725872.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Feb 2022 05:50:09 +0000
References: <f09d7c64-4a2b-6973-09a4-10d759ed0df4@omp.ru>
In-Reply-To: <f09d7c64-4a2b-6973-09a4-10d759ed0df4@omp.ru>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 29 Jan 2022 21:45:45 +0300 you wrote:
> sh_eth_{suspend|resume}() initialize their local variable 'ret' to 0 but
> this value is never really used, thus we can kill those intializers...
> 
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> ---
> This patch is against DaveM's 'net-next.git' repo.
> 
> [...]

Here is the summary with links:
  - [net-next] sh_eth: kill useless initializers in sh_eth_{suspend|resume}()
    https://git.kernel.org/netdev/net-next/c/9a90986efcff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


