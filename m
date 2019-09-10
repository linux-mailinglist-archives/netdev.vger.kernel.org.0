Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42823AF059
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 19:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394224AbfIJRSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 13:18:18 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37895 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394149AbfIJRSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 13:18:18 -0400
Received: by mail-qt1-f193.google.com with SMTP id b2so21661645qtq.5
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 10:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=OXl/JISqiYpreSccb/JSF0IDgm6sYnpETHmK8yPGNAk=;
        b=JCubPkXViZEq7RUm/L+9trKG6ZGxi7C6zN2aTFpUMUZI7L34xcari2zSJOcYmr36yR
         jrnMtguaSYOApPoyOguxoxtj7dUjrIDZwRuIQBuYeWC+dflX+NEEnbnfvUNHkX2GuPyS
         MyYyaSJCNTEVHolaljkkQ0AzXq1ZVv4F8oFVvQzxWGNNNzH3uCun4NVn/r12kcodOc29
         UiiwsbzJecV58SGigeUPP4Xx2UJMqohPili+PAFSwD6wGV5/P6AGlWKS5EfKZITf9AAd
         4ruDWKNUECZAOzJG+8NSiID7LtLuQIEF6OddRgYI+zqmMpGDOM+dghaABLLAcEjfOPls
         PLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=OXl/JISqiYpreSccb/JSF0IDgm6sYnpETHmK8yPGNAk=;
        b=EGw85gwsWDZB8JAjcHFFBexyMtDiiCqx8WGK9cxwZC/JtaBP7rr84blK0cMyv66pWJ
         0FAelrynbflZ9j9GWi2KW37Oz+MOwkl9lOvteQIjQTp+THWIl786Z9XxSnNX0Ef7W31A
         69eZmQ1U5lywjcFPDYf62NbIJ2E+V8hu/Xiw9KD/Yg2Hq650Fdy4gIwaQILSKirl1Wxg
         RFlIS10G7wGVjt0Mfl3JgkhmzF9S3Djm9LWthgWikIIHASJhCgamRnHeBhctolSeebHh
         cesQWO/WN7FVqlX8BrnUrPm4poQq0ld1AeiyvMhIYyd/xvGuT0G2VWP3PitP9SeTMYu5
         fo0A==
X-Gm-Message-State: APjAAAW7m+pizBbj4TD8Ex716Ud08S6CRKetvpyKgEZgr7VzmZUds2Iu
        TP5uBo1ejukSVbALs9IVonA=
X-Google-Smtp-Source: APXvYqw5vQEEFeHZ4lhzxCLXiRWtl1Nh1Himze+cezrp15tCkHKO4yzx0XWATuXRv7fEkpRkky62ZQ==
X-Received: by 2002:ac8:6b13:: with SMTP id w19mr29907747qts.14.1568135897319;
        Tue, 10 Sep 2019 10:18:17 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c26sm11195378qtk.93.2019.09.10.10.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 10:18:16 -0700 (PDT)
Date:   Tue, 10 Sep 2019 13:18:15 -0400
Message-ID: <20190910131815.GK32337@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Robert Beckett <bob.beckett@collabora.com>
Cc:     netdev@vger.kernel.org, Robert Beckett <bob.beckett@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4/7] net: dsa: mv88e6xxx: add ability to set queue
 scheduling
In-Reply-To: <20190910154238.9155-5-bob.beckett@collabora.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <20190910154238.9155-5-bob.beckett@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert,

On Tue, 10 Sep 2019 16:41:50 +0100, Robert Beckett <bob.beckett@collabora.com> wrote:
> Add code to set Schedule for any port that specifies "schedule" in their
> device tree node.
> This allows port prioritization in conjunction with port default queue
> priorities or packet priorities.
> 
> Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 25 +++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/chip.h |  1 +
>  drivers/net/dsa/mv88e6xxx/port.c | 21 +++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/port.h |  6 ++++++
>  4 files changed, 53 insertions(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 5005a35493e3..2bc22c59200c 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2103,6 +2103,23 @@ static int mv88e6xxx_set_port_defqpri(struct mv88e6xxx_chip *chip, int port)
>  	return chip->info->ops->port_set_defqpri(chip, port, (u16)pri);
>  }
>  
> +static int mv88e6xxx_set_port_sched(struct mv88e6xxx_chip *chip, int port)
> +{
> +	struct dsa_switch *ds = chip->ds;
> +	struct device_node *dn = ds->ports[port].dn;
> +	int err;
> +	u32 sched;
> +
> +	if (!dn || !chip->info->ops->port_set_sched)
> +		return 0;
> +
> +	err = of_property_read_u32(dn, "schedule", &sched);
> +	if (err < 0)
> +		return 0;
> +
> +	return chip->info->ops->port_set_sched(chip, port, (u16)sched);
> +}
> +
>  static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  {
>  	struct dsa_switch *ds = chip->ds;
> @@ -2218,6 +2235,10 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  	if (err)
>  		return err;
>  
> +	err = mv88e6xxx_set_port_sched(chip, port);
> +	if (err)
> +		return err;
> +
>  	if (chip->info->ops->port_pause_limit) {
>  		err = chip->info->ops->port_pause_limit(chip, port, 0, 0);
>  		if (err)
> @@ -3130,6 +3151,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
>  	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
>  	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
>  	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
> +	.port_set_sched = mv88e6xxx_port_set_sched,
>  	.port_pause_limit = mv88e6097_port_pause_limit,
>  	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
>  	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
> @@ -3214,6 +3236,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
>  	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
>  	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
>  	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
> +	.port_set_sched = mv88e6xxx_port_set_sched,
>  	.port_pause_limit = mv88e6097_port_pause_limit,
>  	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
>  	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
> @@ -3432,6 +3455,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
>  	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
>  	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
>  	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
> +	.port_set_sched = mv88e6xxx_port_set_sched,
>  	.port_pause_limit = mv88e6097_port_pause_limit,
>  	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
>  	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
> @@ -3776,6 +3800,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
>  	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
>  	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
>  	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
> +	.port_set_sched = mv88e6xxx_port_set_sched,
>  	.port_pause_limit = mv88e6097_port_pause_limit,
>  	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
>  	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 2d2c24f5a79d..ff3e35eceee0 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -386,6 +386,7 @@ struct mv88e6xxx_ops {
>  	int (*port_set_defqpri)(struct mv88e6xxx_chip *chip, int port, u16 pri);
>  
>  	int (*port_egress_rate_limiting)(struct mv88e6xxx_chip *chip, int port);
> +	int (*port_set_sched)(struct mv88e6xxx_chip *chip, int port, u16 sched);
>  	int (*port_pause_limit)(struct mv88e6xxx_chip *chip, int port, u8 in,
>  				u8 out);
>  	int (*port_disable_learn_limit)(struct mv88e6xxx_chip *chip, int port);
> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
> index 3a45fcd5cd9c..236732fc598d 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.c
> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> @@ -1180,6 +1180,27 @@ int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port)
>  				    0x0001);
>  }
>  
> +/* Offset 0x0A: Egress Rate Control 2 */
> +int mv88e6xxx_port_set_sched(struct mv88e6xxx_chip *chip, int port, u16 sched)
> +{
> +	u16 reg;
> +	int err;
> +
> +	if (sched > MV88E6XXX_PORT_SCHED_STRICT_ALL)
> +		return -EINVAL;
> +
> +	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2,
> +				  &reg);
> +	if (err)
> +		return err;
> +
> +	reg &= ~MV88E6XXX_PORT_SCHED_MASK;
> +	reg |= sched << MV88E6XXX_PORT_SCHED_SHIFT;
> +
> +	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2,
> +				    reg);
> +}
> +
>  /* Offset 0x0C: Port ATU Control */
>  
>  int mv88e6xxx_port_disable_learn_limit(struct mv88e6xxx_chip *chip, int port)
> diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
> index 03884bbaa762..710d6eccafae 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.h
> +++ b/drivers/net/dsa/mv88e6xxx/port.h
> @@ -11,6 +11,7 @@
>  #ifndef _MV88E6XXX_PORT_H
>  #define _MV88E6XXX_PORT_H
>  
> +#include <dt-bindings/net/dsa-mv88e6xxx.h>
>  #include "chip.h"
>  
>  /* Offset 0x00: Port Status Register */
> @@ -207,6 +208,10 @@
>  
>  /* Offset 0x0A: Egress Rate Control 2 */
>  #define MV88E6XXX_PORT_EGRESS_RATE_CTL2		0x0a
> +#define MV88E6XXX_PORT_SCHED_SHIFT		12
> +#define MV88E6XXX_PORT_SCHED_MASK \
> +	(0x3 << MV88E6XXX_PORT_SCHED_SHIFT)
> +/* see MV88E6XXX_PORT_SCHED_* in include/dt-bindings/net/dsa-mv88e6xxx.h */
>  
>  /* Offset 0x0B: Port Association Vector */
>  #define MV88E6XXX_PORT_ASSOC_VECTOR			0x0b
> @@ -332,6 +337,7 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
>  int mv88e6xxx_port_set_defqpri(struct mv88e6xxx_chip *chip, int port, u16 pri);
>  int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
>  int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
> +int mv88e6xxx_port_set_sched(struct mv88e6xxx_chip *chip, int port, u16 sched);
>  int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
>  			       u8 out);
>  int mv88e6390_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,

Same comments applied as for the other patches adding implementations in port.c.


Thanks,

	Vivien
