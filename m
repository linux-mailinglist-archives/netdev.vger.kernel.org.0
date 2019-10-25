Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA1BE4337
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 08:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394223AbfJYGHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 02:07:54 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:46780 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393713AbfJYGHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 02:07:53 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id CBE3D25B765;
        Fri, 25 Oct 2019 17:07:50 +1100 (AEDT)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id B0070376C; Fri, 25 Oct 2019 08:00:03 +0200 (CEST)
Date:   Fri, 25 Oct 2019 08:00:03 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jiri Kosina <trivial@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] net: Fix various misspellings of "connect"
Message-ID: <20191025060000.GA3009@verge.net.au>
References: <20191024152323.29987-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024152323.29987-1-geert+renesas@glider.be>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 05:23:23PM +0200, Geert Uytterhoeven wrote:
> Fix misspellings of "disconnect", "disconnecting", "connections", and
> "disconnected".
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/net/wimax/i2400m/usb.c                      | 2 +-
>  drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c | 4 ++--
>  include/net/cfg80211.h                              | 2 +-
>  net/netfilter/ipvs/ip_vs_ovf.c                      | 2 +-
>  net/wireless/reg.h                                  | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)

Thanks Geert,

for the IPVS portion:

Acked-by: Simon Horman <horms@verge.net.au>

