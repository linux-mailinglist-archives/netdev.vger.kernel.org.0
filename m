Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 787F1E379E
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 18:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407842AbfJXQOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 12:14:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43050 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405661AbfJXQOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 12:14:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BBF3960A0A; Thu, 24 Oct 2019 16:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571933688;
        bh=5LYj+S7mUQpRFG78UNWcpu0TFawfTdvqUpL+Kysi69w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hrWNeIkToNDdVRdtpTlshKMIp37BiUqtnBsa0inqk3kgJbBJYuZoYulc+KvAIf9rc
         rWGXjdWX/Knm99607FydhcAcuincgwTM7Pnx0psbG2wP+dZDm2eJ32bhWSkDZr6XBe
         MzJkSv+DIrzri8haYWstUQ9nxRAfdcUYvPCFdFG8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (unknown [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3BAAB60A0A;
        Thu, 24 Oct 2019 16:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571933686;
        bh=5LYj+S7mUQpRFG78UNWcpu0TFawfTdvqUpL+Kysi69w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Q5EX7o8UOEsIEmJ98Y9SLgS044IficfMRDPf7VvWOvqSxHiA5pviytY7GK2fFtU6P
         4AVgW+dQ+9swtwtQu+Or3dfKYeL+kmq4IOwxYNfd28CUUSZBI37hYfJT+BXMyo0wlG
         ji+kcrlTq3lRLDp+MT7ApIpA416QkGjJkqsVkDN4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3BAAB60A0A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jiri Kosina <trivial@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] net: Fix various misspellings of "connect"
References: <20191024152323.29987-1-geert+renesas@glider.be>
Date:   Thu, 24 Oct 2019 19:14:39 +0300
In-Reply-To: <20191024152323.29987-1-geert+renesas@glider.be> (Geert
        Uytterhoeven's message of "Thu, 24 Oct 2019 17:23:23 +0200")
Message-ID: <874kzyqfww.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert Uytterhoeven <geert+renesas@glider.be> writes:

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

For the wireless:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
