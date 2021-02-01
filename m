Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6F730AFD2
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhBASzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhBASzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:55:02 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048F7C061573;
        Mon,  1 Feb 2021 10:54:22 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id i8so9582818ejc.7;
        Mon, 01 Feb 2021 10:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bR0aC5ypfnZlUqTIt/Yykph1tks+fUNfX9SmuXUEX1M=;
        b=aA0pXbNqeW6tnFdg4toQRwNDhzTIxjz9idIZRQytaxeyhQCx19qi5qLhxDPkSEXKTn
         TJehV7Ipy2ZfjPx3cbZKhmJoOqK1XY41DI626/6I59S6nYSIVhPTrPXvbq+lmBWin3E2
         8yryZmTQ1F4vNPwbq/+aAelLU/9WNdAMSXvHkS5BnGX+c/ySfKh0FjssQSrADosdchL2
         eVmFw/cBYZO4reBTfyz4bq2fq7uEGSscWrN3Hv+NAWeGyEV1G9XAgmkZRoOgjZj6hwAV
         kia7JhVkEPQyp7zHdWIFnhpe24KZY1ikh8dNyT6r/aRdSz8E0KQmO51DbrbSsD2XGzoP
         BwNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bR0aC5ypfnZlUqTIt/Yykph1tks+fUNfX9SmuXUEX1M=;
        b=UMYWAOqZ8tGBYcDPMlCKq2m3aPNd5nn4R1sen+MkoZWFuEtmCGW2QL+2+A4UG3SNjG
         gMmjzKirj+mbr0UpDnfW/JZe1V8Ptpv2LjBKZ8+lNyhhLRiffSfdR1QqR9ECYr3uUx1s
         gjYNfVDZO7nQrhFBdQERskOw7Aj9AYqypIVW+f8iIOwbvJkVUQI2RgglJof8yax1NDw/
         8n8cRFErTYvVPFNfKZUowThqz0gRk8EO03btbkuUR9x+02AnOxZb9gx3ZkAZtSLzSlXN
         zYk/vu6bN4HmdRfk2MNlg+8vPCdElB/ozuptjaIIUBaZbbYnMmqYf7XsdBqz2hPXezkY
         Cg+Q==
X-Gm-Message-State: AOAM533rxt8OVE9Xk0vXeK7mbtkon+lu1tI2w3Twx9nOZ+5sEBh8aX5F
        UJQmMju5itFh94NxEdgHvAkRu1ryjRc=
X-Google-Smtp-Source: ABdhPJyw20n+79OZ+ckQHrQI3hQ53ZD26a5jAFtICFkXYkkURkqP8QM/14kCg24tHdblOG3rv5nNag==
X-Received: by 2002:a17:906:1f45:: with SMTP id d5mr19630630ejk.76.1612205660322;
        Mon, 01 Feb 2021 10:54:20 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:a01e:aa5d:44a8:4129? (p200300ea8f1fad00a01eaa5d44a84129.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:a01e:aa5d:44a8:4129])
        by smtp.googlemail.com with ESMTPSA id u17sm9105575edr.0.2021.02.01.10.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 10:54:19 -0800 (PST)
Subject: Re: [PATCH] r8169: Add support for another RTL8168FP
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     "maintainer:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <nic_swsd@realtek.com>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20210201164735.1268796-1-kai.heng.feng@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e3a01903-1b3b-4f7c-4458-179fbbd27615@gmail.com>
Date:   Mon, 1 Feb 2021 19:54:15 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210201164735.1268796-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.02.2021 17:47, Kai-Heng Feng wrote:
> According to the vendor driver, the new chip with XID 0x54b is
> essentially the same as the one with XID 0x54a, but it doesn't need the
> firmware.
> 
> So add support accordingly.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/ethernet/realtek/r8169.h      |  1 +
>  drivers/net/ethernet/realtek/r8169_main.c | 21 +++++++++++++--------
>  2 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
> index 7be86ef5a584..2728df46ec41 100644
> --- a/drivers/net/ethernet/realtek/r8169.h
> +++ b/drivers/net/ethernet/realtek/r8169.h
> @@ -63,6 +63,7 @@ enum mac_version {
>  	RTL_GIGA_MAC_VER_50,
>  	RTL_GIGA_MAC_VER_51,
>  	RTL_GIGA_MAC_VER_52,
> +	RTL_GIGA_MAC_VER_53,
>  	RTL_GIGA_MAC_VER_60,
>  	RTL_GIGA_MAC_VER_61,
>  	RTL_GIGA_MAC_VER_63,
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index a569abe7f5ef..ee1f72a9d453 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -145,6 +145,7 @@ static const struct {
>  	[RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"			},
>  	[RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"			},
>  	[RTL_GIGA_MAC_VER_52] = {"RTL8168fp/RTL8117",  FIRMWARE_8168FP_3},
> +	[RTL_GIGA_MAC_VER_53] = {"RTL8168fp/RTL8117",			},
>  	[RTL_GIGA_MAC_VER_60] = {"RTL8125A"				},
>  	[RTL_GIGA_MAC_VER_61] = {"RTL8125A",		FIRMWARE_8125A_3},
>  	/* reserve 62 for CFG_METHOD_4 in the vendor driver */
> @@ -682,7 +683,7 @@ static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
>  {
>  	return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
>  	       tp->mac_version != RTL_GIGA_MAC_VER_39 &&
> -	       tp->mac_version <= RTL_GIGA_MAC_VER_52;
> +	       tp->mac_version <= RTL_GIGA_MAC_VER_53;
>  }
>  
>  static bool rtl_supports_eee(struct rtl8169_private *tp)
> @@ -1012,7 +1013,9 @@ static u16 rtl_ephy_read(struct rtl8169_private *tp, int reg_addr)
>  static void r8168fp_adjust_ocp_cmd(struct rtl8169_private *tp, u32 *cmd, int type)
>  {
>  	/* based on RTL8168FP_OOBMAC_BASE in vendor driver */
> -	if (tp->mac_version == RTL_GIGA_MAC_VER_52 && type == ERIAR_OOB)
> +	if (type == ERIAR_OOB &&
> +	    (tp->mac_version == RTL_GIGA_MAC_VER_52 ||
> +	     tp->mac_version == RTL_GIGA_MAC_VER_53))
>  		*cmd |= 0x7f0 << 18;
>  }
>  
> @@ -1164,7 +1167,7 @@ static void rtl8168_driver_start(struct rtl8169_private *tp)
>  	case RTL_GIGA_MAC_VER_31:
>  		rtl8168dp_driver_start(tp);
>  		break;
> -	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
> +	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
>  		rtl8168ep_driver_start(tp);
>  		break;
>  	default:
> @@ -1195,7 +1198,7 @@ static void rtl8168_driver_stop(struct rtl8169_private *tp)
>  	case RTL_GIGA_MAC_VER_31:
>  		rtl8168dp_driver_stop(tp);
>  		break;
> -	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
> +	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
>  		rtl8168ep_driver_stop(tp);
>  		break;
>  	default:
> @@ -1223,7 +1226,7 @@ static bool r8168_check_dash(struct rtl8169_private *tp)
>  	case RTL_GIGA_MAC_VER_28:
>  	case RTL_GIGA_MAC_VER_31:
>  		return r8168dp_check_dash(tp);
> -	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
> +	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
>  		return r8168ep_check_dash(tp);
>  	default:
>  		return false;
> @@ -1930,6 +1933,7 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
>  		{ 0x7c8, 0x608,	RTL_GIGA_MAC_VER_61 },
>  
>  		/* RTL8117 */
> +		{ 0x7cf, 0x54b,	RTL_GIGA_MAC_VER_53 },
>  		{ 0x7cf, 0x54a,	RTL_GIGA_MAC_VER_52 },
>  
>  		/* 8168EP family. */
> @@ -2274,7 +2278,7 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
>  	case RTL_GIGA_MAC_VER_38:
>  		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
>  		break;
> -	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_52:
> +	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
>  		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
>  		break;
>  	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
> @@ -2449,7 +2453,7 @@ DECLARE_RTL_COND(rtl_rxtx_empty_cond_2)
>  static void rtl_wait_txrx_fifo_empty(struct rtl8169_private *tp)
>  {
>  	switch (tp->mac_version) {
> -	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_52:
> +	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
>  		rtl_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 42);
>  		rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42);
>  		break;
> @@ -3708,6 +3712,7 @@ static void rtl_hw_config(struct rtl8169_private *tp)
>  		[RTL_GIGA_MAC_VER_50] = rtl_hw_start_8168ep_2,
>  		[RTL_GIGA_MAC_VER_51] = rtl_hw_start_8168ep_3,
>  		[RTL_GIGA_MAC_VER_52] = rtl_hw_start_8117,
> +		[RTL_GIGA_MAC_VER_53] = rtl_hw_start_8117,
>  		[RTL_GIGA_MAC_VER_60] = rtl_hw_start_8125a_1,
>  		[RTL_GIGA_MAC_VER_61] = rtl_hw_start_8125a_2,
>  		[RTL_GIGA_MAC_VER_63] = rtl_hw_start_8125b,
> @@ -5101,7 +5106,7 @@ static void rtl_hw_init_8125(struct rtl8169_private *tp)
>  static void rtl_hw_initialize(struct rtl8169_private *tp)
>  {
>  	switch (tp->mac_version) {
> -	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
> +	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
>  		rtl8168ep_stop_cmac(tp);
>  		fallthrough;
>  	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_48:
> 

I think you have to add the following in r8169_phy_config.c
[RTL_GIGA_MAC_VER_53] = rtl8117_hw_phy_config,
Or doesn't VER_53 need this?
