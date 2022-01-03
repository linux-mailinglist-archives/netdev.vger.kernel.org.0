Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C32483761
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 20:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbiACTII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 14:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235986AbiACTIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 14:08:07 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28B5C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 11:08:06 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id o6so139469229edc.4
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 11:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/TOiFxQdAkl1HaMEcAOn28GeC9Rj02YDnxMMcUq+zuQ=;
        b=ibL3Eorodp3H8PbZdhHHtf15Dcdd/EygEskmkox9HAW9Y8P1bKAb3xKWS6TYxUu7PI
         nP4Ck97ApQC6icOGXYVfbZQi28aYGno1ULP0h9Hg1yUMrpL/emT64sMX2MFZ20EUqqG/
         wSB0wMbJndCsEftbptD81RAt86ihZaakjhLwiT9vCE6uIlI7SAmtZX04CB043tt8H4sN
         LixCPplFy98dLkO68vO2WMOnr+lK4sZelOvJp7oC3JmhUFHsZIO1pVHR7Mi4IjKR5887
         fgQElFENI7DVMZEt1MCO/cGlYmuidFQkh2awLtE+71+iQzjxzNJWZF5bJtEzIFEdeGqk
         I0lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/TOiFxQdAkl1HaMEcAOn28GeC9Rj02YDnxMMcUq+zuQ=;
        b=FMZxWVwKOwTbhIjE56tH/vhzen6B3VjNfhUOMS1eSQX7lG59mJr3Cj3kuy7JD/vSFK
         +pVmP76399zFpyB3J/GNzBjQf00MczBW7MQI91Nl39vc55mg+O1/vwWk12sfO2+hzj5y
         6QyoeHYoBJ6qW+o67PNPImL7Q3auHncV9VzUqrlDqIJTfxPhTsYRSJaS/Y6S3BhFJWw9
         i7sYbNLe3lLs0kjvS9mTh2bCq10wjsXiUlnFwauBLaFGR86VXYbBDEMW+dbla1FODBg4
         IqkGNl6rDUpUYIChCfQx2uUW228pTiV5WbORH0xJHX2QIEyZURdrZyeRdxS3BJ2QR5+v
         1hkg==
X-Gm-Message-State: AOAM532/YQRngD/VjirAL6JpNeVndiGuRvd6xwOtnfThNJ1P83M1QWsZ
        Tmt7/P8mc/C2pRRYDJUOy08=
X-Google-Smtp-Source: ABdhPJzANzcquCnoWqosvD53r9zFOfMak/9v+AMuPQZe3GdMujeX438fBBpzovYhdKAIdWgsH/pfcQ==
X-Received: by 2002:a17:907:62a3:: with SMTP id nd35mr38333571ejc.650.1641236885440;
        Mon, 03 Jan 2022 11:08:05 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id n25sm13799168eds.9.2022.01.03.11.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 11:08:05 -0800 (PST)
Date:   Mon, 3 Jan 2022 21:08:03 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
Subject: Re: [PATCH net-next v3 09/11] net: dsa: realtek: rtl8365mb: use DSA
 CPU port
Message-ID: <20220103190803.pjqcoekzjwvqerp5@skbuf>
References: <20211231043306.12322-1-luizluca@gmail.com>
 <20211231043306.12322-10-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211231043306.12322-10-luizluca@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 31, 2021 at 01:33:04AM -0300, Luiz Angelo Daros de Luca wrote:
> Instead of a fixed CPU port, assume that DSA is correct.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  drivers/net/dsa/realtek/rtl8365mb.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
> index b22f50a9d1ef..168e857a4e34 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -103,14 +103,13 @@
>  
>  /* Chip-specific data and limits */
>  #define RTL8365MB_CHIP_ID_8365MB_VC		0x6367
> -#define RTL8365MB_CPU_PORT_NUM_8365MB_VC	6
>  #define RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC	2112
>  
>  /* Family-specific data and limits */
>  #define RTL8365MB_PHYADDRMAX	7
>  #define RTL8365MB_NUM_PHYREGS	32
>  #define RTL8365MB_PHYREGMAX	(RTL8365MB_NUM_PHYREGS - 1)
> -#define RTL8365MB_MAX_NUM_PORTS	(RTL8365MB_CPU_PORT_NUM_8365MB_VC + 1)
> +#define RTL8365MB_MAX_NUM_PORTS  7
>  
>  /* Chip identification registers */
>  #define RTL8365MB_CHIP_ID_REG		0x1300
> @@ -1833,9 +1832,18 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
>  		dev_info(priv->dev, "no interrupt support\n");
>  
>  	/* Configure CPU tagging */
> -	ret = rtl8365mb_cpu_config(priv);
> -	if (ret)
> -		goto out_teardown_irq;
> +	for (i = 0; i < priv->num_ports; i++) {
> +		if (!(dsa_is_cpu_port(priv->ds, i)))
> +			continue;

dsa_switch_for_each_cpu_port

> +		priv->cpu_port = i;
> +		mb->cpu.mask = BIT(priv->cpu_port);
> +		mb->cpu.trap_port = priv->cpu_port;
> +		ret = rtl8365mb_cpu_config(priv);
> +		if (ret)
> +			goto out_teardown_irq;
> +
> +		break;
> +	}
>  
>  	/* Configure ports */
>  	for (i = 0; i < priv->num_ports; i++) {
> @@ -1967,8 +1975,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
>  			 "found an RTL8365MB-VC switch (ver=0x%04x)\n",
>  			 chip_ver);
>  
> -		priv->cpu_port = RTL8365MB_CPU_PORT_NUM_8365MB_VC;
> -		priv->num_ports = priv->cpu_port + 1;
> +		priv->num_ports = RTL8365MB_MAX_NUM_PORTS;
>  
>  		mb->priv = priv;
>  		mb->chip_id = chip_id;
> @@ -1979,8 +1986,6 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
>  		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
>  
>  		mb->cpu.enable = 1;
> -		mb->cpu.mask = BIT(priv->cpu_port);
> -		mb->cpu.trap_port = priv->cpu_port;
>  		mb->cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
>  		mb->cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
>  		mb->cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
> -- 
> 2.34.0
> 
