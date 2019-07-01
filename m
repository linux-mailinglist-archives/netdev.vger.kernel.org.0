Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C935C48D
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfGAUt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:49:56 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51661 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfGAUty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:49:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so831189wma.1;
        Mon, 01 Jul 2019 13:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G2ozsz8yyViKWYfdB4NDhthbwOXBk4pYx/VsCelpvWE=;
        b=jmIxnHM7ZHUfWXWInLHYOklrS+UIIPAq9//w6qAnnaR8iKO5uboXIaKh25dHn4QCdz
         5BoU6hy3B6Uxwyqx7EMftclo9JSE5rw9XuruyPIj58LfzYWMFHAnUkZ8ZIpH8dEkPZIa
         twRcbxJrIMnB15zJHspp/VaGHfO1zrb11h98LTrwECU1GD8t26uqQmH5t6VhQxc2f8fj
         I8ssWT2Hdw752Dicz6PT5mBBBQdzcbVRYq1uPU0BJeAXuryYjfe5UsM6CuvlRByb1/Ma
         Ki7N6EzLo4nve+bx32RmcK05Uwk0o5LMf/MyGE/9Z5XE99X+FX3jXRyQkdbBwAiWuJLJ
         gD1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G2ozsz8yyViKWYfdB4NDhthbwOXBk4pYx/VsCelpvWE=;
        b=NR2nj7bVO2R0Gvk9kB90AZ3OMWb39SeCuGi/ao71zQPr9Ntgo+hsw+ZsjDXiz41q9k
         sPpJGY0tAsm0XatpKOfeozqNzQKkjEJEa/FVaOunVUim+nBUbzD0y0lSRtQmjG7geMZ4
         Az2qqAtbef9GuE/R0MK8dwTjFSNFpb9S3pet8SEce5vOISRbGpOdyKQ+3rbOmA6jR6sD
         LO0mdT6AMn9dbYZvA6gPY0m1odkcbZfl8n2HrgC7VBbLma/2MK/OiJvAPAiWo+slq3WD
         03khAvab5coAESNvB/bN+YQojuTGSw1U+TcpiniyuBwCtEPBhzrhxOJL5SwmVO2K3ys0
         t0CA==
X-Gm-Message-State: APjAAAW9kTR4Lh2JuB0pfHKZq90nA9lzBBAOzjaKDwBYXWNy6pnbjxnk
        fK1qlIktmyOuF1Ter5+ex6U=
X-Google-Smtp-Source: APXvYqzGd7kRO9VlCev3rUxiJU/HAnhEAi7O+d8K82CjMrYQWzw14tcz6EgQPXVvawTqw0MgE+2b5Q==
X-Received: by 2002:a1c:448b:: with SMTP id r133mr681423wma.114.1562014192656;
        Mon, 01 Jul 2019 13:49:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:8dac:9ad2:a34c:33bc? (p200300EA8BD60C008DAC9AD2A34C33BC.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:8dac:9ad2:a34c:33bc])
        by smtp.googlemail.com with ESMTPSA id w20sm25408931wra.96.2019.07.01.13.49.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 13:49:52 -0700 (PDT)
Subject: Re: [PATCH 2/3] net: phy: realtek: Enable accessing RTL8211E
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
References: <20190701195225.120808-1-mka@chromium.org>
 <20190701195225.120808-2-mka@chromium.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d2386f7d-b4bc-d983-1b83-cc2aa4aec38b@gmail.com>
Date:   Mon, 1 Jul 2019 22:43:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190701195225.120808-2-mka@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.07.2019 21:52, Matthias Kaehlcke wrote:
> The RTL8211E has extension pages, which can be accessed after
> selecting a page through a custom method. Add a function to
> modify bits in a register of an extension page and a few
> helpers for dealing with ext pages.
> 
> rtl8211e_modify_ext_paged() and rtl821e_restore_page() are
> inspired by their counterparts phy_modify_paged() and
> phy_restore_page().
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> This code might be applicable to other Realtek PHYs, but I don't
> have access to the datasheets to confirm it, so for now it's just
> for the RTL8211E.
> 
This extended page mechanism exists on a number of older Realtek
PHY's. For most extended pages however Realtek releases no public
documentation.
Considering that we use these helpers in one place only,  I don't
really see a need for them.

>  drivers/net/phy/realtek.c | 61 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index a669945eb829..dfc2e20ef335 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -26,6 +26,9 @@
>  #define RTL821x_EXT_PAGE_SELECT			0x1e
>  #define RTL821x_PAGE_SELECT			0x1f
>  
> +#define RTL8211E_EXT_PAGE			7
> +#define RTL8211E_EPAGSR				0x1e
> +
>  #define RTL8211F_INSR				0x1d
>  
>  #define RTL8211F_TX_DELAY			BIT(8)
> @@ -53,6 +56,64 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
>  	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
>  }
>  
> +static int rtl821e_select_ext_page(struct phy_device *phydev, int page)
> +{
> +	int rc;
> +
> +	rc = phy_write(phydev, RTL821x_PAGE_SELECT, RTL8211E_EXT_PAGE);
> +	if (rc)
> +		return rc;
> +
> +	return phy_write(phydev, RTL8211E_EPAGSR, page);
> +}
> +
> +static int rtl821e_restore_page(struct phy_device *phydev, int oldpage, int ret)
> +{
> +	int r;
> +
> +	if (oldpage >= 0) {
> +		r = phy_write(phydev, RTL821x_PAGE_SELECT, oldpage);
> +
> +		/* Propagate the operation return code if the page write
> +		 * was successful.
> +		 */
> +		if (ret >= 0 && r < 0)
> +			ret = r;
> +	} else {
> +		/* Propagate the page selection error code */
> +		ret = oldpage;
> +	}
> +
> +	return ret;
> +}
> +
> +static int __maybe_unused rtl8211e_modify_ext_paged(struct phy_device *phydev,
> +				    int page, u32 regnum, u16 mask, u16 set)
> +{
> +	int ret = 0;
> +	int oldpage;
> +	int new;
> +
> +	oldpage = phy_read(phydev, RTL821x_PAGE_SELECT);
> +	if (oldpage < 0)
> +		goto out;
> +
> +	ret = rtl821e_select_ext_page(phydev, page);
> +	if (ret)
> +		goto out;
> +
> +	ret = phy_read(phydev, regnum);
> +	if (ret < 0)
> +		goto out;
> +
> +	new = (ret & ~mask) | set;
> +	if (new != ret)
> +		ret = phy_write(phydev, regnum, new);
> +
> +out:
> +	return rtl821e_restore_page(phydev, oldpage, ret);
> +}
> +
>  static int rtl8201_ack_interrupt(struct phy_device *phydev)
>  {
>  	int err;
> 

