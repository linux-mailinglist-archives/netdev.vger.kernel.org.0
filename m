Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B403F8085
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 04:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237832AbhHZCdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 22:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237529AbhHZCdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 22:33:43 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257CEC0613CF
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 19:32:57 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n12so824613plk.10
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 19:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n2r0ptPvYIfBpDhn5yHKXrrJDDisftID/jAZHTb1hDU=;
        b=PPEZncJK42G2scZZ5cqRdzkaJpUr6vArsCe+UQ4KlPG5nrCJaRZHyN0S320EIC8xEr
         2nOzAuZTuSk3pkVKsG5IGC6qB+esxRwz1cHEJMHuhPbkvG6hglZz5U9dcvGS5LxBcmBX
         6+3Qzzr6+K6TZlOXaH6FhY8L5QSEdVn/5j5GU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n2r0ptPvYIfBpDhn5yHKXrrJDDisftID/jAZHTb1hDU=;
        b=fKA+PCqPqUSAZapjV/VU+yKsgWtQsgfwDZZFxM2LU8NOo3ERMxTONzX9pTr89X1mUy
         Shcqeq09gCpQOzrTHGWTQkbcVCNcvxgCHOZa71SqrZ/m9btH4yx1mZp6+9dzTT4zq6cr
         6+7RwY49FQw7X7pr4yjJyR2qSWbiVPYjBaDYYQ6fTAyfoj7iWqjdg9ykQr3mrIuOnuBv
         qESphcWKf0q/PocQGIhX9/PYQFt+BoX8H30dhCU0OCd9O+dUfcY3IkBA/muR5N+qzbpo
         iD8Z2tX0w94LXUB5PCLaw1JZ4ZnZgdUyYv8JfN7KbeA5+ZsqaYV6HuQsRJOfqIqmETou
         fdtg==
X-Gm-Message-State: AOAM530MWJ0VjlbN8Hb32qidDqi2DmuXafVx+FJpRZ+2QcJJ84/fNJME
        +q0Tf2JgSSEednhZ50cEgpdwkw==
X-Google-Smtp-Source: ABdhPJwXb/dF4iEPcxR7a+uTf9g7f8T1baItnfq6z00J8Zo8Sz7k80YH0F80emcY3EYmfYzbfpH9zg==
X-Received: by 2002:a17:90b:103:: with SMTP id p3mr13665422pjz.157.1629945176692;
        Wed, 25 Aug 2021 19:32:56 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u21sm1335281pgk.57.2021.08.25.19.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 19:32:55 -0700 (PDT)
Date:   Wed, 25 Aug 2021 19:32:55 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Colin Ian King <colin.king@canonical.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Kaixu Xia <kaixuxia@tencent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8192de: Style clean-ups
Message-ID: <202108251932.C28B9C4B4@keescook>
References: <20210825183350.1145441-1-keescook@chromium.org>
 <3e0b0efc0c0142bbb79cb11f927967bb@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e0b0efc0c0142bbb79cb11f927967bb@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 12:58:13AM +0000, Pkshih wrote:
> 
> > -----Original Message-----
> > From: Kees Cook [mailto:keescook@chromium.org]
> > Sent: Thursday, August 26, 2021 2:34 AM
> > To: Pkshih
> > Cc: Kees Cook; Kalle Valo; David S. Miller; Jakub Kicinski; Larry Finger; Colin Ian King;
> > linux-wireless@vger.kernel.org; netdev@vger.kernel.org; Joe Perches; Kaixu Xia;
> > linux-kernel@vger.kernel.org; linux-hardening@vger.kernel.org
> > Subject: [PATCH] rtlwifi: rtl8192de: Style clean-ups
> > 
> > Clean up some style issues:
> > - Use ARRAY_SIZE() even though it's a u8 array.
> > - Remove redundant CHANNEL_MAX_NUMBER_2G define.
> > Additionally fix some dead code WARNs.
> > 
> > Cc: Ping-Ke Shih <pkshih@realtek.com>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: Colin Ian King <colin.king@canonical.com>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 8 +++-----
> >  drivers/net/wireless/realtek/rtlwifi/wifi.h          | 1 -
> >  2 files changed, 3 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> > b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> > index b32fa7a75f17..9807c9e91998 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> > +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> > @@ -899,7 +899,7 @@ static u8 _rtl92c_phy_get_rightchnlplace(u8 chnl)
> >  	u8 place = chnl;
> > 
> >  	if (chnl > 14) {
> > -		for (place = 14; place < sizeof(channel5g); place++) {
> > +		for (place = 14; place < ARRAY_SIZE(channel5g); place++) {
> 
> There are still many places we can use ARRAY_SIZE() instead of sizeof().
> Could you fix them within this file, even this driver?
> Otherwise, this patch looks good to me.

Sure! I found a couple more and have sent a v2.

-Kees

> 
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> 
> >  			if (channel5g[place] == chnl) {
> >  				place++;
> >  				break;
> > @@ -2861,16 +2861,14 @@ u8 rtl92d_phy_sw_chnl(struct ieee80211_hw *hw)
> >  	case BAND_ON_5G:
> >  		/* Get first channel error when change between
> >  		 * 5G and 2.4G band. */
> > -		if (channel <= 14)
> > +		if (WARN_ONCE(channel <= 14, "rtl8192de: 5G but channel<=14\n"))
> >  			return 0;
> > -		WARN_ONCE((channel <= 14), "rtl8192de: 5G but channel<=14\n");
> >  		break;
> >  	case BAND_ON_2_4G:
> >  		/* Get first channel error when change between
> >  		 * 5G and 2.4G band. */
> > -		if (channel > 14)
> > +		if (WARN_ONCE(channel > 14, "rtl8192de: 2G but channel>14\n"))
> >  			return 0;
> > -		WARN_ONCE((channel > 14), "rtl8192de: 2G but channel>14\n");
> >  		break;
> >  	default:
> >  		WARN_ONCE(true, "rtl8192de: Invalid WirelessMode(%#x)!!\n",
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> > b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> > index aa07856411b1..31f9e9e5c680 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> > +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> > @@ -108,7 +108,6 @@
> >  #define	CHANNEL_GROUP_IDX_5GM		6
> >  #define	CHANNEL_GROUP_IDX_5GH		9
> >  #define	CHANNEL_GROUP_MAX_5G		9
> > -#define CHANNEL_MAX_NUMBER_2G		14
> >  #define AVG_THERMAL_NUM			8
> >  #define AVG_THERMAL_NUM_88E		4
> >  #define AVG_THERMAL_NUM_8723BE		4
> > --
> > 2.30.2
> 

-- 
Kees Cook
