Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C78E46166E
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245416AbhK2Ndq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343654AbhK2Nbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:31:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7302C08E997;
        Mon, 29 Nov 2021 04:10:10 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74B4E61309;
        Mon, 29 Nov 2021 12:10:10 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id D25846056B;
        Mon, 29 Nov 2021 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638187809;
        bh=QiB6FpuovEaPGQFRX74NrjKdQ4ATrryiEkbAxJpv3Wo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SivNtiha/CLe0CXrovDZxpnnmRaxFZkF2WKny7b7Wt18/cekxC2hQYfp8NRoAlJ9d
         iyqeLU/7ayRPijBIk3dsXZmn8+VhlLGZ991sCwngkc/Eh/oKhVPEEXIFmMwS7kXyR9
         mMxG+bvC89MUnRIH06ZWoVgzlAd+0MDRYh4zhB02v2QsZFlDe0ovWvvvIG+dHZd4HF
         lyoMUTlWO1u34BKVoT9X5CKQuW1K2Mi1v/YyWniVf2l92pj38JRItVkmIYXxSZymo9
         c+G+TMyzpS5YzrwIN5x13zZ43yYeytxSB1YPVCRQ8CjdRrAHTLJ7q9qGA6cdLk38Ze
         nszAFk9yydR5g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BEA1060A4D;
        Mon, 29 Nov 2021 12:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: mdio: ipq8064: replace ioremap() with
 devm_ioremap()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163818780977.15002.4203481607121206602.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 12:10:09 +0000
References: <20211126091340.1013726-1-yangyingliang@huawei.com>
In-Reply-To: <20211126091340.1013726-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, kuba@kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 26 Nov 2021 17:13:40 +0800 you wrote:
> Use devm_ioremap() instead of ioremap() to avoid iounmap() missing.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/mdio/mdio-ipq8064.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [-next] net: mdio: ipq8064: replace ioremap() with devm_ioremap()
    https://git.kernel.org/netdev/net-next/c/2f7ed29f2c54

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


