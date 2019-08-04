Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F30480A01
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 10:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfHDIdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 04:33:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45964 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfHDIdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 04:33:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so2430064wre.12;
        Sun, 04 Aug 2019 01:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vt6U1YP4aGAGLr957NKZHuWaMpL8mX3IS9JECyDQdCw=;
        b=HW6ZXPXrOsCYPW8RBQgzAbAfamlFFGF0Lwt2IVORxo7pMCTQW4EK+i6oWovdt8Rgjc
         FVtLz+zMTi3TlyIuDya9nWryRPySOsB6K10i/lqECTYBzxaRvBNTl284JlGNJQKbPTfQ
         Ryp/BBp2PdAdLKJwH+Js0BCCwyLdq2FiYwRHX6yK8RZxyDcBufNkz3XhGAyd/kYAmBop
         P9ImR0IDgfX61M36mYo2YB+FBIBtv/5FDTcjgOxO8a0yfjq7ownR0liHdSsdg76uvD+3
         K5t+tpewY39K3kNOfMmZtdiptEftOG4dGg91ps7S0ht2LoCTpbF+OfM3POvUkzVOWm1u
         lPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vt6U1YP4aGAGLr957NKZHuWaMpL8mX3IS9JECyDQdCw=;
        b=YXKMK28i7dt2G6ITZIez/qZtBRwwepJSCUDhe08FSgX43XGcFYI032+Mx4bwDtUZHD
         OtuIvcsL+kuDgyL2xyo7pIkxh33yM/P0T0tQxX4evt8DcNUbKR0/6QqypDmRmi6/F9r0
         KQFobTuBxgLk1wMAjBCn2lN61NuOsqaNwBn8HhPY7IOozbntJr/lrnf844rOsWqppecB
         iXTQZBUPKqZ0q7RzCqq1UPMnqCJmmFlMhoqOfblDUn9B230rh0F+KcgYYyTMyjbrsOmf
         1AOIe4q6/r/wMRwiLw8JnVYDPtMJffQdkhIEOA5Xs5UF2BsCzSgfjEN7iVIyFb+Z3kcb
         A/yQ==
X-Gm-Message-State: APjAAAUvH1KG1UWKY9hF+dLFmnwNqgqvea4YRHLtbyP0ZYd+mZNVL3T3
        3JX5FbcIgTwMvNsK53eHAUF2Ofre
X-Google-Smtp-Source: APXvYqwkk0phUB+FezFpivONVroN9FkS2bT2MM9s4sMwHk+g5S8UFZ33zeDE2MmafKfgRollJfkF9g==
X-Received: by 2002:adf:df8b:: with SMTP id z11mr98533802wrl.62.1564907615244;
        Sun, 04 Aug 2019 01:33:35 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:9900:d80f:58c5:990d:c59b? (p200300EA8F289900D80F58C5990DC59B.dip0.t-ipconnect.de. [2003:ea:8f28:9900:d80f:58c5:990d:c59b])
        by smtp.googlemail.com with ESMTPSA id o3sm67952020wrs.59.2019.08.04.01.33.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 01:33:34 -0700 (PDT)
Subject: Re: [PATCH v4 3/4] net: phy: realtek: Add helpers for accessing
 RTL8211E extension pages
To:     Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
References: <20190801190759.28201-1-mka@chromium.org>
 <20190801190759.28201-4-mka@chromium.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <71d817b9-7bcc-9f83-331d-1c3958c41f51@gmail.com>
Date:   Sun, 4 Aug 2019 10:33:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190801190759.28201-4-mka@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.08.2019 21:07, Matthias Kaehlcke wrote:
> The RTL8211E has extension pages, which can be accessed after
> selecting a page through a custom method. Add a function to
> modify bits in a register of an extension page and a helper for
> selecting an ext page. Use rtl8211e_modify_ext_paged() in
> rtl8211e_config_init() instead of doing things 'manually'.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> Changes in v4:
> - don't add constant RTL8211E_EXT_PAGE, it's only used once,
>   use a literal instead
> - pass 'oldpage' to phy_restore_page() in rtl8211e_select_ext_page(),
>   not 'page'
> - return 'oldpage' in rtl8211e_select_ext_page()
> - use __phy_modify() in rtl8211e_modify_ext_paged() instead of
>   reimplementing __phy_modify_changed()
> - in rtl8211e_modify_ext_paged() return directly when
>   rtl8211e_select_ext_page() fails
> ---
>  drivers/net/phy/realtek.c | 48 +++++++++++++++++++++++++++------------
>  1 file changed, 34 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index a669945eb829..e09d3b0da2c7 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -53,6 +53,36 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
>  	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
>  }
>  
> +static int rtl8211e_select_ext_page(struct phy_device *phydev, int page)

The "extended page" mechanism doesn't exist on RTL8211E only. A prefix
rtl821x like in other functions may be better therefore.

> +{
> +	int ret, oldpage;
> +
> +	oldpage = phy_select_page(phydev, 7);
> +	if (oldpage < 0)
> +		return oldpage;
> +
> +	ret = __phy_write(phydev, RTL821x_EXT_PAGE_SELECT, page);
> +	if (ret)
> +		return phy_restore_page(phydev, oldpage, ret);
> +
> +	return oldpage;
> +}
> +
> +static int rtl8211e_modify_ext_paged(struct phy_device *phydev, int page,
> +				     u32 regnum, u16 mask, u16 set)
> +{
> +	int ret = 0;
> +	int oldpage;
> +
> +	oldpage = rtl8211e_select_ext_page(phydev, page);
> +	if (oldpage < 0)
> +		return oldpage;
> +
> +	ret = __phy_modify(phydev, regnum, mask, set);
> +
> +	return phy_restore_page(phydev, oldpage, ret);
> +}
> +
>  static int rtl8201_ack_interrupt(struct phy_device *phydev)
>  {
>  	int err;
> @@ -184,7 +214,7 @@ static int rtl8211f_config_init(struct phy_device *phydev)
>  
>  static int rtl8211e_config_init(struct phy_device *phydev)
>  {
> -	int ret = 0, oldpage;
> +	int ret;
>  	u16 val;
>  
>  	/* enable TX/RX delay for rgmii-* modes, and disable them for rgmii. */
> @@ -213,19 +243,9 @@ static int rtl8211e_config_init(struct phy_device *phydev)
>  	 * 2 = RX Delay, 1 = TX Delay, 0 = SELRGV (see original PHY datasheet
>  	 * for details).
>  	 */
> -	oldpage = phy_select_page(phydev, 0x7);
> -	if (oldpage < 0)
> -		goto err_restore_page;
> -
> -	ret = __phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
> -	if (ret)
> -		goto err_restore_page;
> -
> -	ret = __phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
> -			   val);
> -
> -err_restore_page:
> -	return phy_restore_page(phydev, oldpage, ret);
> +	return rtl8211e_modify_ext_paged(phydev, 0xa4, 0x1c,
> +					 RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
> +					 val);
>  }
>  
>  static int rtl8211b_suspend(struct phy_device *phydev)
> 

