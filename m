Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EBF3DDAC3
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhHBOUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235749AbhHBOUX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:20:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8D7F661101;
        Mon,  2 Aug 2021 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627914007;
        bh=8mgyhIXJA5PFEisva2Gfj3fxbA1ZQ79PPsfYPXD+NWg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jrFwi/aY4aTeZFYY2fCoPACCXkdvtPdBoJABieITJFzh5fWSqZboknxIcxDim08Z7
         je9MpNH1xBvb4aue3cZNtYGyBk522+da2fkoa4ZL5aeQLdRohGw3TMqleyOzVJs72D
         NptxJ+rlf0wvRrwlS+V+fBXAhbKQxtk4qbGxEXuijPRfrLkkT57ifMZdDRqCofldAy
         aY6SipAp8hqdb6TsBgYvgv0HY5HMCErfdCgkraAC8+RScFwvbp3CKL7OuJGZSjxXFo
         /55oGnnRiyxKRguj5a907DYkdGekf7GBSATbtU9415C9OKqtxIiZwKiLZFMwbqxxWu
         1VPisMsaD0rtg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 885866098C;
        Mon,  2 Aug 2021 14:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: remove the struct packet_type argument
 from dsa_device_ops::rcv()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162791400755.18419.5849516595046562292.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 14:20:07 +0000
References: <20210731141432.2183420-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210731141432.2183420-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 31 Jul 2021 17:14:32 +0300 you wrote:
> No tagging driver uses this.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/net/dsa.h          |  7 ++-----
>  net/dsa/dsa.c              |  2 +-
>  net/dsa/tag_ar9331.c       |  3 +--
>  net/dsa/tag_brcm.c         | 14 +++++---------
>  net/dsa/tag_dsa.c          |  6 ++----
>  net/dsa/tag_gswip.c        |  3 +--
>  net/dsa/tag_hellcreek.c    |  3 +--
>  net/dsa/tag_ksz.c          |  6 ++----
>  net/dsa/tag_lan9303.c      |  3 +--
>  net/dsa/tag_mtk.c          |  3 +--
>  net/dsa/tag_ocelot.c       |  3 +--
>  net/dsa/tag_ocelot_8021q.c |  3 +--
>  net/dsa/tag_qca.c          |  3 +--
>  net/dsa/tag_rtl4_a.c       |  3 +--
>  net/dsa/tag_sja1105.c      |  6 ++----
>  net/dsa/tag_trailer.c      |  3 +--
>  net/dsa/tag_xrs700x.c      |  3 +--
>  17 files changed, 25 insertions(+), 49 deletions(-)

Here is the summary with links:
  - [net-next] net: dsa: remove the struct packet_type argument from dsa_device_ops::rcv()
    https://git.kernel.org/netdev/net-next/c/29a097b77477

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


