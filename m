Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D95839AC5F
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhFCVLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229973AbhFCVLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 17:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B1DCC613EC;
        Thu,  3 Jun 2021 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622754605;
        bh=ySfnL1foLcg2ia2ArhyHfNX+pq6VlTqFrNXmFUOGEvc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sh184MY4TICWK4JzVBZ+Y9EAv+ZKWMq/kz9aVSEEgdYEERiMxhReZ0NfHqQbuvfCi
         cfnU39TjzACWhpm9ck0pluEfuF+wxrqCtZLT3WMEtRXVKlBkbSx1E4GATE3iyYrbQ3
         XwesFq3rMKWS55qeTFOc5X2lZdel0P1AtR62BMw/EYi3jBxriZUh8JCK5fu3/JsvAH
         z4ZtE2dYJs3vdDTVIHbTYsjGK4hwzv2B8O3bJbbtRWHWDAulv7WXHT+vSW8v3iXfaG
         Mc/+0PbiHlwu/B2+2RWBxMlXVDjH7YL95sPElrT4j4wsBHVdvgAZhXr5pX8viZqjEO
         Qou6ypaGrB9ZA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A161C60ACA;
        Thu,  3 Jun 2021 21:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] nfc: mrvl: remove useless "continue" at end of loop
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275460565.4513.18351247670919056182.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 21:10:05 +0000
References: <20210602112011.44473-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210602112011.44473-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     davem@davemloft.net, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  2 Jun 2021 13:20:10 +0200 you wrote:
> The "continue" statement at the end of a for loop does not have an
> effect.  Entire loop contents can be slightly simplified to increase
> code readability.  No functional change.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> [...]

Here is the summary with links:
  - [v2,1/2] nfc: mrvl: remove useless "continue" at end of loop
    https://git.kernel.org/netdev/net-next/c/a58224040f2d
  - [v2,2/2] nfc: mrvl: reduce the scope of local variables
    https://git.kernel.org/netdev/net-next/c/2c95e6c7e558

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


