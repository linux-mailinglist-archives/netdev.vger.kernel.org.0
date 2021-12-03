Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2C846796E
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 15:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381494AbhLCOdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 09:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381470AbhLCOdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 09:33:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1A8C061353;
        Fri,  3 Dec 2021 06:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8542B82809;
        Fri,  3 Dec 2021 14:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88F68C53FC7;
        Fri,  3 Dec 2021 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638541809;
        bh=4mB5BZP4gOdBQw5DhdzZ5cF/vQBC8Jc5Om6X1F480Vo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DrrbgdwNC7ijZRsK06IOZb+kqz57/XcUFpYjMpb9Aoad0mboUeq9Yp4iqQbgT/mn1
         Yg1i5wKgz19pKWuTaWg61Z4AICfSAZy18c1GTT4GyWolCUVwnw39KCZgBbGjk+wfIf
         ypfeWN2m64kRH443amqmpGyc31hj6uEn8ro4+hydKebtvvJSUh8pEq6OwQ7dZ5gD7R
         3gQcT6+otEUl+9lGmJh/NqRSRMQSxDCDkcFsC9nsDgxx24cpUNlnIzalNwwIUOS8GZ
         Ns4W7G9E0p+NcmmywIizKbwVNpA/xMvhnvsoGSo43bg/owLSsvbagPMnZ4CR06UBd6
         fvuXl+zSKeu2A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5F53060A90;
        Fri,  3 Dec 2021 14:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: altera: set a couple error code in probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163854180938.31528.10810863401650692084.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 14:30:09 +0000
References: <20211203101128.GG2480@kili>
In-Reply-To: <20211203101128.GG2480@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     joyce.ooi@intel.com, vbridgers2013@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 3 Dec 2021 13:11:28 +0300 you wrote:
> There are two error paths which accidentally return success instead of
> a negative error code.
> 
> Fixes: bbd2190ce96d ("Altera TSE: Add main and header file for Altera Ethernet Driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/altera/altera_tse_main.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net] net: altera: set a couple error code in probe()
    https://git.kernel.org/netdev/net/c/badd7857f5c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


