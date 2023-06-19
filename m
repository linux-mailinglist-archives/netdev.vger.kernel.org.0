Return-Path: <netdev+bounces-12018-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF3F9735B02
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:21:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88A731C2042D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:21:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4289612B72;
	Mon, 19 Jun 2023 15:21:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E34512B64
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 15:21:13 +0000 (UTC)
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C229B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:21:12 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id 6a1803df08f44-6300465243eso20291016d6.2
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687188071; x=1689780071;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FKgU0gQ2vfsCth9MCG3sOyQvVg+m+oIbq3+v3m2hoCI=;
        b=fxOl1LoI3CC7WAPAZ2mTxKb16rSSGaiX1Ly1Kbgc0RmFyzq+j6ulnDC6zQUpkXM1gV
         nDvilXCGQCyeTqFVXvUdXWc+VUSgfxXmA650hk+IYfpTI6TjinoT3siI4hcF+T6xNT8s
         3BWqwg0CzamZ0RlvTQ2sq2FwbPrhs4D5AftPLGSG/3NoN7cqHQY5U50yNJh9M71Z0XKN
         qUULyuh8bO2FI0unUef71EW+7SHXHXD2HLxVv96l+LS8Tunc1MKKWc8XHr0PE9QWD2OQ
         olVsamoBJ6BxMgPCtoYV8FIPIJE9LMOAL77lZ4B4cjeCXv0gJFvg1Ow9bScYQCIK2Oc0
         GMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687188071; x=1689780071;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FKgU0gQ2vfsCth9MCG3sOyQvVg+m+oIbq3+v3m2hoCI=;
        b=gXD3L3Ix/NaFpiK57A0LWrYgGrW/Hcq4SHrLxue4KznOyDLwYz6HkF+JNVEMJDOazn
         eNsoDk2QzSq0Z5JEmKJq1hGzclxQ7d1GjSYSLrSevJcF5wQYhKSLSgBJhv7b5t4/ujEM
         isOI6UonnVbnAYRFSq7TL3rDiQKCzGuK/h7u6olhMm4DLqas+w2Ycz/4F4cy4aMhLxQx
         Loo4MSWL1UGx8GZmWaUqmnZxj+1PtV98PPKMImmOIAamQBwYfKmIK3RxQ8jhm1QylQLv
         pFievDZjIlLe97f4YWPUIAkwCuhvQZNuqXJ4nJ5Jaar6Wzbv2L8CqlX1ON6G7tTFjDpw
         n2pg==
X-Gm-Message-State: AC+VfDwhv6vXgrahmzuT38irwVbNpdb9bRhY0PagmrsI8UXni0gg/A1Q
	I4vHd0toqfKPt3me1KJGCZU=
X-Google-Smtp-Source: ACHHUZ7w5eRtjC3UuXci6NC8paNaHYyizHUfksUa2RIe5BKECVNG63jiVTJWlEkfH2jE9qoxuWumNw==
X-Received: by 2002:ad4:576f:0:b0:631:6eea:c4f0 with SMTP id r15-20020ad4576f000000b006316eeac4f0mr2415079qvx.48.1687188071583;
        Mon, 19 Jun 2023 08:21:11 -0700 (PDT)
Received: from [10.178.67.29] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id mm9-20020a0562145e8900b006311528fc5csm21018qvb.143.2023.06.19.08.21.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 08:21:11 -0700 (PDT)
Message-ID: <6951e7fa-a922-c498-9bb9-eaae5f47faaf@gmail.com>
Date: Mon, 19 Jun 2023 16:21:09 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v4 net-next 7/9] net: phy: Add phy_support_eee()
 indicating MAC support EEE
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
 Heiner Kallweit <hkallweit1@gmail.com>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230618184119.4017149-1-andrew@lunn.ch>
 <20230618184119.4017149-8-andrew@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230618184119.4017149-8-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/18/2023 7:41 PM, Andrew Lunn wrote:
> In order for EEE to operate, both the MAC and the PHY need to support
> it, similar to how pause works. Copy the pause concept and add the
> call phy_support_eee() which the MAC makes after connecting the PHY to
> indicate it supports EEE. phylib will then advertise EEE when auto-neg
> is performed.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>   drivers/net/phy/phy_device.c | 18 ++++++++++++++++++
>   include/linux/phy.h          |  3 ++-
>   2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 2cad9cc3f6b8..ae2ebe1df15c 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -2762,6 +2762,24 @@ void phy_advertise_supported(struct phy_device *phydev)
>   }
>   EXPORT_SYMBOL(phy_advertise_supported);
>   
> +/**
> + * phy_support_eee - Enable support of EEE
> + * @phydev: target phy_device struct
> + *
> + * Description: Called by the MAC to indicate is supports Energy

typo: is/it

> + * Efficient Ethernet. This should be called before phy_start() in
> + * order that EEE is negotiated when the link comes up as part of
> + * phy_start(). EEE is enabled by default when the hardware supports
> + * it.
> + */
> +void phy_support_eee(struct phy_device *phydev)
> +{
> +	linkmode_copy(phydev->advertising_eee, phydev->supported_eee);
> +	phydev->eee_cfg.tx_lpi_enabled = true;
> +	phydev->eee_cfg.eee_enabled = true;
> +}
> +EXPORT_SYMBOL(phy_support_eee);

A bit worried that naming this function might be confusing driver 
authors that this is a function that reports whether EEE is supported, 
though I am not able to come up with better names.

> +
>   /**
>    * phy_support_sym_pause - Enable support of symmetrical pause
>    * @phydev: target phy_device struct
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 473ddf62bee9..29ae45d37011 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -693,7 +693,7 @@ struct phy_device {
>   	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
>   	/* used with phy_speed_down */
>   	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
> -	/* used for eee validation */
> +	/* used for eee validation and configuration*/

While at it, maybe capitalize to EEE?

>   	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported_eee);
>   	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising_eee);
>   	bool eee_enabled;
> @@ -1903,6 +1903,7 @@ void phy_remove_link_mode(struct phy_device *phydev, u32 link_mode);
>   void phy_advertise_supported(struct phy_device *phydev);
>   void phy_support_sym_pause(struct phy_device *phydev);
>   void phy_support_asym_pause(struct phy_device *phydev);
> +void phy_support_eee(struct phy_device *phydev);
>   void phy_set_sym_pause(struct phy_device *phydev, bool rx, bool tx,
>   		       bool autoneg);
>   void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx);

-- 
Florian

