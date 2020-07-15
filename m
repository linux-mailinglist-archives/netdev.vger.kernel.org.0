Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933EE2217EC
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 00:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgGOWoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 18:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgGOWox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 18:44:53 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D305C061755;
        Wed, 15 Jul 2020 15:44:53 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id o18so4108069eje.7;
        Wed, 15 Jul 2020 15:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4M+hLtLEs7PjV/DAxGGuoG9wj+lYK0KPkq9jNEF3IbE=;
        b=KZridxBWFiYfGsxVkihFki3F4shUFpUBDby2f5c47ZV5x+fvtButWc5P+YX2Ia129A
         elbkNZEnXhQrNl9p/Uwsv2pjqsAMHnNdTcQrM1LyM4zB5ecDFBEvfltZnQ21+bcxWiC1
         sOVfoJ7OpOs/cZdzpcAHWzmfAHk6ZLg+I1HoVwLB4FFQRWf7HODRqMv4RaN0MeSlq6vk
         8+yF6v+lUBrHpYBsoeW8wFtyh8Av5DWUMvRuIGPd/8MRVOE0Bgq4vjptZFTwoXHbPVsF
         JcjcFFp73zQICsGLD4/DftL+H5IZv9Gp4rl3Yssr82vYu3qCSw21Yx7El4Z/VZgErx9c
         IikQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4M+hLtLEs7PjV/DAxGGuoG9wj+lYK0KPkq9jNEF3IbE=;
        b=GicZhn2+uJJLcpzHHk5UR+pEwINS20o4HVf8CPrQrdpEP6bq4639XJSOr0mCdN/qls
         PZmkp3W9CnqeDT0tRZdMvGCkklnYDjBlkgGSnWOKKBkhXIpPPk25a1kFlDlPdl1S3WkA
         X/OkpOR28VjLqQsLx0j2jQ49efSwcQktLThMKvXNvUsuNwXjbU9+1qZLDHSsOmWF8V/f
         MxO4S0p6W4LUC1AKdkxuOUYp6OGGwt1GrgaxJcF4kMB4L0ZC4tLDL3og/pxHH4gPT374
         mg7L3GHTlhz00h8/hgNZsGNNZ2ORwB6Va9JFIxySo8ilpqtB4H19Rpju4+4DGau6VZux
         9zGg==
X-Gm-Message-State: AOAM530mcvL5QyXIcvg9WqDq78qk/Kr0F7JTckG4ZmmjUqkd5YNEQRuC
        3uWP6L08Ilq+Jsg3+svucvk=
X-Google-Smtp-Source: ABdhPJz7hHoVGdZ4dQSDXImc4c7nsS9meLDLElekH+50f6tALPMzph3f60658UJlLYFuadGVIPvmow==
X-Received: by 2002:a17:906:c44c:: with SMTP id ck12mr1113082ejb.145.1594853092174;
        Wed, 15 Jul 2020 15:44:52 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id r6sm3206573ejd.55.2020.07.15.15.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 15:44:51 -0700 (PDT)
Date:   Thu, 16 Jul 2020 01:44:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v6 1/4] net: phy: add USXGMII link partner
 ability constants
Message-ID: <20200715224449.hrqblfteshuknxon@skbuf>
References: <20200709213526.21972-1-michael@walle.cc>
 <20200709213526.21972-2-michael@walle.cc>
 <20200713182314.GW1551@shell.armlinux.org.uk>
 <546718f3f76862d285aeb82cb02767c4@walle.cc>
 <b6c24b8f698245549056c975042d9b51@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6c24b8f698245549056c975042d9b51@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 10:33:23PM +0200, Michael Walle wrote:
> Am 2020-07-13 20:37, schrieb Michael Walle:
> > Am 2020-07-13 20:23, schrieb Russell King - ARM Linux admin:
> > > On Thu, Jul 09, 2020 at 11:35:23PM +0200, Michael Walle wrote:
> > > > The constants are taken from the USXGMII Singleport Copper Interface
> > > > specification. The naming are based on the SGMII ones, but with
> > > > an MDIO_
> > > > prefix.
> > > > 
> > > > Signed-off-by: Michael Walle <michael@walle.cc>
> > > > ---
> > > >  include/uapi/linux/mdio.h | 26 ++++++++++++++++++++++++++
> > > >  1 file changed, 26 insertions(+)
> > > > 
> > > > diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
> > > > index 4bcb41c71b8c..784723072578 100644
> > > > --- a/include/uapi/linux/mdio.h
> > > > +++ b/include/uapi/linux/mdio.h
> > > > @@ -324,4 +324,30 @@ static inline __u16 mdio_phy_id_c45(int
> > > > prtad, int devad)
> > > >  	return MDIO_PHY_ID_C45 | (prtad << 5) | devad;
> > > >  }
> > > > 
> > > > +/* UsxgmiiChannelInfo[15:0] for USXGMII in-band auto-negotiation.*/
> > > > +#define MDIO_LPA_USXGMII_EEE_CLK_STP	0x0080	/* EEE clock stop
> > > > supported */
> > > > +#define MDIO_LPA_USXGMII_EEE		0x0100	/* EEE supported */
> > > > +#define MDIO_LPA_USXGMII_SPD_MASK	0x0e00	/* USXGMII speed mask */
> > > > +#define MDIO_LPA_USXGMII_FULL_DUPLEX	0x1000	/* USXGMII full
> > > > duplex */
> > > > +#define MDIO_LPA_USXGMII_DPX_SPD_MASK	0x1e00	/* USXGMII duplex
> > > > and speed bits */
> > > > +#define MDIO_LPA_USXGMII_10		0x0000	/* 10Mbps */
> > > > +#define MDIO_LPA_USXGMII_10HALF		0x0000	/* 10Mbps half-duplex */
> > > > +#define MDIO_LPA_USXGMII_10FULL		0x1000	/* 10Mbps full-duplex */
> > > > +#define MDIO_LPA_USXGMII_100		0x0200	/* 100Mbps */
> > > > +#define MDIO_LPA_USXGMII_100HALF	0x0200	/* 100Mbps half-duplex */
> > > > +#define MDIO_LPA_USXGMII_100FULL	0x1200	/* 100Mbps full-duplex */
> > > > +#define MDIO_LPA_USXGMII_1000		0x0400	/* 1000Mbps */
> > > > +#define MDIO_LPA_USXGMII_1000HALF	0x0400	/* 1000Mbps half-duplex */
> > > > +#define MDIO_LPA_USXGMII_1000FULL	0x1400	/* 1000Mbps full-duplex */
> > > > +#define MDIO_LPA_USXGMII_10G		0x0600	/* 10Gbps */
> > > > +#define MDIO_LPA_USXGMII_10GHALF	0x0600	/* 10Gbps half-duplex */
> > > > +#define MDIO_LPA_USXGMII_10GFULL	0x1600	/* 10Gbps full-duplex */
> > > > +#define MDIO_LPA_USXGMII_2500		0x0800	/* 2500Mbps */
> > > > +#define MDIO_LPA_USXGMII_2500HALF	0x0800	/* 2500Mbps half-duplex */
> > > > +#define MDIO_LPA_USXGMII_2500FULL	0x1800	/* 2500Mbps full-duplex */
> > > > +#define MDIO_LPA_USXGMII_5000		0x0a00	/* 5000Mbps */
> > > > +#define MDIO_LPA_USXGMII_5000HALF	0x0a00	/* 5000Mbps half-duplex */
> > > > +#define MDIO_LPA_USXGMII_5000FULL	0x1a00	/* 5000Mbps full-duplex */
> > > > +#define MDIO_LPA_USXGMII_LINK		0x8000	/* PHY link with
> > > > copper-side partner */
> > > 
> > > btw, the only thing which is missing from this is bit 0.
> > 
> > TBH, I didn't know how to name it. Any suggestions?
> 
> NXP calls it ABIL0, in xilinx docs its called USXGMII [1]. In the USXGMII
> spec, its "set to 1 (0 is SGMII)" which I don't understand because its
> also 1 for SGMII, right? At least as described in the tx_configReg[15:0] in
> the SGMII spec.
> 
> #define MDIO_USXGMII_USXGMII 0x0001 ?
> 
> -michael
> 
> [1] https://www.xilinx.com/support/documentation/ip_documentation/usxgmii/v1_0/pg251-usxgmii.pdf

The explanation in the spec is quite cryptic, I've taken that to mean
"corresponds to bit 0 in SGMII". Hence the reason why, in the code I've
introduced in Felix, this is simply used as ADVERTISE_SGMII. I have no
problem in creating an alias to ADVERTISE_SGMII named
MDIO_LPA_USXGMII_SGMII. That being said, I don't see, right now, a
practical situation where you might want to parse bit 0 from LPA, it's
just like in Forrest Gump: "life is like a box of chocolates, you never
know what you're gonna get". Adding it now to the UAPI might very well
be a non-issue.

-Vladimir
