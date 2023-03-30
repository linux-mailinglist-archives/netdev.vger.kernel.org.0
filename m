Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EFF6D14E1
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 03:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjCaBSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 21:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjCaBSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 21:18:42 -0400
X-Greylist: delayed 91 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Mar 2023 18:18:40 PDT
Received: from omta039.useast.a.cloudfilter.net (omta039.useast.a.cloudfilter.net [44.202.169.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F9BCDD1;
        Thu, 30 Mar 2023 18:18:39 -0700 (PDT)
Received: from eig-obgw-6009a.ext.cloudfilter.net ([10.0.30.184])
        by cmsmtp with ESMTP
        id i39LpLj64JlHBi3O7peZb3; Fri, 31 Mar 2023 01:17:07 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTP
        id i3O6pU8UuaJ3Di3O6pFfpG; Fri, 31 Mar 2023 01:17:07 +0000
X-Authority-Analysis: v=2.4 cv=RqfWkQqK c=1 sm=1 tr=0 ts=64263493
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=wTog8WU66it3cfrESHnF4A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10 a=k__wU0fu6RkA:10
 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8 a=mDV3o1hIAAAA:8 a=VwQbUJbxAAAA:8
 a=lQcIFfJ85XhUBIXePCYA:9 a=QEXdDO2ut3YA:10 a=3IOs8h2EC4YA:10
 a=_FVE-zBwftR9WsbkzFJk:22 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lc2/TazxozdDnvZb/b7lHdWwz27nbeuJ3CQk1i0zndI=; b=so+gIOLSJXjWDiSsnEL8KJlMhE
        y9LJZejzwGh2PreEOGl57Bttp0lH8Q/Y+0knuhUG4cclvC8vMslE92OKvDN4xlt5casFi1b6fn7Qm
        DGk3KcLdTm1kJHvcYXc5ia8zYZLk5OxDJs7X9EtjkR1umhli04I+TJy5FSTdZWe61OuK13kgwLjYs
        1edRDqmBeKAWhc+zM+RSFNvy4nsTz0Zs9XBt3afdWSaNhjeehwlTypw3sK8YTlsPxOahDtCD+HdYS
        vNrsVJI/knYLNAXwCncEjYf7K/F5kX4qDvURjbv9DXMO6Lg0x3FNB9+hC+6SR2mXtCKrk8WR235zJ
        H7mBzkpQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:59296 helo=[192.168.15.7])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <gustavo@embeddedor.com>)
        id 1phycM-002lrn-Qy;
        Thu, 30 Mar 2023 15:11:31 -0500
Message-ID: <2f207323-9daf-e9ee-153b-d790429d0adf@embeddedor.com>
Date:   Thu, 30 Mar 2023 14:11:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH][next] wifi: mt76: mt7921: Replace fake flex-arrays with
 flexible-array members
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
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
        <angelogioacchino.delregno@collabora.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-hardening@vger.kernel.org
References: <ZBTUB/kJYQxq/6Cj@work>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <ZBTUB/kJYQxq/6Cj@work>
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
X-Exim-ID: 1phycM-002lrn-Qy
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.7]) [187.162.31.110]:59296
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 0
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNMV2MDrhgpYxh1v5u9Z2tOCdKDG1mhxa5FbD/2zSKDSh/w4BLe9GQX2FJGBexQUTEXj6GJQ8acLdLNXeCESl5J6kxFFp8byH1a8pDXaXO13i7I53wc7
 dOlEzfzCmGb2+Hw9lEjCEOzsamfE9km2gRsRr5P4FIWCtQDu9z37G5TvXFDhiHi3bu0Jb6Mjhj2NL/Or/KORF6N+6tCPCSND1jqvoEGk7j+XH4vm/ETKWKJH
 E7dE7+6e0yHveylJ1bqqPLd8z8dcG2prW2oWmXe5Mw6KADsn5bU4sMJMjOkV2WBe9GJVDPCDO7vEQpPPpyQrZfwfN4xBA86chLRUh3JkohEHHYKRsGBDmMN6
 HlOiDLvH
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

On 3/17/23 14:56, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Address the following warnings found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
> drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:266:25: warning: array subscript 0 is outside array bounds of ‘struct mt7921_asar_dyn_limit_v2[0]’ [-Warray-bounds=]
> drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:263:25: warning: array subscript 0 is outside array bounds of ‘struct mt7921_asar_dyn_limit[0]’ [-Warray-bounds=]
> drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:223:28: warning: array subscript <unknown> is outside array bounds of ‘struct mt7921_asar_geo_limit_v2[0]’ [-Warray-bounds=]
> drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:220:28: warning: array subscript <unknown> is outside array bounds of ‘struct mt7921_asar_geo_limit[0]’ [-Warray-bounds=]
> drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c:334:37: warning: array subscript i is outside array bounds of ‘u8[0]’ {aka ‘unsigned char[]’} [-Warray-bounds=]
> 
> Notice that the DECLARE_FLEX_ARRAY() helper allows for flexible-array
> members in unions.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/272
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
> index 35268b0890ad..6f2c4a572572 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
> @@ -24,7 +24,7 @@ struct mt7921_asar_dyn {
>   	u8 names[4];
>   	u8 enable;
>   	u8 nr_tbl;
> -	struct mt7921_asar_dyn_limit tbl[0];
> +	DECLARE_FLEX_ARRAY(struct mt7921_asar_dyn_limit, tbl);
>   } __packed;
>   
>   struct mt7921_asar_dyn_limit_v2 {
> @@ -37,7 +37,7 @@ struct mt7921_asar_dyn_v2 {
>   	u8 enable;
>   	u8 rsvd;
>   	u8 nr_tbl;
> -	struct mt7921_asar_dyn_limit_v2 tbl[0];
> +	DECLARE_FLEX_ARRAY(struct mt7921_asar_dyn_limit_v2, tbl);
>   } __packed;
>   
>   struct mt7921_asar_geo_band {
> @@ -55,7 +55,7 @@ struct mt7921_asar_geo {
>   	u8 names[4];
>   	u8 version;
>   	u8 nr_tbl;
> -	struct mt7921_asar_geo_limit tbl[0];
> +	DECLARE_FLEX_ARRAY(struct mt7921_asar_geo_limit, tbl);
>   } __packed;
>   
>   struct mt7921_asar_geo_limit_v2 {
> @@ -69,7 +69,7 @@ struct mt7921_asar_geo_v2 {
>   	u8 version;
>   	u8 rsvd;
>   	u8 nr_tbl;
> -	struct mt7921_asar_geo_limit_v2 tbl[0];
> +	DECLARE_FLEX_ARRAY(struct mt7921_asar_geo_limit_v2, tbl);
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
