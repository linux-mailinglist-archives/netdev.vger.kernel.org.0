Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17BA46C31B
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 19:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240734AbhLGSxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 13:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240720AbhLGSxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 13:53:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98731C061746;
        Tue,  7 Dec 2021 10:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 90D78CE1DC8;
        Tue,  7 Dec 2021 18:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBD77C341C7;
        Tue,  7 Dec 2021 18:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638903008;
        bh=AK7lOZrBDyij9h+PB67VKiE9zFl6rJNkB+40pFJQY1c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FRGPLJWouOJE6AdIYRBbO26ZYNSRRjutSvtsQtwQA+CxXdzrv0+EwKuM2FM4Ks9Qj
         S1j3/9Uj8aQOMKFUNO/McWcIA8Ocw1DsKV1HKuw+CmFlfYjo4sj1u4vu9Ho0DQY0w7
         e1qWbHPuW+4oL3C6l3D16pA5RzIVAeknIwVGxGNE6ZMMOEEoWSZ0LPrjzx/6ZuU8Sp
         crcmZCmhb/FpI9l8RTVPce1EJTpJxCHy+mU/0xrUj/m7uNRnHf/tXp68igRt4YRPa4
         zjtaX+3dGrYZqgJtsoEujhc4K1FlboALJXeqmZMj2VwwPNbff9STon92KGj8k+Cp/4
         1Y7dH4Ds0FG6A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9F5DF60979;
        Tue,  7 Dec 2021 18:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/qla3xxx: fix an error code in ql_adapter_up()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163890300864.2839.3049773414415891716.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Dec 2021 18:50:08 +0000
References: <20211207082416.GA16110@kili>
In-Reply-To: <20211207082416.GA16110@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     GR-Linux-NIC-Dev@marvell.com, ron.mercer@qlogic.com,
        davem@davemloft.net, kuba@kernel.org, jeff@garzik.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 7 Dec 2021 11:24:16 +0300 you wrote:
> The ql_wait_for_drvr_lock() fails and returns false, then this
> function should return an error code instead of returning success.
> 
> The other problem is that the success path prints an error message
> netdev_err(ndev, "Releasing driver lock\n");  Delete that and
> re-order the code a little to make it more clear.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/qla3xxx: fix an error code in ql_adapter_up()
    https://git.kernel.org/netdev/net/c/d17b9737c2bc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


