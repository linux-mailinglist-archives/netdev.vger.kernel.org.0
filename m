Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5B86DE5B1
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjDKUXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDKUXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:23:31 -0400
Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB663C3C;
        Tue, 11 Apr 2023 13:23:04 -0700 (PDT)
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
        by cmsmtp with ESMTP
        id m4a6puf6W7P45mKW6pPVKP; Tue, 11 Apr 2023 20:23:03 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTP
        id mKW5pYXOpuDdbmKW6p1png; Tue, 11 Apr 2023 20:23:02 +0000
X-Authority-Analysis: v=2.4 cv=HM/Qq6hv c=1 sm=1 tr=0 ts=6435c1a6
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=d0f9/bL53tV7TyBwAeBj+g==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10 a=dKHAf1wccvYA:10
 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8 a=mDV3o1hIAAAA:8 a=VwQbUJbxAAAA:8
 a=sIshrF94AAAA:8 a=Wzh0sZPFK0vZwZ7TA3YA:9 a=QEXdDO2ut3YA:10 a=3IOs8h2EC4YA:10
 a=_FVE-zBwftR9WsbkzFJk:22 a=AjGcO6oz07-iQ99wixmX:22 a=39svzKx7NMVfYuMjZabV:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vAQB5OrwRhZSt8DZNQ7EIcCPHq37jFquzX1qe3wm1Oo=; b=JyaVBGsKBehpvCeTF9OGrH2z+E
        asL4PDUKYGZsAoJqI5w4voIUMHwuV7yRKOLxzK1P9BgOPWGq9gOaMFJcIVwB1c39aQ4mUQYV/j2Cc
        oMwAo0BI7dm15+ksLAT+AlhTzllZi6fSnzpA3PxIKvdps1tONAQFBK+T0pT2h0EyzbM9scV59M+37
        a3eddtGiNXT46j6MaGBtMLflnB/vRa7nFrbzcrhjd4buBtnfq4rASIKCyL2M1sZ3ru8oYGzjlwgCD
        TDaAzVzyz5sD1Yj33PMNXEuLwDX52ETfp1xz0KSb8K+tlPY6RtP+L2ZsrszwgYI5u1tPgyBbIMgrP
        NCqyUzgA==;
Received: from 189.215.208.238.cable.dyn.cableonline.com.mx ([189.215.208.238]:14202 helo=[192.168.0.24])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <gustavo@embeddedor.com>)
        id 1pmIsm-003i6h-P7;
        Tue, 11 Apr 2023 13:38:20 -0500
Message-ID: <cec9fa10-eb1e-dd5b-8ec0-579e87b5bc1d@embeddedor.com>
Date:   Tue, 11 Apr 2023 12:39:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH][next] wifi: mt76: Replace zero-length array with
 flexible-array member
To:     Simon Horman <simon.horman@corigine.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-hardening@vger.kernel.org
References: <ZC7X7KCb+JEkPe5D@work> <ZC/FA/t1mzrRydD7@corigine.com>
Content-Language: en-US
In-Reply-To: <ZC/FA/t1mzrRydD7@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.215.208.238
X-Source-L: No
X-Exim-ID: 1pmIsm-003i6h-P7
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 189.215.208.238.cable.dyn.cableonline.com.mx ([192.168.0.24]) [189.215.208.238]:14202
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 0
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDIrWkGexl/N/hqy94Tp3ZQKjXA/a/W9VOEuCcta6Fd5vUkEdsLrW4iPsqtmuj0EcMhPTOxFawjvk7A2na2U+swrymSfHwHyiv3bRHkpFJIkvsKJkKWw
 6bOW/vaY0lpqn9QnH0ZhqmfU1vc1MHB4akucAY17qc5pmix4tsGjM/eLblBd8LB0qBvTIMx/LJ8SnVBVVhSI6MBXsJtz3QhDje0PWjkN85QX0dR0ZzdoEBoK
 oYRbebfpsXQEDsnmuhwW/qtBzZ6u5/t/UTuSJeGj1EhuwJ4nds0rfFYKeQSk3nh1AAKrUu+dwTaACVHWcPQNcl6aJleDDANHlW9pXMiOTq9n3Y91MzsNLAuT
 i/XUsMLy
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/7/23 01:23, Simon Horman wrote:
> On Thu, Apr 06, 2023 at 08:32:12AM -0600, Gustavo A. R. Silva wrote:
>> Zero-length arrays are deprecated [1] and have to be replaced by C99
>> flexible-array members.
>>
>> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
>> on memcpy() and help to make progress towards globally enabling
>> -fstrict-flex-arrays=3 [2]
>>
>> Link: https://github.com/KSPP/linux/issues/78 [1]
>> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [2]
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Thanks :)

> 
>> ---
>>   drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
>> index a5e6ee4daf92..9bf4b4199ee3 100644
>> --- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
>> +++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
>> @@ -127,7 +127,7 @@ struct mt76_connac2_mcu_rxd {
>>   	u8 rsv1[2];
>>   	u8 s2d_index;
>>   
>> -	u8 tlv[0];
>> +	u8 tlv[];
>>   };
>>   
>>   struct mt76_connac2_patch_hdr {
> 
> Curiously -fstrict-flex-arrays=3 didn't flag this one in my environment,
> Ubuntu Lunar.

Yep; that's why I didn't include any warning message in the changelog text
this time.

And the reason for that is that tlv is not being indexed anywhere in the
code. However, it's being used in the pointer arithmetic operation below:

drivers/net/wireless/mediatek/mt76/mt7921/mcu.c:
  164         rxd = (struct mt76_connac2_mcu_rxd *)skb->data;
  165         grant = (struct mt7921_roc_grant_tlv *)(rxd->tlv + 4);


which means that it can be considered as an array of size greater than zero
at some point. Hence, it should be transformed into a C99 flexible array.

> 
>   gcc-13 --version
>   gcc-13 (Ubuntu 13-20230320-1ubuntu1) 13.0.1 20230320 (experimental) [master r13-6759-g5194ad1958c]
>   Copyright (C) 2023 Free Software Foundation, Inc.
>   This is free software; see the source for copying conditions.  There is NO
>   warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> I did, however, notice some other problems reported by gcc-13 with
> -fstrict-flex-arrays=3 in drivers/net/wireless/mediatek/mt76
> when run against net-next wireless. I've listed them in diff format below.
> 
> Are these on your radar too?

Yep; those are being addressed here:

https://lore.kernel.org/linux-hardening/ZBTUB%2FkJYQxq%2F6Cj@work/

--
Gustavo

> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
> index 35268b0890ad..d09bb4eed1ec 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
> @@ -24,7 +24,7 @@ struct mt7921_asar_dyn {
>   	u8 names[4];
>   	u8 enable;
>   	u8 nr_tbl;
> -	struct mt7921_asar_dyn_limit tbl[0];
> +	struct mt7921_asar_dyn_limit tbl[];
>   } __packed;
>   
>   struct mt7921_asar_dyn_limit_v2 {
> @@ -37,7 +37,7 @@ struct mt7921_asar_dyn_v2 {
>   	u8 enable;
>   	u8 rsvd;
>   	u8 nr_tbl;
> -	struct mt7921_asar_dyn_limit_v2 tbl[0];
> +	struct mt7921_asar_dyn_limit_v2 tbl[];
>   } __packed;
>   
>   struct mt7921_asar_geo_band {
> @@ -55,7 +55,7 @@ struct mt7921_asar_geo {
>   	u8 names[4];
>   	u8 version;
>   	u8 nr_tbl;
> -	struct mt7921_asar_geo_limit tbl[0];
> +	struct mt7921_asar_geo_limit tbl[];
>   } __packed;
>   
>   struct mt7921_asar_geo_limit_v2 {
> @@ -69,7 +69,7 @@ struct mt7921_asar_geo_v2 {
>   	u8 version;
>   	u8 rsvd;
>   	u8 nr_tbl;
> -	struct mt7921_asar_geo_limit_v2 tbl[0];
> +	struct mt7921_asar_geo_limit_v2 tbl[];
>   } __packed;
>   
>   struct mt7921_asar_cl {
> @@ -85,7 +85,7 @@ struct mt7921_asar_fg {
>   	u8 rsvd;
>   	u8 nr_flag;
>   	u8 rsvd1;
> -	u8 flag[0];
> +	u8 flag[];
>   } __packed;
>   
>   struct mt7921_acpi_sar {
