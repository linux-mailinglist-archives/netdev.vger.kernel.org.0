Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDF440CCBA
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 20:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhIOSrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 14:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhIOSrc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 14:47:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E047F610E8;
        Wed, 15 Sep 2021 18:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631731573;
        bh=6Jqw5jLRzxyx4PJuZTL0bBKrYEWat+ZKCcmgiUfxurE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f8WruA9MTg7Da0jXFREjQn0b+1c87NmW904DsjOTU2wpqZFIbBXEBJzGtXQazKB9W
         WOaR2f1nHCiRI1ES0TEowGIOTguHQ/7lRKHW92Wz2M27TfwaCELUjWMItbLJkoSqgK
         s5biim1BQjY5HS9d6NWiPCra0UvrElX4ms4pNlBd56gGr8kCLOzdr+fdkq5fpJrIJK
         VgUo/FDfOc+iMPW5h30B/nRlMhz5PLW5DeHhgj8TyKcb8TjsprxTvyDaOqx06Bu1ZX
         jmc886lmEV9eoyFe/lh2idFLIxmZLEwbh/7Lc/8s6wl/Ld8plbXvq+O0tMfxE7fYQo
         4w36pPzB6qE+w==
Received: by pali.im (Postfix)
        id 6DB685E1; Wed, 15 Sep 2021 20:46:10 +0200 (CEST)
Date:   Wed, 15 Sep 2021 20:46:10 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 0/9] mwifiex: Fixes for wifi p2p and AP mode
Message-ID: <20210915184610.2bdiegl3oolhe7ey@pali>
References: <20210914195909.36035-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210914195909.36035-1-verdre@v0yd.nl>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 14 September 2021 21:59:00 Jonas Dreßler wrote:
> A bunch of bugfixes for running mwifiex in the P2P and AP mode, for some prior
> discussions, see https://github.com/linux-surface/kernel/pull/71.

Changes look good,

Acked-by: Pali Rohár <pali@kernel.org>

> Jonas Dreßler (9):
>   mwifiex: Small cleanup for handling virtual interface type changes
>   mwifiex: Use function to check whether interface type change is
>     allowed
>   mwifiex: Run SET_BSS_MODE when changing from P2P to STATION vif-type
>   mwifiex: Use helper function for counting interface types
>   mwifiex: Update virtual interface counters right after setting
>     bss_type
>   mwifiex: Allow switching interface type from P2P_CLIENT to P2P_GO
>   mwifiex: Handle interface type changes from AP to STATION
>   mwifiex: Properly initialize private structure on interface type
>     changes
>   mwifiex: Fix copy-paste mistake when creating virtual interface
> 
>  .../net/wireless/marvell/mwifiex/cfg80211.c   | 370 ++++++++++--------
>  1 file changed, 197 insertions(+), 173 deletions(-)
> 
> -- 
> 2.31.1
> 
