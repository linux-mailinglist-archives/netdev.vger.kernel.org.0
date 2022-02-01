Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1204A6584
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239016AbiBAUPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:15:19 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:40638 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233574AbiBAUPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:15:19 -0500
Received: from [IPV6:2003:e9:d731:20df:8d81:5815:ac7:f110] (p200300e9d73120df8d8158150ac7f110.dip0.t-ipconnect.de [IPv6:2003:e9:d731:20df:8d81:5815:ac7:f110])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 7D171C0A0D;
        Tue,  1 Feb 2022 21:15:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1643746517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oeg2IC/XuiBVTGvF7owv7RN+ltwV/pzvWjKse0A91DM=;
        b=T97J0arKGUkQC/wHlV5wFp/GK4pTXExZE41A/kPELpIyxLvpg07KgkpadJFkwjaKw2jA83
        UDmJCGb+cRD1DWfMArwei/+fsLpggfV5AGQP59bT4SL9RPhfr3mKm+eFxaSorPhcqtA9j6
        aiZ4s8nL4aQ3MFWCgFfUmCeNAKkTG8iicvf5hyTMpPd/SYeFJvYeq+80fbkTTj+57w+pMa
        mqwfAwSVuMY5WZzeDNluFfl0UBKcWN3+4+/VRJxiWjAG1GICk0TlZrz2E9TsDYYH5c4aU6
        724VzBquKUUKXJnpk9V6jqB/XLtqcWwJzFecbizImMy/ix4fXdy3uF9y2aqbmA==
Message-ID: <3b5fe3a0-505c-aea4-4951-52ac8cbd89bd@datenfreihafen.org>
Date:   Tue, 1 Feb 2022 21:15:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH wpan-next v3] net: ieee802154: Provide a kdoc to the
 address structure
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220201180956.93581-1-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220201180956.93581-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 01.02.22 19:09, Miquel Raynal wrote:
> From: David Girault <david.girault@qorvo.com>
> 
> Give this structure a header to better explain its content.
> 
> Signed-off-by: David Girault <david.girault@qorvo.com>
> [miquel.raynal@bootlin.com: Isolate this change from a bigger commit and
>                              reword the comment]
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
> 
> Changes since v2:
> * Stopped moving the structure location, we can keep it there, just add
>    the kdoc.
> 
>   include/net/cfg802154.h | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index 49b4bcc24032..85f9e8417688 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -227,6 +227,16 @@ static inline void wpan_phy_net_set(struct wpan_phy *wpan_phy, struct net *net)
>   	write_pnet(&wpan_phy->_net, net);
>   }
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


This patch has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
