Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145DA22B881
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgGWVSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbgGWVSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 17:18:52 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2646BC0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 14:18:52 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f18so6463986wml.3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 14:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pxKsPUQTHAT6oTogti6gb/4uxYGRikFrC1YiMgLzuxA=;
        b=g6f4zR1wemh+vXoYo9ALzJQ7GTzbevmYdvoLYZjRq9Vq27FbT4trEafPWJr3b0w4gA
         AWnX6QQqZOJnDc5P1i3GrMDXRaIHwtw2yKZz65BUWxd4T2kYmGL05/UqPteHghlbDRVj
         7o5iexwSNPSIUPg0wcuj0xV2cK2GY8E21xPVMAYpD/wB58BSNCRYYRjUy9Qmj6mpJnCd
         5WlXY9x28NTmjVXhjWVdJ+kZuIRvsGL5RT5C0ybTtn7HkYBj1pZrBczQGNBvJY57bo3n
         sQVtl3hwt/hD0EgXIx0Yby/0rmrZyRdBhgEXNe85ZJ6SFxBdptvkC/NO1jGdEFsOSwMQ
         EZ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pxKsPUQTHAT6oTogti6gb/4uxYGRikFrC1YiMgLzuxA=;
        b=L4+S2KCQKguAXsvo+60T2jbpZs3s6BpZZBp5iNL+v94AHp7BLSKn68s7wbwet93vaw
         IkzkArVbESulPTRByvvI4u00+b4tgxNMhP6rITXH9kuW+odYWAyaKibNxMVkW8HGq4GG
         BbXUj+VJsIj9I4AYqpKWeOJb3Ntyv+enUtnHpV8OEMP9eCrZ1wEcgrcW1hq7tU5rtk42
         m63wgpgHhqXS5JPeJv0TWbcJU54Ad8sUMy09xSoQqFr531C/EN1SvH+qWuXSy8UzHH6b
         5Hz5UpnCMzXk1yS8+Aj1sQmW4ORAaYOlGCvTYVfoe3cSnXrrMRGOXVcDFiyluUW0EUBV
         gkAQ==
X-Gm-Message-State: AOAM532rrIY3ij9xs7KePA+wC74IwBGJhXqYVhrQTtp8wTSt156i1ViA
        wtu3nqInWXHdFsLzB1cSB3A=
X-Google-Smtp-Source: ABdhPJxEjd4prGU1EgCKhLSL3NInunh/deTvCS3RtcSMBE2Kxj9UvEZHxm5W/5e7tDY1gJ5HijgfHQ==
X-Received: by 2002:a7b:c090:: with SMTP id r16mr5332947wmh.143.1595539130841;
        Thu, 23 Jul 2020 14:18:50 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y11sm5474174wrs.80.2020.07.23.14.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 14:18:50 -0700 (PDT)
Subject: Re: [PATCH net-next] mscc: Add LCPLL Reset to VSC8574 Family of phy
 drivers
To:     Bryan Whitehead <Bryan.Whitehead@microchip.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
References: <1595534997-29187-1-git-send-email-Bryan.Whitehead@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <c8791db0-b036-51c0-c714-676357fd8be1@gmail.com>
Date:   Thu, 23 Jul 2020 14:18:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595534997-29187-1-git-send-email-Bryan.Whitehead@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/20 1:09 PM, Bryan Whitehead wrote:
> The LCPLL Reset sequence is added to the initialization path
> of the VSC8574 Family of phy drivers.
> 
> The LCPLL Reset sequence is known to reduce hardware inter-op
> issues when using the QSGMII MAC interface.
> 
> This patch is submitted to net-next to avoid merging conflicts that
> may arise if submitted to net.
> 
> Signed-off-by: Bryan Whitehead <Bryan.Whitehead@microchip.com>

Can you copy the PHY library maintainers for future changes such that
this does not escape their review?

> ---
>  drivers/net/phy/mscc/mscc_main.c | 90 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 90 insertions(+)
> 
> diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
> index a4fbf3a..f2fa221 100644
> --- a/drivers/net/phy/mscc/mscc_main.c
> +++ b/drivers/net/phy/mscc/mscc_main.c
> @@ -929,6 +929,90 @@ static bool vsc8574_is_serdes_init(struct phy_device *phydev)
>  }
>  
>  /* bus->mdio_lock should be locked when using this function */
> +/* Page should already be set to MSCC_PHY_PAGE_EXTENDED_GPIO */
> +static int vsc8574_wait_for_micro_complete(struct phy_device *phydev)
> +{
> +	u16 timeout = 500;
> +	u16 reg18g = 0;
> +
> +	reg18g = phy_base_read(phydev, 18);
> +	while (reg18g & 0x8000) {
> +		timeout--;
> +		if (timeout == 0)
> +			return -1;
> +		usleep_range(1000, 2000);
> +		reg18g = phy_base_read(phydev, 18);

Please consider using phy_read_poll_timeout() instead of open coding
this busy waiting loop.

> +	}
> +
> +	return 0;
> +}
> +
> +/* bus->mdio_lock should be locked when using this function */
> +static int vsc8574_reset_lcpll(struct phy_device *phydev)
> +{
> +	u16 reg_val = 0;
> +	int ret = 0;
> +
> +	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
> +		       MSCC_PHY_PAGE_EXTENDED_GPIO);
> +
> +	/* Read LCPLL config vector into PRAM */
> +	phy_base_write(phydev, 18, 0x8023);
> +	ret = vsc8574_wait_for_micro_complete(phydev);
> +	if (ret)
> +		goto done;

It might make sense to write a helper function that encapsulates the:

- phy_base_write()
- wait_for_complete

pattern and use it throughout, with an option delay range argument so
you can put that in there, too.
-- 
Florian
