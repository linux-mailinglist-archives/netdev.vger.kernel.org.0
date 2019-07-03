Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027A95ED50
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfGCUPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:15:03 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39635 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfGCUOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:14:48 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so3700184wma.4;
        Wed, 03 Jul 2019 13:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XmLOd+p0JgmgIlnd7bMvpY8Tsp66N+reijdHvL3zhss=;
        b=UutNf0Z7dky+r9PFHWEu3m9xRc1dUFow4rhDzsfM8ervufN/P9vKhrXIcVJG47JBNb
         79rMRa/DUpzVkuGcPaa5+zhEZ8+fLRkK+OA9metu1dJNaOjTmRL+orGlu0onOAGzrWzO
         T/9UY8XsHPoiKIbYjqs7A7ZXH4DSv37yYtQ39SNVxtEB5CH+zr3D7ooA4mO1Z8KUvyx6
         WnQnDWmoogueguUZXCqYyXZ5yx9T/q3Njp5XyljWIXcTheCDv6fwauwqrhNEGo+AEQX2
         U3LIAUnEPRZ6JmqIkNd0U+kTRT1kOeZr+KRnmDwLlQEfbQGqWxJq+hgLyyTJyMSZny/c
         o7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XmLOd+p0JgmgIlnd7bMvpY8Tsp66N+reijdHvL3zhss=;
        b=GTQrpIjVaTOcmU09LvsjQXmCL2NK0bZq/u6UyAzqjvdWpZLT8kfMominItldWUAq7K
         zSH0uHcCfn0gk8/eQF1ZCZ2DFyT/PO56Prr0o1oz6hb3cXx1ZqZ+qW4KPxnURIggd8SG
         9L86xD6Uhyr1OdM3ji7KVybxWp/VxnyrEuDyUEIc0lOpUO6a80fY8IA9evVRxzwqDhlB
         egBXLhud/o+tzHPzCWB721VXGucRBIvWxcdgnNEShbM8e7xjzg1aqt5pbuttX2sqHdUY
         0I3UHkOjJsX3Hqtkz7bdZIU8ESVKKdTgIICNi95n/EdAlgj+61+xA7udovv3I1I5A/in
         kjqw==
X-Gm-Message-State: APjAAAULCbYiRlrxrbB2HGQbSjHwy2Ns/MFHMF+xbRTnXSNitzoZyAgA
        I+QZVgIwrQEaFm20DFhET20=
X-Google-Smtp-Source: APXvYqwxAEOBCLw3GwEBgAeoN0UwkYXe5VKpWEUjsQcoURDx01SdrXhfx4IhxR4bafG7o7TLEld8yQ==
X-Received: by 2002:a05:600c:28d:: with SMTP id 13mr9236443wmk.5.1562184886564;
        Wed, 03 Jul 2019 13:14:46 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:4503:872e:8227:c4e0? (p200300EA8BD60C004503872E8227C4E0.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:4503:872e:8227:c4e0])
        by smtp.googlemail.com with ESMTPSA id f7sm3722601wrv.38.2019.07.03.13.14.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 13:14:46 -0700 (PDT)
Subject: Re: [PATCH v2 4/7] net: phy: realtek: Enable accessing RTL8211E
 extension pages
To:     Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-4-mka@chromium.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <dd7a569b-41e4-5925-88fc-227e69c82f67@gmail.com>
Date:   Wed, 3 Jul 2019 22:12:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190703193724.246854-4-mka@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.07.2019 21:37, Matthias Kaehlcke wrote:
> The RTL8211E has extension pages, which can be accessed after
> selecting a page through a custom method. Add a function to
> modify bits in a register of an extension page and a helper for
> selecting an ext page.
> 
> rtl8211e_modify_ext_paged() is inspired by its counterpart
> phy_modify_paged().
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> Changes in v2:
> - assign .read/write_page handlers for RTL8211E

Maybe this was planned, but it's not part of the patch.

> - use phy_select_page() and phy_restore_page(), get rid of
>   rtl8211e_restore_page()
> - s/rtl821e_select_ext_page/rtl8211e_select_ext_page/
> - updated commit message
> ---
>  drivers/net/phy/realtek.c | 42 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index eb815cbe1e72..9cd6241e2a6d 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -27,6 +27,9 @@
>  #define RTL821x_EXT_PAGE_SELECT			0x1e
>  #define RTL821x_PAGE_SELECT			0x1f
>  
> +#define RTL8211E_EXT_PAGE			7
> +#define RTL8211E_EPAGSR				0x1e
> +
>  /* RTL8211E page 5 */
>  #define RTL8211E_EEE_LED_MODE1			0x05
>  #define RTL8211E_EEE_LED_MODE2			0x06
> @@ -58,6 +61,44 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
>  	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
>  }
>  
> +static int rtl8211e_select_ext_page(struct phy_device *phydev, int page)
> +{
> +	int ret, oldpage;
> +
> +	oldpage = phy_select_page(phydev, RTL8211E_EXT_PAGE);
> +	if (oldpage < 0)
> +		return oldpage;
> +
> +	ret = __phy_write(phydev, RTL8211E_EPAGSR, page);
> +	if (ret)
> +		return phy_restore_page(phydev, page, ret);
> +
> +	return 0;
> +}
> +
> +static int __maybe_unused rtl8211e_modify_ext_paged(struct phy_device *phydev,
> +				    int page, u32 regnum, u16 mask, u16 set)

This __maybe_unused isn't too nice as you use the function in a subsequent patch.

> +{
> +	int ret = 0;
> +	int oldpage;
> +	int new;
> +
> +	oldpage = rtl8211e_select_ext_page(phydev, page);
> +	if (oldpage < 0)
> +		goto out;
> +
> +	ret = __phy_read(phydev, regnum);
> +	if (ret < 0)
> +		goto out;
> +
> +	new = (ret & ~mask) | set;
> +	if (new != ret)
> +		ret = __phy_write(phydev, regnum, new);
> +
> +out:
> +	return phy_restore_page(phydev, oldpage, ret);
> +}
> +
>  static int rtl8211e_disable_eee_led_mode(struct phy_device *phydev)
>  {
>  	int ret = 0;
> @@ -87,6 +128,7 @@ static int rtl8211e_config_init(struct phy_device *phydev)
>  
>  	return 0;
>  }
> +
>  static int rtl8201_ack_interrupt(struct phy_device *phydev)
>  {
>  	int err;
> 

