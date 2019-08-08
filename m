Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA39C857D9
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 03:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389693AbfHHBy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 21:54:26 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60624 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389618AbfHHBy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 21:54:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hY+VqBVEe8YrsOfm4CkV6YFiPnTBe+TavnmufSMVkNc=; b=Dpv9BugJ1grVhUE1fNGE+xUI6
        CoHymMYw2VjTjZ+D0rxzY3RRh3ytOgAl4Ep/XIOf/SfHJtwpwf7ZMi/I2oMpl3jloqA4g5vnLYXrX
        ImxzEUix1GEZZse9pVTyZNT0woFwwbdV55JGFYanwfjnPEUXyc+sR02uWMfUXLHTh27Kh4q9qfjje
        Llx+MFeYHca2GW/rXPfgo/VepkBbYr6h4rd+LX8Hxioh9Pd4t159YGpie036vrNtnmfvSNJP/wCX0
        g02pQnZR5eqKkQhXn36dg7zStUazLFpCIS4Gw7pD1TAzmSFsGr8PJrasYP+cvpNwvAHFUqfdjL6Kb
        9FbIIBAiA==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=[192.168.1.17])
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hvXdH-0005qS-Ax; Thu, 08 Aug 2019 01:54:23 +0000
Subject: Re: [PATCH] Fix non-kerneldoc comment in realtek/rtlwifi/usb.c
To:     =?UTF-8?Q?Valdis_Kl=c4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <5924.1565217560@turing-police>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5edf09c6-1941-a7f7-b99c-950723942c61@infradead.org>
Date:   Wed, 7 Aug 2019 18:54:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5924.1565217560@turing-police>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 3:39 PM, Valdis Klētnieks wrote:
> Fix spurious warning message when building with W=1:
> 
>   CC [M]  drivers/net/wireless/realtek/rtlwifi/usb.o
> drivers/net/wireless/realtek/rtlwifi/usb.c:243: warning: Cannot understand  * on line 243 - I thought it was a doc line
> drivers/net/wireless/realtek/rtlwifi/usb.c:760: warning: Cannot understand  * on line 760 - I thought it was a doc line
> drivers/net/wireless/realtek/rtlwifi/usb.c:790: warning: Cannot understand  * on line 790 - I thought it was a doc line
> 
> Change the comment so gcc doesn't think it's a kerneldoc comment block

s:gcc:scripts/kernel-doc/

and as Larry pointed out, networking comment style is "different" from the rest
of the kernel.  :(

> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
> index e24fda5e9087..9478cc0d4f8b 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/usb.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
> @@ -239,7 +239,7 @@ static void _rtl_usb_io_handler_release(struct ieee80211_hw *hw)
>  	mutex_destroy(&rtlpriv->io.bb_mutex);
>  }
>  
> -/**
> +/*
>   *
>   *	Default aggregation handler. Do nothing and just return the oldest skb.
>   */
> @@ -756,7 +756,7 @@ static int rtl_usb_start(struct ieee80211_hw *hw)
>  	return err;
>  }
>  
> -/**
> +/*
>   *
>   *
>   */
> @@ -786,7 +786,7 @@ static void rtl_usb_cleanup(struct ieee80211_hw *hw)
>  	usb_kill_anchored_urbs(&rtlusb->tx_submitted);
>  }
>  
> -/**
> +/*
>   *
>   * We may add some struct into struct rtl_usb later. Do deinit here.
>   *
> 


-- 
~Randy
