Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA2549E700
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243409AbiA0QEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:04:44 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:40838 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238386AbiA0QEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:04:44 -0500
Received: from [IPV6:2003:e9:d724:a665:d7b5:f965:3476:16f8] (p200300e9d724a665d7b5f965347616f8.dip0.t-ipconnect.de [IPv6:2003:e9:d724:a665:d7b5:f965:3476:16f8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id C943EC0AA9;
        Thu, 27 Jan 2022 17:04:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1643299482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r6l64ysRMSB2kc26/F2X0Sizt9cvfxhS8L7sLJlrudQ=;
        b=rJYOMeLahuLQvn6llhHtJrBhqKksXGZCT07Q0ldEKwEs5c9Hu700oF63waDwYhVLtWbXC6
        sD9Etqzz/4L3AOM8euoLnkCdGpscu5UnugtYcV3XPKbLx6sONpu1X52nn0tjIPXUBnEEAj
        VhhCIjk1u8edjni2ch0BDNzo4O5E28c3zgk1MX84suJ2rTCGFqK+bVhgWvkKywCpztHG61
        HM26hmTL0gE9kkmcBC99NAxdud1wb8QUOfnw8A+wuAfs15r9kSTcbQgAgIA+iFpd9WBYzw
        PNER+ypJCnbRaL1/qdNzntgMSL7Gi7PJvlcUH6a66LcockbHNaFONyv41YU3pg==
Message-ID: <53c2d017-a7a5-3ed0-a68c-6b67c96b5b54@datenfreihafen.org>
Date:   Thu, 27 Jan 2022 17:04:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [wpan-next 2/4] net: mac802154: Include the softMAC stack inside
 the IEEE 802.15.4 menu
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220120004350.308866-1-miquel.raynal@bootlin.com>
 <20220120004350.308866-3-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220120004350.308866-3-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 20.01.22 01:43, Miquel Raynal wrote:
> From: David Girault <david.girault@qorvo.com>
> 
> The softMAC stack has no meaning outside of the IEEE 802.15.4 stack and
> cannot be used without it.
> 
> Signed-off-by: David Girault <david.girault@qorvo.com>
> [miquel.raynal@bootlin.com: Isolate this change from a bigger commit]
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   net/Kconfig            | 1 -
>   net/ieee802154/Kconfig | 1 +
>   2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/Kconfig b/net/Kconfig
> index 0da89d09ffa6..a5e31078fd14 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -228,7 +228,6 @@ source "net/x25/Kconfig"
>   source "net/lapb/Kconfig"
>   source "net/phonet/Kconfig"
>   source "net/6lowpan/Kconfig"
> -source "net/mac802154/Kconfig"
>   source "net/sched/Kconfig"
>   source "net/dcb/Kconfig"
>   source "net/dns_resolver/Kconfig"
> diff --git a/net/ieee802154/Kconfig b/net/ieee802154/Kconfig
> index 31aed75fe62d..7e4b1d49d445 100644
> --- a/net/ieee802154/Kconfig
> +++ b/net/ieee802154/Kconfig
> @@ -36,6 +36,7 @@ config IEEE802154_SOCKET
>   	  for 802.15.4 dataframes. Also RAW socket interface to build MAC
>   	  header from userspace.
>   
> +source "net/mac802154/Kconfig"
>   source "net/ieee802154/6lowpan/Kconfig"
>   
>   endif
> 

Please fold this patch into the previous one moving the Kconfig option 
around. This can be done in one go.

regards
Stefan Schmidt
