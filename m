Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4539849C254
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbiAZDxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237323AbiAZDxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:53:10 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA57C06161C;
        Tue, 25 Jan 2022 19:53:10 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id p7so1473871edc.12;
        Tue, 25 Jan 2022 19:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ybArNCbVe0Tgv3JZuy0yaABkLWvJA8TbLKGRPYCzNSM=;
        b=UfqyEUYyS09EpMQveLsCPr4RjpKWFoGRfZTO6XOp8Ghs0aL5yNCy0ox3MlxO0ZfYsj
         gXX3dgHU4dnOJhdSRG0Fpgjgklcw8ol5rQy5Y42KDX9lZw5JnpBGXtXqXgB1In+/oScJ
         RKv8CvKfTxWplpCcMiSuEWLWQL10bJUij6RR1cLT1aWeA3vQRJkiXWGgo4SPXXpLK3xx
         mXj6E62HYWAe7iMUary+01jwSKkHLsq9lBaYAIfymSpYHiSBlp/ittIj/j5rl1zEju2V
         dRiLO5C93gWB4/HQfrt0jhcvXq/rfPVTYFFGKLirJwDTVv2cESPuqe555PIKBPX8uKq2
         lKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ybArNCbVe0Tgv3JZuy0yaABkLWvJA8TbLKGRPYCzNSM=;
        b=KzJJxd7iBIggyZTsAUG5zNxyZREzOhqrcJtdGG7RgcpXP/jI6SWV/R9lDbokuuAqyv
         s6fCLXAeNUs+DcTgWjHlpuZ5XoXPK4l8CA07QPK6eUmFtLpQymoJg5jXy6sOKkaaNakX
         mqSEWMEDZLt5fWgOWziXIspACcxBzHwNQ7molGuODZdWg0PKaiEosqvrqE/XzO7JWZdK
         qa4NRLaSj+fdxJxlJ2xGnACZ0bAwquJTfXdaghgNFIbBnAeKd1+aF1iEOJUy4ejnGdx8
         zTzH9xFJzzHi0k8vL59AddeaLg6sQIFx6qM/QiKKuh7kZqy7ZO+Af0DjaJRmBA2e7Anx
         Cklg==
X-Gm-Message-State: AOAM530NGI1BB2WjrkiTLatY79G3pxHA+Rmk13tVW0zw1vpFCgr0KWkR
        V2g4gVf5AR80TCQZnd9GyWc=
X-Google-Smtp-Source: ABdhPJwlA3sLErcf55BUzgD08/DIJVnrDn8edoMuMoz7OvvvcPd7o2kO33rMcJENLmgF3pp+5J/fLA==
X-Received: by 2002:a05:6402:2553:: with SMTP id l19mr13732774edb.230.1643169188690;
        Tue, 25 Jan 2022 19:53:08 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id gv34sm6826932ejc.125.2022.01.25.19.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 19:53:08 -0800 (PST)
Date:   Wed, 26 Jan 2022 04:53:03 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 16/16] net: dsa: qca8k: introduce
 qca8k_bulk_read/write function
Message-ID: <YfDFn0IVjzHfSS87@Ansuel-xps.localdomain>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-17-ansuelsmth@gmail.com>
 <e40b4f78-5ac8-80fe-7c09-127ce01dde92@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e40b4f78-5ac8-80fe-7c09-127ce01dde92@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 07:45:29PM -0800, Florian Fainelli wrote:
> 
> 
> On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> > Introduce qca8k_bulk_read/write() function to use mgmt Ethernet way to
> > read/write packet in bulk. Make use of this new function in the fdb
> > function.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> 
> [snip]
> 
> >   static int
> >   qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
> >   {
> > @@ -535,17 +572,13 @@ qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
> >   static int
> >   qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
> >   {
> > -	u32 reg[4], val;
> > -	int i, ret;
> > +	u32 reg[4];
> > +	int ret;
> >   	/* load the ARL table into an array */
> > -	for (i = 0; i < 4; i++) {
> > -		ret = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4), &val);
> > -		if (ret < 0)
> > -			return ret;
> > -
> > -		reg[i] = val;
> > -	}
> > +	ret = qca8k_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg, 12);
> 
> sizeof(reg)? How did you come up with 12 if we were executing the loop 4
> times before or were we reading too much?
>

Exactly that. The acl table is actualy of 83 bits. Currently we read 128
bits but we only handle 96 as we never read/write in reg[3].

> > +	if (ret)
> > +		return ret;
> >   	/* vid - 83:72 */
> >   	fdb->vid = FIELD_GET(QCA8K_ATU_VID_MASK, reg[2]);
> > @@ -569,7 +602,6 @@ qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
> >   		u8 aging)
> >   {
> >   	u32 reg[3] = { 0 };
> > -	int i;
> >   	/* vid - 83:72 */
> >   	reg[2] = FIELD_PREP(QCA8K_ATU_VID_MASK, vid);
> > @@ -586,8 +618,7 @@ qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
> >   	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR5_MASK, mac[5]);
> >   	/* load the array into the ARL table */
> > -	for (i = 0; i < 3; i++)
> > -		qca8k_write(priv, QCA8K_REG_ATU_DATA0 + (i * 4), reg[i]);
> > +	qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg, 12);
> 
> sizeof(reg) would be more adequate here.
> -- 
> Florian

-- 
	Ansuel
