Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1462D235713
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 15:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgHBNVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 09:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727914AbgHBNVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 09:21:45 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0283C06174A;
        Sun,  2 Aug 2020 06:21:44 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id kq25so22958946ejb.3;
        Sun, 02 Aug 2020 06:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZUL/yD9zmO6DmcZy6KXxPbVU4U1pO6NSKiKrUZ+bXyM=;
        b=p4XSCN8yGgZCIhrkkj1rFOVoYL7U2r0/270o3/AEHkM4jDzbO4LGflEOjQYiRZwSdq
         7nS4D+YvJZvNmZFH6RyZuBI94p8IKHpEYyqBhnHgccFoyEyZwa+GqCceYwdpeDhVNdsi
         f2pGhzQgfx3GFY0JDG6Kw5VBqTYWcteIz4SemeH+w4jOu5T9tp9pVRrAst7Ihzsw3XPv
         3mjJELk+XFSCjE+6ZnJRoY0pAgo7yYQdYvjnNB+jFEdOscFgQRe9FBFw+1fKgzAziuf9
         YBWbVvzMp2KOeYYuEaHBSXdLitmh1N8eotFy0TgUa5QRSCredN765aNtwKjC9AUz1WsH
         I+aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZUL/yD9zmO6DmcZy6KXxPbVU4U1pO6NSKiKrUZ+bXyM=;
        b=EGrrjEIgSt7VeHlRb+7Q0FLmyAKZ08hDZ4mAa8TKeldzutEtHwoGYQYYnlqXqGLExG
         1V4IOJ3qZcZ2znuS2UWvSReqthvTPTwhTNS0PqFeI2+Bzv2Q/fXNNH0W0w0N1LmGKYK5
         lre4b4/xutM28wdk+gECyuRL5poYJNGPVDCxCCt8QwJdmuUfILFYN6o61FOzTWQ+kRhN
         sjuxgxJDH0HY2/JM4r7hzmb+LNnURJ0Uw7ANwp9/aPrcQqYzk3mrRU91de66eJYIo/H5
         AcHRUZJcHlJFlzr2Kg6kFRyBplgIey+8tCCwmDgY4ody3sTKo42zPDD0tFTKY5sKdwU5
         0bOw==
X-Gm-Message-State: AOAM530bwSWiRB/h7DeVQR6h1w9y1kig3fkUmfcsgS/yoPUa5wiEPQe+
        vf7AUFPjSk9XYQej5S79fUY=
X-Google-Smtp-Source: ABdhPJwtfLVX/r+ZgDfvF/aaiqOf8MaZ5i1jtil/zwBqaXGuAF+t8Ds7ys5dYrEBiJ1waG2tLGonDQ==
X-Received: by 2002:a17:906:95cb:: with SMTP id n11mr12145750ejy.506.1596374503481;
        Sun, 02 Aug 2020 06:21:43 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id q11sm3931651edn.52.2020.08.02.06.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 06:21:43 -0700 (PDT)
Date:   Sun, 2 Aug 2020 16:21:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/2] net: dsa: qca8k: Add define for port VID
Message-ID: <20200802132141.qobvb32guc3hx5lk@skbuf>
References: <20200721171624.GK23489@earth.li>
 <08fd70c48668544408bdb7932ef23e13d1080ad1.1596301468.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08fd70c48668544408bdb7932ef23e13d1080ad1.1596301468.git.noodles@earth.li>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 01, 2020 at 06:05:54PM +0100, Jonathan McDowell wrote:
> Rather than using a magic value of 1 when configuring the port VIDs add
> a QCA8K_PORT_VID_DEF define and use that instead. Also fix up the
> bitmask in the process; the top 4 bits are reserved so this wasn't a
> problem, but only masking 12 bits is the correct approach.
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>
> ---

Acked-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/qca8k.c | 11 ++++++-----
>  drivers/net/dsa/qca8k.h |  2 ++
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index a5566de82853..3ebc4da63074 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -663,10 +663,11 @@ qca8k_setup(struct dsa_switch *ds)
>  			 * default egress vid
>  			 */
>  			qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
> -				  0xffff << shift, 1 << shift);
> +				  0xfff << shift,
> +				  QCA8K_PORT_VID_DEF << shift);
>  			qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
> -				    QCA8K_PORT_VLAN_CVID(1) |
> -				    QCA8K_PORT_VLAN_SVID(1));
> +				    QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
> +				    QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
>  		}
>  	}
>  
> @@ -1133,7 +1134,7 @@ qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
>  {
>  	/* Set the vid to the port vlan id if no vid is set */
>  	if (!vid)
> -		vid = 1;
> +		vid = QCA8K_PORT_VID_DEF;
>  
>  	return qca8k_fdb_add(priv, addr, port_mask, vid,
>  			     QCA8K_ATU_STATUS_STATIC);
> @@ -1157,7 +1158,7 @@ qca8k_port_fdb_del(struct dsa_switch *ds, int port,
>  	u16 port_mask = BIT(port);
>  
>  	if (!vid)
> -		vid = 1;
> +		vid = QCA8K_PORT_VID_DEF;
>  
>  	return qca8k_fdb_del(priv, addr, port_mask, vid);
>  }
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index 31439396401c..92216a52daa5 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -22,6 +22,8 @@
>  
>  #define QCA8K_CPU_PORT					0
>  
> +#define QCA8K_PORT_VID_DEF				1
> +
>  /* Global control registers */
>  #define QCA8K_REG_MASK_CTRL				0x000
>  #define   QCA8K_MASK_CTRL_ID_M				0xff
> -- 
> 2.20.1
> 
