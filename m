Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB56177AA4
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbgCCPi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:38:26 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:36718 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgCCPi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:38:26 -0500
Received: from localhost.localdomain (p200300E9D71B99212E8A91B208CF7941.dip0.t-ipconnect.de [IPv6:2003:e9:d71b:9921:2e8a:91b2:8cf:7941])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id C9297C32E0;
        Tue,  3 Mar 2020 16:38:23 +0100 (CET)
Subject: Re: [PATCH net 04/16] nl802154: add missing attribute validation
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Alexander Aring <alex.aring@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Sergey Lapin <slapin@ossfans.org>, linux-wpan@vger.kernel.org
References: <20200303050526.4088735-1-kuba@kernel.org>
 <20200303050526.4088735-5-kuba@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <20cfaa15-b4d2-9b2b-aa3f-198cef5765a2@datenfreihafen.org>
Date:   Tue, 3 Mar 2020 16:38:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303050526.4088735-5-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 03.03.20 06:05, Jakub Kicinski wrote:
> Add missing attribute validation for several u8 types.
> 
> Fixes: 2c21d11518b6 ("net: add NL802154 interface for configuration of 802.15.4 devices")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: Alexander Aring <alex.aring@gmail.com>
> CC: Stefan Schmidt <stefan@datenfreihafen.org>
> CC: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> CC: Sergey Lapin <slapin@ossfans.org>
> CC: linux-wpan@vger.kernel.org
> ---
>   net/ieee802154/nl_policy.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/net/ieee802154/nl_policy.c b/net/ieee802154/nl_policy.c
> index 2c7a38d76a3a..824e7e84014c 100644
> --- a/net/ieee802154/nl_policy.c
> +++ b/net/ieee802154/nl_policy.c
> @@ -21,6 +21,11 @@ const struct nla_policy ieee802154_policy[IEEE802154_ATTR_MAX + 1] = {
>   	[IEEE802154_ATTR_HW_ADDR] = { .type = NLA_HW_ADDR, },
>   	[IEEE802154_ATTR_PAN_ID] = { .type = NLA_U16, },
>   	[IEEE802154_ATTR_CHANNEL] = { .type = NLA_U8, },
> +	[IEEE802154_ATTR_BCN_ORD] = { .type = NLA_U8, },
> +	[IEEE802154_ATTR_SF_ORD] = { .type = NLA_U8, },
> +	[IEEE802154_ATTR_PAN_COORD] = { .type = NLA_U8, },
> +	[IEEE802154_ATTR_BAT_EXT] = { .type = NLA_U8, },
> +	[IEEE802154_ATTR_COORD_REALIGN] = { .type = NLA_U8, },
>   	[IEEE802154_ATTR_PAGE] = { .type = NLA_U8, },
>   	[IEEE802154_ATTR_COORD_SHORT_ADDR] = { .type = NLA_U16, },
>   	[IEEE802154_ATTR_COORD_HW_ADDR] = { .type = NLA_HW_ADDR, },
> 


Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
