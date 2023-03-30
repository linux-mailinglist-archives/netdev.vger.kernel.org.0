Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D3F6D1B68
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbjCaJJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjCaJJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:09:20 -0400
Received: from omta037.useast.a.cloudfilter.net (omta037.useast.a.cloudfilter.net [44.202.169.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E0EF77B;
        Fri, 31 Mar 2023 02:09:19 -0700 (PDT)
Received: from eig-obgw-6004a.ext.cloudfilter.net ([10.0.30.197])
        by cmsmtp with ESMTP
        id i0wmp51qxElIgiAl3p9ZK1; Fri, 31 Mar 2023 09:09:18 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTP
        id iAl2p9L7X1O1NiAl2ps9Ay; Fri, 31 Mar 2023 09:09:17 +0000
X-Authority-Analysis: v=2.4 cv=NsHCzuRJ c=1 sm=1 tr=0 ts=6426a33d
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=wTog8WU66it3cfrESHnF4A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10 a=k__wU0fu6RkA:10
 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8 a=mDV3o1hIAAAA:8 a=VwQbUJbxAAAA:8
 a=9ic7p0EMSS3MKrTfbvcA:9 a=QEXdDO2ut3YA:10 a=3IOs8h2EC4YA:10
 a=_FVE-zBwftR9WsbkzFJk:22 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QYBk0OPmCB6p8kOb/XVyJI7inLkUJjeV0vKcdLVXoPM=; b=Lf3+WC2x3Wbp3hXFbidKhgntw4
        wwL1Apr+wOS9AnVSyg2qMwVZ9S4nByhAtC5urYdc5RUvQRjUk1qruCzdqBC/LXOJ9Dyj+iazWA7pN
        2cqZFxcPrfW6qZKcCunoHBFRASPeOlejYSJwJh2AvUFG+sGFeC4qgrnMkOorw/3iSXBPJNwlwKtJE
        yS5dwOdsiwRWGJqrr3pZo80Q8g+OX9XB5oYArXpTpQDdgJ3ghhLXNtiChrM1EJmzYj8nvxmuVXiuc
        wezx1mznuADHn3pA0pWiUp63ZJjDV4AyzqsdgUJqi2LVDdr4oRt6SLXCWZa194jM54KUz14znoiMj
        Xy+GZzmQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:48012 helo=[192.168.15.7])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <gustavo@embeddedor.com>)
        id 1phyZh-002gVr-HQ;
        Thu, 30 Mar 2023 15:08:45 -0500
Message-ID: <cfd01e87-6edc-2547-894a-72e7cd5ba9ef@embeddedor.com>
Date:   Thu, 30 Mar 2023 14:09:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH][next] wifi: rndis_wlan: Replace fake flex-array with
 flexible-array member
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <ZBtIbU77L9eXqa4j@work>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <ZBtIbU77L9eXqa4j@work>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1phyZh-002gVr-HQ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.7]) [187.162.31.110]:48012
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 0
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfC3oJgzMAK1i4Dizj7Hh56BS73gmpDXb9iDKgZAv5SMl6nhjVIuANcuUZZQkZ0hzm0SLAy3tIAAS1nNEnhil6kycbSJjq6mQHC5LHbujFcVgcYUBE6Gx
 BcWEQlETfv7ZOn1xQTo7VJgYuQTY5ZZ+PwXV+1IWf2upc3AAG1JzcWFPRmEtIv+BoD842HndB+pGhoW7dZ+wzV/PaqhQS9Y6X20KISV2RS+iUddiH+qfmj97
 WbUe+picvSkMlLoj1IqMP0U7ej0wgHR6xMT+APth+OlPYdUwB17Jo+ZvGE0fZaazTk7icYzSqhUgF6n92B7Yyrr+bZ505T2zdw6KCMWocO3FkCN+dXg2H4+o
 y/onHFCB
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Friendly ping: who can take this, please? 😄

Thanks
-- 
Gustavo

On 3/22/23 12:26, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Address the following warning found with GCC-13 and
> -fstrict-flex-array=3 enabled:
> drivers/net/wireless/rndis_wlan.c:2902:23: warning: array subscript 0 is outside array bounds of ‘struct ndis_80211_auth_request[0]’ [-Warray-bounds=]
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/274
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/net/wireless/legacy/rndis_wlan.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/legacy/rndis_wlan.c b/drivers/net/wireless/legacy/rndis_wlan.c
> index bf72e5fd39cf..54c347fa54c4 100644
> --- a/drivers/net/wireless/legacy/rndis_wlan.c
> +++ b/drivers/net/wireless/legacy/rndis_wlan.c
> @@ -209,7 +209,7 @@ struct ndis_80211_status_indication {
>   	union {
>   		__le32					media_stream_mode;
>   		__le32					radio_status;
> -		struct ndis_80211_auth_request		auth_request[0];
> +		DECLARE_FLEX_ARRAY(struct ndis_80211_auth_request, auth_request);
>   		struct ndis_80211_pmkid_cand_list	cand_list;
>   	} u;
>   } __packed;
