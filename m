Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D602480E2F
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 01:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbhL2AUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 19:20:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46290 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhL2AUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 19:20:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0BB761372;
        Wed, 29 Dec 2021 00:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01CB7C36AF2;
        Wed, 29 Dec 2021 00:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640737212;
        bh=TPkIawHHuS62RgLUd3Uiq8BxvgkJmmeZVBFd2RGBjW0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dQGtR4xjxJMpRlhH7s3l1Us/zWl8d3erSu0RrPo85yGcCQLBrnWNpNd8tqcD00ewD
         Mfaz8uRCyIBUlhEuzP7cmxZBCpMIJLr5xze7troLyOdAFiIjFPEbLI2fS9/YRY+VXM
         y1MPSk/eKDvOS6RLMKT+iDSZR4qyb5oHAD232uGaiBYQKRSRwWJq5sOjwa1eRSzj4J
         ZKF7FCAFpGebhTRFJhYjEmvN/NWeLrSSl3jjE8AXu/6T00HVQ7LiGuiJ2/wgBZHvcF
         kKMJFXwxSrd1T+DAxDMfFTqACs2eIRe6zJ6TQiQslKICZlWCSstnlK7zXgPDDLi1vm
         3YeBJHRzH5cfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8C03C395DE;
        Wed, 29 Dec 2021 00:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lantiq_etop: add blank line after declaration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164073721188.15020.13587737570748951322.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Dec 2021 00:20:11 +0000
References: <20211228220031.71576-1-olek2@wp.pl>
In-Reply-To: <20211228220031.71576-1-olek2@wp.pl>
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

On Tue, 28 Dec 2021 23:00:31 +0100 you wrote:
> This patch adds a missing line after the declaration and
> fixes the checkpatch warning:
> 
> WARNING: Missing a blank line after declarations
> +		int desc;
> +		for (desc = 0; desc < LTQ_DESC_NUM; desc++)
> 
> [...]

Here is the summary with links:
  - [net-next] net: lantiq_etop: add blank line after declaration
    https://git.kernel.org/netdev/net-next/c/4c46625bb586

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


