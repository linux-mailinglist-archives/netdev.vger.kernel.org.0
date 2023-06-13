Return-Path: <netdev+bounces-10447-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D6E72E8C7
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:47:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDE8B1C20848
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:47:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9851C23C6A;
	Tue, 13 Jun 2023 16:47:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1B733E3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 16:47:51 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCF5EC;
	Tue, 13 Jun 2023 09:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=MPlFvYbPj0zRiedZYtDVq48XcSin/HHiLDsLfTxEPjs=; b=bzyyuuO1wXO4P6JhJ8fvVxGi0C
	E73zFPqLI9Qy4PwXztTntyzzFk59hF8bYeUqsagBIbnYTWUXVlCTObrBG+7zXTF/3CU+0EfdlalRp
	RDsX5suYs027TjZG0LqE5/eV/UiV8/YCd6CNp7jQN8pSeFU+pIw66VeLTZb9dcoY17EBi1atvad0o
	SkEFlW3OSxiL7H3+n2JRPhm+IXwzjcXaSuo7hMMobf1WwH4ckm+sgIoEeSsge2bGFDJovhPcX1CmN
	QGZblBFVaqmzJ/aF+UlWIrqAUlZ50b2w75iBgUySnv3ZCsx3d0c0P2TnaP9B+Jrs1T1j4yu/HKicU
	oGWkF/dQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35810)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q97BI-0000O8-51; Tue, 13 Jun 2023 17:47:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q97BG-0006Bw-3D; Tue, 13 Jun 2023 17:47:42 +0100
Date: Tue, 13 Jun 2023 17:47:42 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Jianhui Zhao <zhaojh329@gmail.com>, hkallweit1@gmail.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] net: phy: Add sysfs attribute for PHY c45 identifiers.
Message-ID: <ZIidrqudxBaOva90@shell.armlinux.org.uk>
References: <20230613143025.111844-1-zhaojh329@gmail.com>
 <612d5964-6034-4188-8da5-53f3f38a25e4@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <612d5964-6034-4188-8da5-53f3f38a25e4@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 06:18:58PM +0200, Andrew Lunn wrote:
> > +#define DEVICE_ATTR_C45_ID(i) \
> > +static ssize_t \
> > +phy_c45_id##i##_show(struct device *dev, \
> > +	struct device_attribute *attr, char *buf) \
> > +{ \
> > +	struct phy_device *phydev = to_phy_device(dev); \
> > +\
> > +	if (!phydev->is_c45) \
> > +		return 0; \
> > +\
> > +	return sprintf(buf, "0x%.8lx\n", \
> > +		(unsigned long)phydev->c45_ids.device_ids[i]); \
> > +} \
> 
> That is not the most efficient implementation.
> 
> You can have one generic
> 
> static ssize_t phy_c45_id_show(struct device *dev, char *buf, int i)
> {
> 	struct phy_device *phydev = to_phy_device(dev);
> 
> 	if (!phydev->is_c45)
> 		return 0;
> 
> 	return sprintf(buf, "0x%.8lx\n",
> 		      (unsigned long)phydev->c45_ids.device_ids[i]);
> }
> 
> And then your macros becomes
> 
> #define DEVICE_ATTR_C45_ID(i)			  \
> static ssize_t					  \
> phy_c45_id##i##_show(struct device *dev,	  \
> 	struct device_attribute *attr, char *buf) \
> {						  \
> 	return phy_c45_id_show(dev, buf, i);	  \
> }
> 

I have a further suggestion, which I think will result in yet more
efficiencies:

struct phy_c45_devid_attribute {
	struct device_attribute attr;
	int index;
};

#define to_phy_c45_devid_attr(attr) \
	container_of(attr, struct phy_c45_devid_attribute, attr)

static ssize_t phy_c45_id_show(struct device *dev,
			       struct device_attribute *attr, char *buf)
{
	struct phy_c45_devid_attribute *devattr = to_phy_c45_devid_attr(attr);
	struct phy_device *phydev = to_phy_device(dev);
	unsigned long id;

	if (!phydev->is_c45)
		return 0;

	id = phydev->c45_ids.device_ids[devattr->index];

	return sprintf(buf, "0x%.8lx\n", id);
}

#define DEVICE_ATTR_C45_ID(i) \
static struct phy_c45_devid_attribute dev_attr_phy_c45_id##i = { \
	.attr = { \
		.attr   = { .name = __stringify(mmd##i), .mode = 0444 }, \
		.show   = phy_c45_id_show \
	}, \
	.index = i, \
}

which will probably result in less code size for a little larger data
size. Note that the references to this would need to be:

	&dev_attr_phy_c45_id1.attr.attr

in the array (adding an extra .attr).

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

