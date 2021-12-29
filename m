Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6780480E34
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 01:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbhL2AUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 19:20:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46294 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbhL2AUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 19:20:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAF7961376;
        Wed, 29 Dec 2021 00:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18EFAC36AF5;
        Wed, 29 Dec 2021 00:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640737212;
        bh=7wbgcliWguWksjYh0PfvkdzdzT766t2s2U3DRDONARI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KGGxrfjM5WDYcXUgjVEbvJOqjLmx0aUSZwIe9ZMKM9lMpQv/6Yb0Yy58DWDo1LVCo
         lieUQonA/KNbtYut+ehaOdViKhe67M0IFcXOqHopRPi8TpS6m5OEC2qgdReEDgcsPR
         5G3tHiDpmKZ9QAtOQjSzn5qmdkWzc8tBA+Vdm/GdFJJrvMbdFv7tD8lHIg3s5/sqfT
         BR5+9ArJeHyoM5B/Jff+KNruyczMvhgVaE7HiFmT4M4l2Fegaq0npl7cc1QlgpWPl9
         K0f/efHdhyLf7vUrUZnnawtKDsQD8BfF4YB+e85acb5Vr7bUn1HF1REuGaNU+o+4dC
         Zw3F9FSV73eEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ED210C395EA;
        Wed, 29 Dec 2021 00:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lantiq_etop: add missing comment for wmb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164073721196.15020.13716536575815220472.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Dec 2021 00:20:11 +0000
References: <20211228214910.70810-1-olek2@wp.pl>
In-Reply-To: <20211228214910.70810-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     davem@davemloft.net, kuba@kernel.org, rdunlap@infradead.org,
        jgg@ziepe.ca, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Dec 2021 22:49:10 +0100 you wrote:
> This patch adds the missing code comment for memory barrier
> call and fixes checkpatch warning:
> 
> WARNING: memory barrier without comment
> +	wmb();
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> 
> [...]

Here is the summary with links:
  - [net-next] net: lantiq_etop: add missing comment for wmb()
    https://git.kernel.org/netdev/net-next/c/723955913e77

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


