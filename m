Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7849E3FEC4A
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 12:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245601AbhIBKlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 06:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244887AbhIBKlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 06:41:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DAAD4610F9;
        Thu,  2 Sep 2021 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630579206;
        bh=nfzd8wv9AJjbCNf/udVoWui2jMz8QWwsQPgmDGq2st8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tvh+WpgYVIcq7dgKlzxsA0KNSSV1M1vqXCoIbG6oRXvh962ExMVXQfJwSbtdfTftF
         CPjbyI627dV5nW2FLFKhz2xxeJLTbxBrMb0pILScDtIp3dYF8tIYVyUL6WPA1Ah3qi
         7bFttnSnd4PINixc3b9eslu/oS9lgWWwoeBsVssdhf7PBk4nDA9DHUaws4WZR/MCn0
         bb1UFGdmn1r0r/mxkhUVekz5Olp92TONAgrZXH0ikC6ol2Uzg3bPryVjmDKgfX/Xy5
         abIgf4UMYBb2F1emYj14nG27RxV5VqkLIzsWg+SYtBQaedzAULx35rYYUjoq0tZOlr
         /h4paKEMy2Gcg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CE19160A17;
        Thu,  2 Sep 2021 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: lantiq_gswip: fix maximum frame length
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163057920683.13463.14646467225030536879.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Sep 2021 10:40:06 +0000
References: <20210901184933.312389-1-jan@3e8.eu>
In-Reply-To: <20210901184933.312389-1-jan@3e8.eu>
To:     Jan Hoffmann <jan@3e8.eu>
Cc:     hauke@hauke-m.de, netdev@vger.kernel.org, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  1 Sep 2021 20:49:33 +0200 you wrote:
> Currently, outgoing packets larger than 1496 bytes are dropped when
> tagged VLAN is used on a switch port.
> 
> Add the frame check sequence length to the value of the register
> GSWIP_MAC_FLEN to fix this. This matches the lantiq_ppa vendor driver,
> which uses a value consisting of 1518 bytes for the MAC frame, plus the
> lengths of special tag and VLAN tags.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: lantiq_gswip: fix maximum frame length
    https://git.kernel.org/netdev/net/c/552799f8b3b0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


