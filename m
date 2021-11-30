Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93021462BB3
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 05:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238237AbhK3Eda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 23:33:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37770 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbhK3Ed3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 23:33:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C0A1B8170E;
        Tue, 30 Nov 2021 04:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D567C53FC1;
        Tue, 30 Nov 2021 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638246609;
        bh=2NepT2UxNHjFhJbksmPuIO6fgos9BrB6n+vr7n4K1vw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nKY4BC3ZDmUt0EbQ4JZtyRaKr+kcBkxfCrTbC0qmnvRwfTOoIXV2JcufS40IH6qqD
         iXkX7OsW137FAxaP5fxnJBBCsuMeuDl2hAdmRMQMcrB6bpDhp/PoGkLRvt5boDcxpb
         eQzo+TWQvIQPaln/n8qOHMh/+JsH7RouA8cVCp8PJpbXnXEtV2lImxMExCm7ba+yeS
         37QT7rX3uWiU0u7yv1wSEUJZvQ7B1QRkqxQERX5dHh9OVAxzQllve8T1hRwk/OQLRy
         GR6FV/PGrJ6roi+5QxmyNt6AIygVvPm+YrSW3OhmNDSTMc298mf2Bw++Pkrzei8/m5
         QJmGOzrhdjEWA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 147AB60A50;
        Tue, 30 Nov 2021 04:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mscc: ocelot: fix missing unlock on error in
 ocelot_hwstamp_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163824660907.1110.5748829581500218696.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 04:30:09 +0000
References: <20211129151652.1165433-1-weiyongjun1@huawei.com>
In-Reply-To: <20211129151652.1165433-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 29 Nov 2021 15:16:52 +0000 you wrote:
> Add the missing mutex_unlock before return from function
> ocelot_hwstamp_set() in the ocelot_setup_ptp_traps() error
> handling case.
> 
> Fixes: 96ca08c05838 ("net: mscc: ocelot: set up traps for PTP packets")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mscc: ocelot: fix missing unlock on error in ocelot_hwstamp_set()
    https://git.kernel.org/netdev/net/c/1a59c9c55585

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


