Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EFC413147
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 12:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhIUKLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 06:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhIUKLg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 06:11:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C780561168;
        Tue, 21 Sep 2021 10:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632219007;
        bh=AXUBO5ZWOGvdVXN4mxXDWhcbdfei7qReJVwhA75rVG0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eVNm+U9H8trCTj10EA663TVfcw91mgdtTHb/gBkvFsM4iHJV6UhWWLUehBCrdSoAe
         EohxAB+wvCzQY8wqeK2owB/AlcpTRG8OQyPVU/+VIfohgFrv5ss3dQ+YlstFhiDcFe
         FIHMQQpB09XIwhLcZrnTz99k6hBnZWx3vqlVWBI+ZNBRiAzFODv2/AP4DfUma7Yhs/
         17f2dWDTv2IS9xsMWXWBbvE3LtM+2qBN0HksaizgWTwmN71ksgqqfeH+Kq5SXxLfJ6
         9Uzoxv99/ZXWg608C0xcW27urhdnk13R5HsalxqB4SkF2wd5bJ638YbfxXEzMv+vbN
         CySZPeus5ovwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ADBD760A6B;
        Tue, 21 Sep 2021 10:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Doc: networking: Fox a typo in ice.rst
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163221900770.14288.12523816165639728373.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Sep 2021 10:10:07 +0000
References: <20210921064123.251742-1-standby24x7@gmail.com>
In-Reply-To: <20210921064123.251742-1-standby24x7@gmail.com>
To:     Masanari Iida <standby24x7@gmail.com>
Cc:     linux-kernel@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 21 Sep 2021 15:41:23 +0900 you wrote:
> This patch fixes a spelling typo in ice.rst
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  Documentation/networking/device_drivers/ethernet/intel/ice.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - Doc: networking: Fox a typo in ice.rst
    https://git.kernel.org/netdev/net/c/3e95cfa24e24

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


