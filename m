Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198B747D986
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 00:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242264AbhLVXKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 18:10:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40964 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242276AbhLVXKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 18:10:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D49C61D0D;
        Wed, 22 Dec 2021 23:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 892DDC36AEB;
        Wed, 22 Dec 2021 23:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640214609;
        bh=7Otd/kA4q/q/WsN2Gturuk9uPmb7yKnMwHrCxUaVoFk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mgMHF6nCmEVJoF0Y29PvollNcOdEVvZTQ9TSw7KQYFQcQS90idpHsXb28GBO5XvIJ
         6pP82pVQgFFzI/2tY+XYzh9JBWelPBb3lJiY5wKRzljiee5eQ/5YsVL3JCcFq4u8oa
         Z6HpU+jTFpV7RAJ5sYmNjpU0i6OvAnkSGph/1i+Bp5tHhUyOcl7ZE2olN1S0mTIND1
         U7b4mPEqKXWyEbhiZmLiCE4NKHg/CNOFAEj7TumiVbcX35/EdWit6IrQShbwruTHlF
         BQsYwpCLcyAAcs2q4zzXkkmfKFFsVUWWQaydGnG4OTE7gsj0mH7UABbBMgyZqfLwHq
         TiXecbzIIi+CA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6091AFE55BD;
        Wed, 22 Dec 2021 23:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: broadcom: bcm4908enet: remove redundant variable bytes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164021460938.4565.17826150849581845629.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Dec 2021 23:10:09 +0000
References: <20211222003937.727325-1-colin.i.king@gmail.com>
In-Reply-To: <20211222003937.727325-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Dec 2021 00:39:37 +0000 you wrote:
> The variable bytes is being used to summate slot lengths,
> however the value is never used afterwards. The summation
> is redundant so remove variable bytes.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bcm4908_enet.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - net: broadcom: bcm4908enet: remove redundant variable bytes
    https://git.kernel.org/netdev/net-next/c/62a3106697f3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


