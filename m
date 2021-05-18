Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6260A388185
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 22:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352216AbhERUlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 16:41:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236628AbhERUl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 16:41:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1162161261;
        Tue, 18 May 2021 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621370410;
        bh=TAseJ99yhJLoRZux9Of22DJAGVAA3Id44LXh2zVEBUE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kNELgdyjYKjDh8vea1nUFEO+o3KRIObUgDFjvi3lN4LvByTIpQ25VXIwIcj4ZIY5r
         LX/h4Mw5IKVg5PW7mnkZdrI8WKRJOC4aXj0RXdrjEXG5Rx0ZqZdlQAUSTkMuGKQra0
         ka6Npmq+dpv1Fj+GzzMS5OrAinIXeIeuOGmhLzZ7n+ymVitbbFvEzh/nIwVHljHxC3
         u+MArNOMF/c5C9gkDRBex6A0v93KLhJ8RuJSN+8XK08wHI0goRBxWNfareDmb50ZpO
         LQ3EPCNp1WBZ4/lGmjQxZ8JYXT0MGoSVLL3VryzkJzg42VtMeqiF+Uh78CbbjVV9+B
         GlUvThGPNs71Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 05614608FB;
        Tue, 18 May 2021 20:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lan78xx: advertise tx software timestamping support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162137041001.8268.646207318665132345.git-patchwork-notify@kernel.org>
Date:   Tue, 18 May 2021 20:40:10 +0000
References: <20210511161300.3zsn4ufutgwzvst2@ipetronik.com>
In-Reply-To: <20210511161300.3zsn4ufutgwzvst2@ipetronik.com>
To:     Markus Bloechl <markus.bloechl@ipetronik.com>
Cc:     woojung.huh@microchip.com, kuba@kernel.org, davem@davemloft.net,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        markus@blochl.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 18 May 2021 11:54:11 +0200 you wrote:
> lan78xx already calls skb_tx_timestamp() in its lan78xx_start_xmit().
> Override .get_ts_info to also advertise this capability
> (SOF_TIMESTAMPING_TX_SOFTWARE) via ethtool.
> 
> Signed-off-by: Markus Blöchl <markus.bloechl@ipetronik.com>
> ---
> 
> [...]

Here is the summary with links:
  - [net] net: lan78xx: advertise tx software timestamping support
    https://git.kernel.org/netdev/net/c/33e6b1674f33

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


