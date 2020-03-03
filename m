Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E6E177AAD
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgCCPj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:39:58 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:36732 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgCCPj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:39:57 -0500
Received: from localhost.localdomain (p200300E9D71B99212E8A91B208CF7941.dip0.t-ipconnect.de [IPv6:2003:e9:d71b:9921:2e8a:91b2:8cf:7941])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id AA8F9C32DA;
        Tue,  3 Mar 2020 16:39:55 +0100 (CET)
Subject: Re: [PATCH net 05/16] nl802154: add missing attribute validation for
 dev_type
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Alexander Aring <alex.aring@gmail.com>,
        alex.bluesman.smirnov@gmail.com, linux-wpan@vger.kernel.org
References: <20200303050526.4088735-1-kuba@kernel.org>
 <20200303050526.4088735-6-kuba@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <3c27dd0a-ff54-681b-b97c-98cd9d096b41@datenfreihafen.org>
Date:   Tue, 3 Mar 2020 16:39:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303050526.4088735-6-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 03.03.20 06:05, Jakub Kicinski wrote:
> Add missing attribute type validation for IEEE802154_ATTR_DEV_TYPE
> to the netlink policy.
> 
> Fixes: 90c049b2c6ae ("ieee802154: interface type to be added")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: Alexander Aring <alex.aring@gmail.com>
> CC: Stefan Schmidt <stefan@datenfreihafen.org>
> CC: alex.bluesman.smirnov@gmail.com
> CC: linux-wpan@vger.kernel.org
> ---
>   net/ieee802154/nl_policy.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/net/ieee802154/nl_policy.c b/net/ieee802154/nl_policy.c
> index 824e7e84014c..0672b2f01586 100644
> --- a/net/ieee802154/nl_policy.c
> +++ b/net/ieee802154/nl_policy.c
> @@ -27,6 +27,7 @@ const struct nla_policy ieee802154_policy[IEEE802154_ATTR_MAX + 1] = {
>   	[IEEE802154_ATTR_BAT_EXT] = { .type = NLA_U8, },
>   	[IEEE802154_ATTR_COORD_REALIGN] = { .type = NLA_U8, },
>   	[IEEE802154_ATTR_PAGE] = { .type = NLA_U8, },
> +	[IEEE802154_ATTR_DEV_TYPE] = { .type = NLA_U8, },
>   	[IEEE802154_ATTR_COORD_SHORT_ADDR] = { .type = NLA_U16, },
>   	[IEEE802154_ATTR_COORD_HW_ADDR] = { .type = NLA_HW_ADDR, },
>   	[IEEE802154_ATTR_COORD_PAN_ID] = { .type = NLA_U16, },
> 

The reason to split this off from the patch before is to have the Fixes 
tag differently to point to its origin?

Might be a bit to much work for this little subsystem, but you did it 
already, so:


Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
