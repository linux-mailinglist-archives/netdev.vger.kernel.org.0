Return-Path: <netdev+bounces-8436-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E5E7240CC
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:25:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5728E1C20F43
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E7115ADA;
	Tue,  6 Jun 2023 11:25:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAD2468F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:25:50 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8326B1
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 04:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0cFOXbqCS+yA/fAj3HipkNbFW2UqjGIVrc97LrAKoG0=; b=xkgqlpK7V1AFqem6pwW+Vvwe0b
	btxvqF+MKU//qJVrYc2tuKyO7KdcbJRz3THdroNFrMyo1oGCFMg06RipXAlHuGrPgIP0+6QuCN6B0
	03LfdkU23npMs85yZTWVkfV6zyGWKgEYd9zM57BUO/Vas2rJRO72fMpFa3j33WAhC47Mmtl5fXDqB
	DiNEjfAgyUdCGYgP4T8S07GsEXrwETExXt68cCKu34+bkU5uvyv1ACYd94f6E5HXQnY/lZVGK/zGQ
	r1Hb1YyYqdT5ebR06G2+yu0lepA0h20NvA5lDpel1UNc7zm9yuugnlLBsnuTuOk+2dg8Ay+Frh9Ka
	1fBasrHw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35064)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6Uoo-0005ZO-Sn; Tue, 06 Jun 2023 12:25:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6Uon-00076U-5L; Tue, 06 Jun 2023 12:25:41 +0100
Date: Tue, 6 Jun 2023 12:25:41 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Sean Anderson <sean.anderson@seco.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 4/8] net: pcs: lynx: add lynx_pcs_create_fwnode()
Message-ID: <ZH8Xtb4X7q8SkfES@shell.armlinux.org.uk>
References: <ZHoOe9K/dZuW2pOe@shell.armlinux.org.uk>
 <E1q56y1-00Bsum-Hx@rmk-PC.armlinux.org.uk>
 <64b55156-81e2-44cf-224d-d362e10955e3@seco.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64b55156-81e2-44cf-224d-d362e10955e3@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 11:51:23AM -0400, Sean Anderson wrote:
> On 6/2/23 11:45, Russell King (Oracle) wrote:
> > Add a helper to create a lynx PCS from a fwnode handle.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/pcs/pcs-lynx.c | 29 +++++++++++++++++++++++++++++
> >  include/linux/pcs-lynx.h   |  1 +
> >  2 files changed, 30 insertions(+)
> > 
> > diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
> > index a90f74172f49..b0907c67d469 100644
> > --- a/drivers/net/pcs/pcs-lynx.c
> > +++ b/drivers/net/pcs/pcs-lynx.c
> > @@ -353,6 +353,35 @@ struct phylink_pcs *lynx_pcs_create_mdiodev(struct mii_bus *bus, int addr)
> >  }
> >  EXPORT_SYMBOL(lynx_pcs_create_mdiodev);
> >  
> > +struct phylink_pcs *lynx_pcs_create_fwnode(struct fwnode_handle *node)
> > +{
> > +	struct mdio_device *mdio;
> > +	struct phylink_pcs *pcs;
> 
> I think you should put the available check here as well.

Sorry, I totally missed your comment.

Yes, that would also fix the refcount leak in memac_pcs_create(). I
thought about that, but I decided against it because in dpaa2:

        if (!fwnode_device_is_available(node)) {
                netdev_err(mac->net_dev, "pcs-handle node not available\n");
                fwnode_handle_put(node);
                return -ENODEV;
        }

would become:

        if (IS_ERR(pcs)) {
                netdev_err(mac->net_dev,
                           "lynx_pcs_create_fwnode() failed: %pe\n", pcs);

If the device is not available, the error message changes from
	pcs-handle node not available
to
	lynx_pcs_create_fwnode() failed: ENODEV

which doesn't really say what the problem was. Is this something that
the DPAA2 maintainers care about?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

