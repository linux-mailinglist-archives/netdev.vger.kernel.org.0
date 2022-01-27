Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71B849E705
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243424AbiA0QFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238116AbiA0QFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:05:44 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F06C061714;
        Thu, 27 Jan 2022 08:05:44 -0800 (PST)
Received: from [IPV6:2003:e9:d724:a665:d7b5:f965:3476:16f8] (p200300e9d724a665d7b5f965347616f8.dip0.t-ipconnect.de [IPv6:2003:e9:d724:a665:d7b5:f965:3476:16f8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id EF6B7C02E8;
        Thu, 27 Jan 2022 17:05:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1643299543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FfsBBNyW3usZsZKpkTjNPtPSOuDwgu4XSB4iGuoPRKw=;
        b=Zv4PpLPz0FEwR6BAITIRZ3EDeyIQhvhP9iqfa2QefOgpWpQqw0pEFl4O7rlfC1fKv+GJBa
        U2oqWGXakHtvnveqY92EBICoTTazJOM2LaAzPvSvyj65QW7F6LHTJeoESNJpzRNg8IjRgE
        Fjxa+IC68Sj97laMd9Vla8oro9KJG+gBkh7XCkgVZL/U4MSbdNsk91aUhcD0+wCiPGAl9C
        KS+yiLFaQawq5rQfUf5yxOtR55Nhuy0O6E0rY1yj03Fki74IFqtkYTcODbIKgdeEuJVjTs
        gF39Bcnu8iUrH/jr6fz6NG9AceqOQwxw0SyujoYLVpBpLDPuFziKwns76LA0vQ==
Message-ID: <6903cb13-2fc9-8c8a-f247-8cbeddf51103@datenfreihafen.org>
Date:   Thu, 27 Jan 2022 17:05:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [wpan-next 4/4] net: ieee802154: Add a kernel doc header to the
 ieee802154_addr structure
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
 <20220120004350.308866-5-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220120004350.308866-5-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 20.01.22 01:43, Miquel Raynal wrote:
> From: David Girault <david.girault@qorvo.com>
> 
> While not being absolutely needed, it at least explain the mode vs. enum
> fields.
> 
> Signed-off-by: David Girault <david.girault@qorvo.com>
> [miquel.raynal@bootlin.com: Isolate this change from a bigger commit and
>                              reword the comment]
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   include/net/cfg802154.h | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index 4193c242d96e..0b8b1812cea1 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -29,6 +29,16 @@ struct ieee802154_llsec_key_id;
>   struct ieee802154_llsec_key;
>   #endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
>   
> +/**
> + * struct ieee802154_addr - IEEE802.15.4 device address
> + * @mode: Address mode from frame header. Can be one of:
> + *        - @IEEE802154_ADDR_NONE
> + *        - @IEEE802154_ADDR_SHORT
> + *        - @IEEE802154_ADDR_LONG
> + * @pan_id: The PAN ID this address belongs to
> + * @short_addr: address if @mode is @IEEE802154_ADDR_SHORT
> + * @extended_addr: address if @mode is @IEEE802154_ADDR_LONG
> + */
>   struct ieee802154_addr {
>   	u8 mode;
>   	__le16 pan_id;
> 

Same here, please fold into the addr moving patch. I see no reason why 
splitting these would make it easier or do I miss something?

regards
Stefan Schmidt
