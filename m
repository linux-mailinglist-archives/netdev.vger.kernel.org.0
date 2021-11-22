Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351F44587DE
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhKVCAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 21:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhKVCAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 21:00:14 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31D5C061574;
        Sun, 21 Nov 2021 17:57:08 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z5so69943949edd.3;
        Sun, 21 Nov 2021 17:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=XRWgYILIHEe6eCpfKC5tDcLW7yleOY+njYLfaN5qjOc=;
        b=HZ8JzrD4C3yCZy6BLstzfiLuUalYWxWYlttKl6HaNF3SGhL1xAcG6qrgXEG4AzQOe+
         WkV/dboeUH8l5Z/HHJxbEAJk0Xbxc5bStSpFkMzCPJOPpSdtQQoGJ33qSsakzaTNExUP
         Av4GnxXs+WoAaPg6v/JUxB3k9QeEcOMCpYYSwZRCxahsbKVKojNAmpJLTG6UP6XanpbU
         +P+WBTknYCfbOtTx6iMeH+r6h7VthGXpDNO0uEgSvIalo9dAWi/tXHnzvAMnyL8mIRVI
         y6tsLzZf9L4MMT6TILP1vzrWUYc8PAAt6o9nYKQZg6asrN5nMZnXY1VqjqIXzOeRw43i
         GHiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=XRWgYILIHEe6eCpfKC5tDcLW7yleOY+njYLfaN5qjOc=;
        b=iSdSW5iENJ9c1/cI0a9WmC4XsH7K8KHZtbn1mkjR0zqotlYiYhpnY8zIG+EvtBNEM9
         lCQ6f8/8IX+P2frKmBr6Kpuun7ifxEIjvRUd5jOzDGd7ygND2OH/MhF2lM+8LIc7WXqW
         u/wWbc9WBAJ67HNEcrKz38StsoGrO1+bJz6+H+3boOYU2WDTHKXaX+TraMZiNC2kw8BO
         kwP+IwIMGq6oq+NbLpqtnyWPOmFBfqKbKsN2/hWb/XKXM0v23/hWr24oaIfjDBgkBLuh
         YkmGYgkiiSJqRGjLcASqSeuSBrYT/S+u06r7N0Ap6v9BfNCYu6/g8GHZRRQF65MgZsZA
         Lz/Q==
X-Gm-Message-State: AOAM532aYRRywX/GhUdQNx3556xP3qAluzeRgakD+Z2+hmTwwsnf8m/6
        poD6onF0voYSvEsv3KaK1KA=
X-Google-Smtp-Source: ABdhPJwbc7KbrBZiC1fRatElYdW6kwrQa6unsnmeGhfBQk6AI7Vk6YcaYKOj3n8RldoCZI4Uzm+GCg==
X-Received: by 2002:a05:6402:84f:: with SMTP id b15mr48540969edz.375.1637546227408;
        Sun, 21 Nov 2021 17:57:07 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id e7sm3385479edk.3.2021.11.21.17.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:57:07 -0800 (PST)
Message-ID: <619af8f3.1c69fb81.71bf6.e95d@mx.google.com>
X-Google-Original-Message-ID: <YZr46soTAFtcP45s@Ansuel-xps.>
Date:   Mon, 22 Nov 2021 02:56:58 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 5/9] net: dsa: qca8k: convert qca8k to regmap
 helper
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
 <20211122010313.24944-6-ansuelsmth@gmail.com>
 <20211122013853.dpprmlprm2q2f24v@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122013853.dpprmlprm2q2f24v@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 03:38:53AM +0200, Vladimir Oltean wrote:
> On Mon, Nov 22, 2021 at 02:03:09AM +0100, Ansuel Smith wrote:
> > Convert any qca8k read/write/rmw/set/clear/pool to regmap helper and add
> > missing config to regmap_config struct.
> > Ipq40xx SoC have the internal switch based on the qca8k regmap but use
> > mmio for read/write/rmw operation instead of mdio.
> > In preparation for the support of this internal switch, convert the
> > driver to regmap API to later split the driver to common and specific
> > code. The overhead introduced by the use of regamp API is marginal as the
> > internal mdio will bypass it by using its direct access and regmap will be
> > used only by configuration functions or fdb access.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 289 ++++++++++++++++++----------------------
> >  1 file changed, 131 insertions(+), 158 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index 52fca800e6f7..159a1065e66b 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -10,6 +10,7 @@
> >  #include <linux/phy.h>
> >  #include <linux/netdevice.h>
> >  #include <linux/bitfield.h>
> > +#include <linux/regmap.h>
> >  #include <net/dsa.h>
> >  #include <linux/of_net.h>
> >  #include <linux/of_mdio.h>
> > @@ -150,8 +151,9 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
> >  }
> >  
> >  static int
> > -qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
> > +qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
> >  {
> > +	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
> >  	struct mii_bus *bus = priv->bus;
> >  	u16 r1, r2, page;
> >  	int ret;
> > @@ -172,8 +174,9 @@ qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
> >  }
> >  
> >  static int
> > -qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
> > +qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
> >  {
> > +	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
> >  	struct mii_bus *bus = priv->bus;
> >  	u16 r1, r2, page;
> >  	int ret;
> > @@ -194,8 +197,9 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
> >  }
> >  
> >  static int
> > -qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
> > +qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_val)
> >  {
> > +	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
> >  	struct mii_bus *bus = priv->bus;
> >  	u16 r1, r2, page;
> >  	u32 val;
> > @@ -223,34 +227,6 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
> >  	return ret;
> >  }
> >  
> > -static int
> > -qca8k_reg_set(struct qca8k_priv *priv, u32 reg, u32 val)
> > -{
> > -	return qca8k_rmw(priv, reg, 0, val);
> > -}
> > -
> > -static int
> > -qca8k_reg_clear(struct qca8k_priv *priv, u32 reg, u32 val)
> > -{
> > -	return qca8k_rmw(priv, reg, val, 0);
> > -}
> > -
> > -static int
> > -qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
> > -{
> > -	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
> > -
> > -	return qca8k_read(priv, reg, val);
> > -}
> > -
> > -static int
> > -qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
> > -{
> > -	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
> > -
> > -	return qca8k_write(priv, reg, val);
> > -}
> > -
> >  static const struct regmap_range qca8k_readable_ranges[] = {
> >  	regmap_reg_range(0x0000, 0x00e4), /* Global control */
> >  	regmap_reg_range(0x0100, 0x0168), /* EEE control */
> > @@ -282,26 +258,19 @@ static struct regmap_config qca8k_regmap_config = {
> >  	.max_register = 0x16ac, /* end MIB - Port6 range */
> >  	.reg_read = qca8k_regmap_read,
> >  	.reg_write = qca8k_regmap_write,
> > +	.reg_update_bits = qca8k_regmap_update_bits,
> >  	.rd_table = &qca8k_readable_table,
> > +	.disable_locking = true, /* Locking is handled by qca8k read/write */
> > +	.cache_type = REGCACHE_NONE, /* Explicitly disable CACHE */
> >  };
> >  
> >  static int
> >  qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
> >  {
> > -	int ret, ret1;
> >  	u32 val;
> >  
> > -	ret = read_poll_timeout(qca8k_read, ret1, !(val & mask),
> > -				0, QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
> > -				priv, reg, &val);
> > -
> > -	/* Check if qca8k_read has failed for a different reason
> > -	 * before returning -ETIMEDOUT
> > -	 */
> > -	if (ret < 0 && ret1 < 0)
> > -		return ret1;
> > -
> > -	return ret;
> > +	return regmap_read_poll_timeout(priv->regmap, reg, val, !(val & mask), 0,
> > +				       QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC);
> >  }
> >  
> >  static int
> > @@ -312,7 +281,7 @@ qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
> >  
> >  	/* load the ARL table into an array */
> >  	for (i = 0; i < 4; i++) {
> > -		ret = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4), &val);
> > +		ret = regmap_read(priv->regmap, QCA8K_REG_ATU_DATA0 + (i * 4), &val);
> 
> Maybe you could keep qca8k_read and qca8k_write and make them return
> regmap_read(priv->regmap, ...), this could reduce the patch's delta,
> make future bugfix patches conflict less with this change, etc etc.
> What do you think?

Problem is that many function will have to be moved to a separate file
(for the common stuff) and they won't have qca8k_read/write/rmw...
So converting everything to regmap would be handy as you drop the
extra functions.
But I see how reworking the read/write/rmw would massively reduce the
patch delta.

When we will have to split the code, we will have this problem again and
we will have to decide if continue using the qca8k_read/write... or drop
them and switch to regmap.

So... yes i'm stuck as if we want to save some conflicts we will have to
carry the extra function forver I think.
(Wonder if the conflict problem will just be """solved""" with the code
split as someone will have to rework the patch anyway as the function
will be located on a different file)

-- 
	Ansuel
