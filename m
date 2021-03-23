Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58972346AF4
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 22:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhCWVUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 17:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233558AbhCWVUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 17:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 30E6F619D1;
        Tue, 23 Mar 2021 21:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616534408;
        bh=sCOR6WrWbz92aMpGV/iILT+sR1NhbsHUA8SyQ+Uq3zk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pKt8Z6TfVuuNQxXzbTxJw3pvslwNKtPjb+jqVA+pOpx02CN5+oK9xPVbb5k5Io3VT
         lv4dApkXbC5XBUkdv2wzrPRCqU1opif5Jt7BNWiC1AAJ4IMtGeBt55H4OcT8qn77sV
         VMURb3Bl4q6z6XPy833VgWuKvHCdYHieKZXsljGf223nTVlhDAoRwaV1caZ90j/G0b
         iSvTwzrcR7apO5DhdfFOIEANdcn7rgBkA91B9kRXfYamWGzWBjc8Sgqmau/ww8A43T
         3aWvQR5HrmA6xDQW/M2NHtBm82ETR2d/HErqXM/F1Dz+5VGZwoZiL/6fm5k9GjO6vi
         TEoJQ7IiVaTqw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2C76560A3E;
        Tue, 23 Mar 2021 21:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: dsa: hellcreek: Report switch name and ID
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161653440817.5924.3359049395983997424.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Mar 2021 21:20:08 +0000
References: <20210322185113.18095-1-kurt@kmk-computers.de>
In-Reply-To: <20210322185113.18095-1-kurt@kmk-computers.de>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 19:51:13 +0100 you wrote:
> Report the driver name, ASIC ID and the switch name via devlink. This is a
> useful information for user space tooling.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> ---
> Changes since v1:
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: dsa: hellcreek: Report switch name and ID
    https://git.kernel.org/netdev/net-next/c/1ab568e92bf8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


