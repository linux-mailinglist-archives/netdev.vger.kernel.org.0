Return-Path: <netdev+bounces-1959-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4E576FFB87
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:55:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9071E28196F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30A712B86;
	Thu, 11 May 2023 20:55:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54FC2918
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:55:54 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A17B7AA7
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JJiaQU12yzpcHDmDZXidl0vSf/eoI8EDoa48hrwnJpA=; b=0A0R9AMnyKI+aoxnbaPS6HV5Gj
	4zWqLkYl+7b7lURoSkIzeQ8c4au3kdX2cs6XmcsPN4ok+uFFANs6UngvkDSXUmRuKxgQ61iHvyVrQ
	814Bvi/RbO3a4izu0U+MWkIcBOt0DQZa67xvtdUY6tg40GZhYnP5umQ0cATHaHbLSUTV66FcpR9sL
	HcqRUM0vn+Id9r1w+Wxvi7bzOGllwxUwAFB7dxUavlImXyl658KVAg+t/5mPc/1ItniRTEz9Qw2Ny
	sl/6sl8hi5gSUqZEQaMOHD9PDvWkuNFUfzbb0ZtrcE2wV/bFrUZanj8V6qigPss5SQ/x9j2dzJO+C
	dstU7MNA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38902)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pxDKA-0007Fi-Gx; Thu, 11 May 2023 21:55:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pxDK7-0004Ln-Ul; Thu, 11 May 2023 21:55:39 +0100
Date: Thu, 11 May 2023 21:55:39 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	=?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
 <20230406184646.0c7c2ab1@kernel.org>
 <20230511203646.ihljeknxni77uu5j@skbuf>
 <54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 10:50:30PM +0200, Andrew Lunn wrote:
> On Thu, May 11, 2023 at 11:36:46PM +0300, Vladimir Oltean wrote:
> > On Thu, Apr 06, 2023 at 06:46:46PM -0700, Jakub Kicinski wrote:
> > > > +/* Hardware layer of the SO_TIMESTAMPING provider */
> > > > +enum timestamping_layer {
> > > > +	SOF_MAC_TIMESTAMPING = (1<<0),
> > > > +	SOF_PHY_TIMESTAMPING = (1<<1),
> > > 
> > > We need a value for DMA timestamps here.
> > 
> > What's a DMA timestamp, technically? Is it a snapshot of the PHC's time
> > domain, just not at the MII pins?
> 
> I also wounder if there is one definition of DMA timestampting, or
> multiple. It could simply be that the time stamp is in the DMA
> descriptor,

Surely that is equivalent to MAC timestamping? Whether the MAC
places it in a DMA descriptor, or whether it places it in some
auxiliary information along with the packet is surely irrelevant,
because the MAC has to have the timestamp available to it in some
manner. Where it ends up is just a function of implementation surely?

I'm just wondering what this would mean for mvpp2, where the
timestamps are in the descriptors. If we have a "DMA timestamp"
is that a "DMA timestamp" or a "MAC timestamp"? The timestamp comes
from the MAC in this case.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

