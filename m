Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2F93F83DD
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 10:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240560AbhHZIky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 04:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhHZIkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 04:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AC8576103A;
        Thu, 26 Aug 2021 08:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629967206;
        bh=l4DOtfW8WE92nEO04GuUSBNgGVf0wzpGNjg9AArKnkE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EEfD35ddLrrVxfjVuMu2X+sbMYvTdo6xYgCQindmGGRCRa6JdeQptY7azEmgehj3x
         oLbuNQQtJ71Yh+9p16c1XBX/fcqrz4lpl0tL/S5kC5B6IhGdDguccP5cjKHlrYGcBZ
         zJ8l6vQ/FkkcBRzdmAEfnMuaKysNQayILQkNr6X2FVjICbheARgnXe2BpUXVsOgvux
         IyFW8RFLtm3Iobk5Cyzc6aIivPCVYDEU+fS9jmums0eDpCgtdw9SRdoNbrc0VKZdRU
         AFF6Fu/fswfyrRq9sxm2e/YBLF76O7+l2Uz+HIK1roHWZTrz1JaT19cVWk4ONpdI9M
         EHm9GVWGNzl2Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A07D260A14;
        Thu, 26 Aug 2021 08:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/6] nfc: microread: remove unused header includes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162996720665.19943.14666053219399203179.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 08:40:06 +0000
References: <20210825142459.226168-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210825142459.226168-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Aug 2021 16:24:54 +0200 you wrote:
> Do not include unnecessary headers.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  drivers/nfc/microread/mei.c       | 1 -
>  drivers/nfc/microread/microread.c | 1 -
>  2 files changed, 2 deletions(-)

Here is the summary with links:
  - [1/6] nfc: microread: remove unused header includes
    https://git.kernel.org/netdev/net-next/c/ffb239e29518
  - [2/6] nfc: mrvl: remove unused header includes
    https://git.kernel.org/netdev/net-next/c/d8eb4eb0ef1d
  - [3/6] nfc: pn544: remove unused header includes
    https://git.kernel.org/netdev/net-next/c/9b3f66bc0eca
  - [4/6] nfc: st-nci: remove unused header includes
    https://git.kernel.org/netdev/net-next/c/2603ca872040
  - [5/6] nfc: st21nfca: remove unused header includes
    https://git.kernel.org/netdev/net-next/c/994a63434133
  - [6/6] nfc: st95hf: remove unused header includes
    https://git.kernel.org/netdev/net-next/c/7fe2f1bc15be

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


