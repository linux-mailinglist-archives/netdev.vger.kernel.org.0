Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FB1F0DD4
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 05:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731045AbfKFEco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 23:32:44 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33221 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfKFEco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 23:32:44 -0500
Received: by mail-qt1-f196.google.com with SMTP id y39so32392381qty.0
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 20:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=MykWLUcBqv3QVQT2l0guhK2PoNdDsTn3qb53P4O5a3U=;
        b=DYvW9C/GS/WQ2x//OUhRFL9yvTDRbGxpuLi4b0TI4J0VuT4MGlIQ6y41vXlAnFYSUQ
         1zLSDjMfWGncQ8jI0Qcyb1sLWqEqCRWQNt1iPzWO/7/Ah0J22KAjfx1i0rNxIc8czh5t
         hIw70RBI1a0+HvQjeKYyiFQ3lNHOvJhEzxWwp7DQLCy+qu4rPC+3z4oZj55VKna4Pebj
         EfuXUk4B4dpdY46c1bOIsqeFTQIsJNlRYt03pWB4B/Qnr3LlIKgRxs0S30/++FCeODm5
         I7W8kTDzltQ4RZIqIBbotigdX0ZUop3Owi9mYHfxELOhsDlCiFBW/XhKNn+4N9woRoAi
         rD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=MykWLUcBqv3QVQT2l0guhK2PoNdDsTn3qb53P4O5a3U=;
        b=cZBm9aDc07y689y6Saedb3sSbCPPiwusDQPu6Le3on20PFtZi4oVygAzb0URnFo1H5
         di4WIshj/+jM5c39vVi2NVwCp7Q9qiR1KH96oeCVgbFYP/Aog8YS8CEiHFSrLLbJSVHm
         Gagle8vEZ250hzxr13oBgCKtYd8/x5cHDznijIpM7xq7e9OVVfQ7x3P6LmhTHcyiF5Ev
         cebjUU8zR4azVAykvIk8FrEnMnTugzwMkyeRa+j6a580QUsq9RyKrVhEbO7MrJlqNTjx
         LZKAROXfw2iUblQjVXbbHv6hJ5+GGzX5rz09yDpJUTFVbCaNakFi4+1EHgduDIe0ZyPU
         hTSg==
X-Gm-Message-State: APjAAAUnsKSp+6H3OiUNwF53uoI9o/VSKkHopJXTF3hd0Fjo2LkK/OMt
        NCPcWZSbh0dUqAYeX0v2G0c=
X-Google-Smtp-Source: APXvYqwH487vmXTOdvf9m2qLlwZ/SGvv4MfXElhmUbhX1jB47AiGFMTI4CkPkGb5qI7zQXcYFuCKHA==
X-Received: by 2002:ac8:342b:: with SMTP id u40mr623044qtb.87.1573014762963;
        Tue, 05 Nov 2019 20:32:42 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id z70sm12075905qkb.60.2019.11.05.20.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 20:32:41 -0800 (PST)
Date:   Tue, 5 Nov 2019 23:32:41 -0500
Message-ID: <20191105233241.GB799546@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, jiri@mellanox.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 3/5] net: dsa: mv88e6xxx: global2: Expose ATU
 stats register
In-Reply-To: <20191105001301.27966-4-andrew@lunn.ch>
References: <20191105001301.27966-1-andrew@lunn.ch>
 <20191105001301.27966-4-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Nov 2019 01:12:59 +0100, Andrew Lunn <andrew@lunn.ch> wrote:
> Add helpers to set/get the ATU statistics register.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/dsa/mv88e6xxx/global2.c | 20 ++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/global2.h | 24 +++++++++++++++++++++++-
>  2 files changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
> index bdbb72fc20ed..14954d92c564 100644
> --- a/drivers/net/dsa/mv88e6xxx/global2.c
> +++ b/drivers/net/dsa/mv88e6xxx/global2.c
> @@ -280,6 +280,26 @@ int mv88e6xxx_g2_set_switch_mac(struct mv88e6xxx_chip *chip, u8 *addr)
>  	return err;
>  }
>  
> +/* Offset 0x0E: ATU Statistics */
> +
> +int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip, u16 kind, u16 bin)
> +{
> +	return mv88e6xxx_g2_write(chip, MV88E6XXX_G2_ATU_STATS,
> +				  kind | bin);
> +}
> +
> +int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip)
> +{
> +	int err;
> +	u16 val;
> +
> +	err = mv88e6xxx_g2_read(chip, MV88E6XXX_G2_ATU_STATS, &val);
> +	if (err)
> +		return err;
> +
> +	return val & MV88E6XXX_G2_ATU_STATS_MASK;
> +}

I would use the logic commonly used in the mv88e6xxx driver for
functions that may fail, returning only an error code and taking a
pointer to the correct type as argument, so that we do as usual:

    err = mv88e6xxx_g2_atu_stats_get(chip, &val);
    if (err)
        return err;

> +
>  /* Offset 0x0F: Priority Override Table */
>  
>  static int mv88e6xxx_g2_pot_write(struct mv88e6xxx_chip *chip, int pointer,
> diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
> index 42da4bca73e8..a308ca7a7da6 100644
> --- a/drivers/net/dsa/mv88e6xxx/global2.h
> +++ b/drivers/net/dsa/mv88e6xxx/global2.h
> @@ -113,7 +113,16 @@
>  #define MV88E6XXX_G2_SWITCH_MAC_DATA_MASK	0x00ff
>  
>  /* Offset 0x0E: ATU Stats Register */
> -#define MV88E6XXX_G2_ATU_STATS		0x0e
> +#define MV88E6XXX_G2_ATU_STATS				0x0e
> +#define MV88E6XXX_G2_ATU_STATS_BIN_0			(0x0 << 14)
> +#define MV88E6XXX_G2_ATU_STATS_BIN_1			(0x1 << 14)
> +#define MV88E6XXX_G2_ATU_STATS_BIN_2			(0x2 << 14)
> +#define MV88E6XXX_G2_ATU_STATS_BIN_3			(0x3 << 14)
> +#define MV88E6XXX_G2_ATU_STATS_MODE_ALL			(0x0 << 12)
> +#define MV88E6XXX_G2_ATU_STATS_MODE_ALL_DYNAMIC		(0x1 << 12)
> +#define MV88E6XXX_G2_ATU_STATS_MODE_FID_ALL		(0x2 << 12)
> +#define MV88E6XXX_G2_ATU_STATS_MODE_FID_ALL_DYNAMIC	(0x3 << 12)
> +#define MV88E6XXX_G2_ATU_STATS_MASK			0x0fff

Please use the 0x1234 format for these 16-bit registers.

>  
>  /* Offset 0x0F: Priority Override Table */
>  #define MV88E6XXX_G2_PRIO_OVERRIDE		0x0f
> @@ -353,6 +362,8 @@ extern const struct mv88e6xxx_gpio_ops mv88e6352_gpio_ops;
>  
>  int mv88e6xxx_g2_scratch_gpio_set_smi(struct mv88e6xxx_chip *chip,
>  				      bool external);
> +int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip, u16 kind, u16 bin);
> +int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip);
>  
>  #else /* !CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 */
>  
> @@ -515,6 +526,17 @@ static inline int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip,
>  	return -EOPNOTSUPP;
>  }
>  
> +static inline int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip,
> +					     u16 kind, u16 bin)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  #endif /* CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 */
>  
>  #endif /* _MV88E6XXX_GLOBAL2_H */
> -- 
> 2.23.0
> 

Otherwise this looks good.


Thanks,

	Vivien
