Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0107141C2D8
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245582AbhI2Kl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245537AbhI2Klt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:41:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E677E61425;
        Wed, 29 Sep 2021 10:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632912008;
        bh=8DLIOO7LImvOfm2kYNNuQcAOy7RWDqk620Jojf5tyKw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HZW8eiG1RYHDp88QkBLY9aiWcguZtlV5fMmbLBz+WrNnFUHSFfwh3PrX9tV/BdhK+
         3VjDqr+xqZZvTdbQgVR9r1gEp2n7UKI9z7faOS8gnv2pZbvsXXoqYqAymVtKn9K85K
         55XWRCRq2BVn/yHgbsUixCh+5C1Cw/0NJkZA61VYqWdUUqSOLcgWPYP/AOci9zrDqs
         u2vvQ/wVjXhZTMOUsxnmCwlQqREZVCTwS2c+DuDolIJTRW8Njo+f+x12/bwB4zUzXU
         3wwfqqgnIPMq5/+iM45GgXOTHqrfhNGTJJFdFED8faPScRcIsb29hyvYb4ps96W8mq
         1VvCSBFRCzxsw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D5E21609D6;
        Wed, 29 Sep 2021 10:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net/dsa/tag_ksz.c: remove superfluous headers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163291200887.26498.17658819603398502971.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Sep 2021 10:40:08 +0000
References: <20210929064106.4764-1-liumh1@shanghaitech.edu.cn>
In-Reply-To: <20210929064106.4764-1-liumh1@shanghaitech.edu.cn>
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 29 Sep 2021 14:41:06 +0800 you wrote:
> tag_ksz.c hasn't use any macro or function declared in linux/slab.h.
> Thus, these files can be removed from tag_ksz.c safely without
> affecting the compilation of the ./net/dsa module
> 
> Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> 
> 
> [...]

Here is the summary with links:
  - [-next] net/dsa/tag_ksz.c: remove superfluous headers
    https://git.kernel.org/netdev/net-next/c/ca4b0649be01

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


