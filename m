Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0E36D0FAE
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 22:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjC3UFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 16:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjC3UFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 16:05:47 -0400
X-Greylist: delayed 90 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Mar 2023 13:05:42 PDT
Received: from omta033.useast.a.cloudfilter.net (omta033.useast.a.cloudfilter.net [44.202.169.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A99F11151
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 13:05:41 -0700 (PDT)
Received: from eig-obgw-5011a.ext.cloudfilter.net ([10.0.29.161])
        by cmsmtp with ESMTP
        id hpPYpjEdKY6q8hyVGpB8Dk; Thu, 30 Mar 2023 20:04:10 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTP
        id hyVFpIMsHeShZhyVFphFdV; Thu, 30 Mar 2023 20:04:09 +0000
X-Authority-Analysis: v=2.4 cv=ZPfEJF3b c=1 sm=1 tr=0 ts=6425eb39
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=wTog8WU66it3cfrESHnF4A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10 a=k__wU0fu6RkA:10
 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8 a=mDV3o1hIAAAA:8 a=VwQbUJbxAAAA:8
 a=rQwXfPfrytjjklgZoK0A:9 a=QEXdDO2ut3YA:10 a=3IOs8h2EC4YA:10
 a=_FVE-zBwftR9WsbkzFJk:22 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=R1JjS+FsYaTvV0nY+Z+WOn3lLR0ZAanzw97ARsUZzOM=; b=OP5kZR/+CMEL3dXIpct5Z4Attb
        GEr/mWagrnRfOpXxxsgS9C0wZlw+maYWFm7GdzUFevvSjPhsOqrKEi6G/Yibp8IK4WMm7h9fXEOOw
        aJZaaYDqCty+3Vya8idObSla+jZ8Q5fgzzAOIhYtw9PKhz4wTxhwUUlW5Z2B4uOW+XVnovPmGxaMc
        XAeJZdyKGWPQiaRpCRB9bbR6xRfVHIVnMWt+sWbJU4zlSZBEz1dcslNv8tHChRzdp7oHMUnVj+2ju
        ycPBKurectZLBZnj5lX0kCHQjSvJUsmC6H0EJTwF5lMS5t03oc82OMVmG1qChdWxos7LryBflwf6X
        kJkqWHMA==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:38692 helo=[192.168.15.7])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <gustavo@embeddedor.com>)
        id 1phyVE-002aFZ-IV;
        Thu, 30 Mar 2023 15:04:08 -0500
Message-ID: <a3bfa2dd-cb4c-876e-b16a-e9cec230108f@embeddedor.com>
Date:   Thu, 30 Mar 2023 14:04:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH][next] rtlwifi: Replace fake flex-array with flex-array
 member
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <ZBz4x+MWoI/f65o1@work>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <ZBz4x+MWoI/f65o1@work>
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
X-Exim-ID: 1phyVE-002aFZ-IV
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.7]) [187.162.31.110]:38692
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNRo7tVHuRbHuolYuqwZf3LFHaMBWOedeGjOh9Xbm0tGGzwTfraIZAGFppyjGtkGemLASbPTas01FK3FzftbeaagjAxg/iLGLYHxDasBKMXOm8RdfEkn
 972pzeLp4uer06JQB4f/cn/QZVtG9DR+DXPvk8+YrfvjECL+R6b2ihW8r1sHmiGrhwP1LXEK3JP3TrUvcdfxWNfjqNspZGk354o=
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Friendly ping: who can take this, please? :)

Thanks
--
Gustavo

On 3/23/23 19:11, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Address the following warning found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
> In function ‘fortify_memset_chk’,
>      inlined from ‘rtl_usb_probe’ at drivers/net/wireless/realtek/rtlwifi/usb.c:1044:2:
> ./include/linux/fortify-string.h:430:25: warning: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
>    430 |                         __write_overflow_field(p_size_field, size);
>        |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/277
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/net/wireless/realtek/rtlwifi/wifi.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> index 31f9e9e5c680..082af216760f 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> @@ -2831,7 +2831,7 @@ struct rtl_priv {
>   	 * beyond  this structure like:
>   	 * rtl_pci_priv or rtl_usb_priv
>   	 */
> -	u8 priv[0] __aligned(sizeof(void *));
> +	u8 priv[] __aligned(sizeof(void *));
>   };
>   
>   #define rtl_priv(hw)		(((struct rtl_priv *)(hw)->priv))
