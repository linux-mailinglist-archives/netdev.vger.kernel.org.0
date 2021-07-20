Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E983CFBBF
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239225AbhGTNdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239073AbhGTN30 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:29:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7347761164;
        Tue, 20 Jul 2021 14:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626790204;
        bh=Bd5JuhPoUZKO+A7WZ4bG6yZW93bX/sNKIzmRbyAgJVg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H4ItY9JHQjrai52JKIlz1JgnL7038sMkbsS+bm/cfY6aoBC8bucRJNi3WCqeakeNo
         MV8dXIeQd9yGSKry47TLsaSHY3s+/kbfjn23gLc5rp4yYnQsLe0LRzYbcHU79V7tQJ
         KxXJsKItwgabLk8bfHk5/ZfdEiGv6mhzqtVTOTH0tQs8NZmjmPz2WDla6iV3WPs/0B
         +oPcffLIMj9fAvHAzPxJAfeXyzXyPQDsdyl4D0ZvOQLwPaq0zqRLyvIYyMOk2HF/Ij
         vFPIjRjoMHsgC397/KhkqxAMR1c5po3f78DBO973FQcEerkvaML47NLtdTnY2aMex2
         MFq0PYajT4fbw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6630B60A19;
        Tue, 20 Jul 2021 14:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mt7530 mt7530_fdb_write only set ivl bit vid larger than
 1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679020441.11280.8855545832870036826.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:10:04 +0000
References: <20210719182359.5262-1-ericwouds@gmail.com>
In-Reply-To: <20210719182359.5262-1-ericwouds@gmail.com>
To:     Eric Woudstra <ericwouds@gmail.com>
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 19 Jul 2021 20:23:57 +0200 you wrote:
> From: Eric Woudstra <ericwouds@gmail.com>
> 
> Fixes my earlier patch which broke vlan unaware bridges.
> 
> The IVL bit now only gets set for vid's larger than 1.
> 
> Fixes: 11d8d98cbeef ("mt7530 fix mt7530_fdb_write vid missing ivl bit")
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] mt7530 mt7530_fdb_write only set ivl bit vid larger than 1
    https://git.kernel.org/netdev/net/c/7e777021780e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


