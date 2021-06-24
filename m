Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A683B35E8
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbhFXSm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231969AbhFXSmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 14:42:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7960D613FB;
        Thu, 24 Jun 2021 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624560005;
        bh=GuW75x/Uov6toarX2fe+UEY8NYrRjldxWDXcSmWe5Ok=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u2kLxykAJQndMbdjXpGXYjpGjSMMiCKRVFibvrZvuU5PHQZp1nPbTk9gO2oldqJC5
         ZSaWq/24lT9f2Qum1Cqtgb2hmp9uoNbDk8DL/dRixyzo+y7iaFrB4jRBz+H8728xkW
         8GXd1Amgb0zRvqdHx30D3RN0eufhMCVg222Z9bOn2nmmnAMZFRApZ7rT+xCOJ6GUbk
         YGwjAzlQeFQ6TsuWD7e2f97KVKwVAwvuIWF5FLfRHltzlZAPOrj1oKThYAMD8F7Shl
         USoK7HYvkrGXHCB6xqpUU4j4Rz523v861J2xc+Wc2R3AA2EuyTLzk+1v1rDM88xqXK
         ZVxvLsF6nSUAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6733960ACA;
        Thu, 24 Jun 2021 18:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next: PATCH] net: mdiobus: fix fwnode_mdbiobus_register()
 fallback case
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162456000541.7935.16610298420010746313.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 18:40:05 +0000
References: <20210624005151.3735706-1-mw@semihalf.com>
In-Reply-To: <20210624005151.3735706-1-mw@semihalf.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jon@solid-run.com, tn@semihalf.com, jaz@semihalf.com,
        hkallweit1@gmail.com, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 24 Jun 2021 02:51:51 +0200 you wrote:
> The fallback case of fwnode_mdbiobus_register()
> (relevant for !CONFIG_FWNODE_MDIO) was defined with wrong
> argument name, causing a compilation error. Fix that.
> 
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> ---
>  include/linux/fwnode_mdio.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next:] net: mdiobus: fix fwnode_mdbiobus_register() fallback case
    https://git.kernel.org/netdev/net-next/c/c88c192dc3ea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


