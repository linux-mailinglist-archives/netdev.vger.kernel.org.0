Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF3BAEFD5
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436881AbfIJQoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:44:01 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38260 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436785AbfIJQoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 12:44:01 -0400
Received: by mail-qt1-f195.google.com with SMTP id b2so21524535qtq.5
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 09:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=lHrlTJdD2GHq+As+8IS8ZIiSa9F5PM62aIvcJzk3Y0o=;
        b=ov6TEGQLgTbUOpRDABMt+Bll95/ylHoNz7khLwPR88jhMwzBCFqx2U46nqkGaTfZxm
         12tSOUpO9VpzkJJ/w2uik9xvvEmcLcaSXCUsAK3MYkT3HipMVLDZ4Zi+ICcOh4wCzhDb
         BMniSxjzZUNs1uz4Nt5Tlr5roFy6Yd/5dVtx5P1R/XpTZT6gInC8JY0Y3aWXnsx8zZm2
         fyjlePs1/x9dHX2D/xcrMEtPL6hKcztRac8DY/A6EwFFyUyI17ilx2hp9++nxnKRCgM9
         r3/gQ8SRW7LUF3qmBZnDqDOo2/0ZZquWQ6lBUpN3voxr1AXmOOdGhD4ZY3AypSfBEEwC
         yRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=lHrlTJdD2GHq+As+8IS8ZIiSa9F5PM62aIvcJzk3Y0o=;
        b=NTBb6r7r6PD+6IEhLtXWNBB97vyLsuJwC2iM+AiNybJFgqJVIZiMQUX2H4hLIO0wgd
         PKMxK9iXi+nfxox9C5ZenG4qbBfzaWqUK/7t2zOzZ7Iw6au0yQ58l4vqnU4n7uqtRw60
         h4+hYUnM0hK+H5hNqBrkyKdzwItg5NTWTxLM7UKBHqSi83hC/+1+4A4aVYODcYduajNt
         OPwcGMVSiWnjmcuWxDAcpgZt9hXBGhtH2jhjxyzHlDWecm3pOwS4j5+LtED/EIp6Kf4H
         XZEBbiTzH9N5Ypp/g5n5lZHJrvgfjhaM+z3Vswlq8HIIs21fHrWqHaD5/YyizOQ3Z57j
         gWXg==
X-Gm-Message-State: APjAAAUzKk+vvBT1n5HZujjFHlEOUVX9TlxoCkRBeBZ+odW/3ko5CiUJ
        I7+GdPKHmHihyzXDnJPO/RE=
X-Google-Smtp-Source: APXvYqyZEUH0XQvHEIjbV9yGJLq+AE6prfkvc7bNT8o6v45Qv/+eHUKqMTi5FNL/IfW016smZsZCrQ==
X-Received: by 2002:ac8:7246:: with SMTP id l6mr30615221qtp.359.1568133839946;
        Tue, 10 Sep 2019 09:43:59 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id n66sm8332236qkd.44.2019.09.10.09.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 09:43:59 -0700 (PDT)
Date:   Tue, 10 Sep 2019 12:43:58 -0400
Message-ID: <20190910124358.GE32337@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Robert Beckett <bob.beckett@collabora.com>
Cc:     netdev@vger.kernel.org, Robert Beckett <bob.beckett@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/7] net: dsa: mv88e6xxx: add ability to set default queue
 priorities per port
In-Reply-To: <20190910154238.9155-3-bob.beckett@collabora.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <20190910154238.9155-3-bob.beckett@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert,

On Tue, 10 Sep 2019 16:41:48 +0100, Robert Beckett <bob.beckett@collabora.com> wrote:
> +static int mv88e6xxx_set_port_defqpri(struct mv88e6xxx_chip *chip, int port)
> +{
> +	struct dsa_switch *ds = chip->ds;
> +	struct device_node *dn = ds->ports[port].dn;
> +	int err;
> +	u32 pri;
> +
> +	if (!dn || !chip->info->ops->port_set_defqpri)
> +		return 0;
> +
> +	err = of_property_read_u32(dn, "defqpri", &pri);
> +	if (err < 0)
> +		return 0;
> +
> +	return chip->info->ops->port_set_defqpri(chip, port, (u16)pri);
> +}
> +
>  static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  {
>  	struct dsa_switch *ds = chip->ds;
> @@ -2176,6 +2193,10 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  			return err;
>  	}
>  
> +	err = mv88e6xxx_set_port_defqpri(chip, port);
> +	if (err)
> +		return err;
> +
>  	/* Port Association Vector: when learning source addresses
>  	 * of packets, add the address to the address database using
>  	 * a port bitmap that has only the bit for this port set and
> @@ -3107,6 +3128,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
>  	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
>  	.port_set_ether_type = mv88e6351_port_set_ether_type,
>  	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
> +	.port_set_defqpri = mv88e6xxx_port_set_defqpri,

Please use a reference model, like mv88e6352_port_set_defqpri to avoid
confusion with a generic wrapper or implementation.

>  	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
>  	.port_pause_limit = mv88e6097_port_pause_limit,
>  	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
> @@ -3190,6 +3212,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
>  	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
>  	.port_set_ether_type = mv88e6351_port_set_ether_type,
>  	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
> +	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
>  	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
>  	.port_pause_limit = mv88e6097_port_pause_limit,
>  	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
> @@ -3407,6 +3430,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
>  	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
>  	.port_set_ether_type = mv88e6351_port_set_ether_type,
>  	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
> +	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
>  	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
>  	.port_pause_limit = mv88e6097_port_pause_limit,
>  	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
> @@ -3750,6 +3774,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
>  	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
>  	.port_set_ether_type = mv88e6351_port_set_ether_type,
>  	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
> +	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
>  	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
>  	.port_pause_limit = mv88e6097_port_pause_limit,
>  	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 4646e46d47f2..2d2c24f5a79d 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -383,6 +383,7 @@ struct mv88e6xxx_ops {
>  				   u16 etype);
>  	int (*port_set_jumbo_size)(struct mv88e6xxx_chip *chip, int port,
>  				   size_t size);
> +	int (*port_set_defqpri)(struct mv88e6xxx_chip *chip, int port, u16 pri);

The default queue priority seems to be an integer in the [0:3] range, not
a register mask or value per-se. So an unsigned int seems more appropriate.

>  
>  	int (*port_egress_rate_limiting)(struct mv88e6xxx_chip *chip, int port);
>  	int (*port_pause_limit)(struct mv88e6xxx_chip *chip, int port, u8 in,
> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
> index 04309ef0a1cc..3a45fcd5cd9c 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.c
> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> @@ -1147,6 +1147,25 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
>  	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
>  }
>  
> +int mv88e6xxx_port_set_defqpri(struct mv88e6xxx_chip *chip, int port, u16 pri)
> +{
> +	u16 reg;
> +	int err;
> +
> +	if (pri > 3)
> +		return -EINVAL;
> +
> +	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL2, &reg);
> +	if (err)
> +		return err;
> +
> +	reg &= ~MV88E6XXX_PORT_CTL2_DEFQPRI_MASK;
> +	reg |= pri << MV88E6XXX_PORT_CTL2_DEFQPRI_SHIFT;

                      __bf_shf(MV88E6XXX_PORT_CTL2_DEFQPRI_MASK)

> +	reg |= MV88E6XXX_PORT_CTL2_USE_DEFQPRI;
> +
> +	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
> +}
> +
>  /* Offset 0x09: Port Rate Control */
>  
>  int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port)
> diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
> index 8d5a6cd6fb19..03884bbaa762 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.h
> +++ b/drivers/net/dsa/mv88e6xxx/port.h
> @@ -197,6 +197,9 @@
>  #define MV88E6XXX_PORT_CTL2_DEFAULT_FORWARD		0x0040
>  #define MV88E6XXX_PORT_CTL2_EGRESS_MONITOR		0x0020
>  #define MV88E6XXX_PORT_CTL2_INGRESS_MONITOR		0x0010
> +#define MV88E6XXX_PORT_CTL2_USE_DEFQPRI		0x0008
> +#define MV88E6XXX_PORT_CTL2_DEFQPRI_MASK		0x0006
> +#define MV88E6XXX_PORT_CTL2_DEFQPRI_SHIFT		1

No shift macro needed, MV88E6XXX_PORT_CTL2_DEFQPRI_MASK is enough.

>  #define MV88E6095_PORT_CTL2_CPU_PORT_MASK		0x000f
>  
>  /* Offset 0x09: Egress Rate Control */
> @@ -326,6 +329,7 @@ int mv88e6xxx_port_set_message_port(struct mv88e6xxx_chip *chip, int port,
>  				    bool message_port);
>  int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
>  				  size_t size);
> +int mv88e6xxx_port_set_defqpri(struct mv88e6xxx_chip *chip, int port, u16 pri);
>  int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
>  int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
>  int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,

Thanks,

	Vivien
