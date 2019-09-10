Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 013E0AEF53
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436694AbfIJQOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:14:55 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45697 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436678AbfIJQOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 12:14:55 -0400
Received: by mail-qt1-f195.google.com with SMTP id r15so21368480qtn.12
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 09:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=/I0eJuB7Mn2faP8y12sx8Za0Hqcp2SsWTD2uzQobJqg=;
        b=O2kmuvF5cYF497Guoq/6fE6lPopmNf2qzXkm/Kc2cxHRYevcfQkCVHq1fr5iVkStRn
         Yf875GsgevBDcizWfJylwlb8b2570lwlzOKhv7LqpwXmjaF89NfaO3CZTA5tOJj9CmJY
         8UtQQkmNqSWX/xwxPdAGtdnsfabb5reGHMTmb7noYPze4nscUYXcml010XqlsoazwR10
         t7AhNss4i0IgzdXzFvXhU/4NtYJsUq19ZM1O6Bkig3nywVYXVh+7uRjeBXu2yuX/Q0kF
         0tBnZCWUWJq6QMZsz5G/okGiMe9046EsgnLABDX93T1X8A1U1eG6V0XwEPdtg4E1i5hI
         Jk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=/I0eJuB7Mn2faP8y12sx8Za0Hqcp2SsWTD2uzQobJqg=;
        b=kQt0urhhnwfZ5BIRYqcwkiMALG/J2UEfu4vDkokZDg1wV5rqWVsfkZjPpVKnoN8149
         gjZ2dkfTr6CN/b5o+sTBPvhxYF8HlWdaM/gbOu/KngNVP1lmY2MVF8Kw6dNR0WQuSAWm
         S4U69o8rZcpC0+3FXgU46Q/TBbaza7rvNoim5AYWWu9l5iCGuTxuHCKeUxAcm2BLUO14
         Ezqx5n9XXhfQzvaTQJ1sfrxlYbU79/qydkOFbsHGRc5BH+1BW0tHVMDQ+1E664i5enWZ
         s8alECx5X+eson/g7Zd3bBEoiQcQ9mx3wbGFXJDDk4FNQIv6kZyTu1tNVF8IhKR1Ykzi
         szAg==
X-Gm-Message-State: APjAAAXnYHdYkn5dqz1nCAERAcodE7cd6bPM+YTM1UB+XSfj4MjzGvVN
        eC4o8y6UaoGvbNzpfxIjBHveV0BU
X-Google-Smtp-Source: APXvYqw3PC/Fa+jCrM2U4fislKxwQztDQ6D5lXPCpQfWH8YWWO6UwXQDkRUUYuzIjKrgfgAo87h2zw==
X-Received: by 2002:aed:3e41:: with SMTP id m1mr30000471qtf.273.1568132094186;
        Tue, 10 Sep 2019 09:14:54 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f14sm922057qtq.54.2019.09.10.09.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 09:14:53 -0700 (PDT)
Date:   Tue, 10 Sep 2019 12:14:52 -0400
Message-ID: <20190910121452.GB32337@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Robert Beckett <bob.beckett@collabora.com>
Cc:     netdev@vger.kernel.org, Robert Beckett <bob.beckett@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/7] net/dsa: configure autoneg for CPU port
In-Reply-To: <20190910154238.9155-2-bob.beckett@collabora.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <20190910154238.9155-2-bob.beckett@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert,

On Tue, 10 Sep 2019 16:41:47 +0100, Robert Beckett <bob.beckett@collabora.com> wrote:
> Configure autoneg for phy connected CPU ports.
> This allows us to use autoneg between the CPU port's phy and the link
> partner's phy.
> This enables us to negoatiate pause frame transmission to prioritise
> packet delivery over throughput.
> 
> Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
> ---
>  net/dsa/port.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index f071acf2842b..1b6832eac2c5 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -538,10 +538,20 @@ static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
>  		return PTR_ERR(phydev);
>  
>  	if (enable) {
> +		phydev->supported = PHY_GBIT_FEATURES | SUPPORTED_MII |
> +				    SUPPORTED_AUI | SUPPORTED_FIBRE |
> +				    SUPPORTED_BNC | SUPPORTED_Pause |
> +				    SUPPORTED_Asym_Pause;
> +		phydev->advertising = phydev->supported;
> +

This seems a bit intruisive to me. I'll get back to you.

>  		err = genphy_config_init(phydev);
>  		if (err < 0)
>  			goto err_put_dev;
>  
> +		err = genphy_config_aneg(phydev);
> +		if (err < 0)
> +			goto err_put_dev;
> +
>  		err = genphy_resume(phydev);
>  		if (err < 0)
>  			goto err_put_dev;
