Return-Path: <netdev+bounces-9601-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEB8B729FFB
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:18:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A967D281984
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E987D1F955;
	Fri,  9 Jun 2023 16:18:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEECC1F170
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:18:54 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935433AA1
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1hcRxeYSakIwsxLJ9e5cTS5DE1P9Drs+EgbkL68c64w=; b=tyFrYeI5oC2dLzU6Mf5IqfD+9n
	4xbK+Iond+XQaAu/AfuQMbFF0emWPoEfNyrP0dhqzc1kslhJneyDVB3saTR3S0ExfIa1dfU4l8e+I
	a5p5ybHa3BjLOPltP8qP+CB7I9W6zy4oJ9b25THJ2GqIHq4YV4qFfaFKn8fT37i0nkp6czUwhDTWy
	igA5Vb9AKD3LIi/BCxm2MXLXa8eAsforDXRrwuXoHBV0ckjRAJtnjAcdQnZHW8YyuUmmm5Kh6DXvB
	SrOYKzFWjjtDeG0Pg3UCpsXZsFNafFbD5V/EkL3WDDDRZ2vnVFNqN+TsLtgTqCPyo3BQQa/D3lokH
	4E1ZPrng==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44168)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q7eon-0002IL-FC; Fri, 09 Jun 2023 17:18:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q7eol-0001zo-7x; Fri, 09 Jun 2023 17:18:27 +0100
Date: Fri, 9 Jun 2023 17:18:27 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Jakub Kicinski <kuba@kernel.org>, mkubecek@suse.cz,
	danieller@nvidia.com, idosch@nvidia.com, netdev@vger.kernel.org,
	vladyslavt@nvidia.com
Subject: Re: [PATCH ethtool-next] sff-8636: report LOL / LOS / Tx Fault
Message-ID: <ZINQ02Qrh/X+/Evy@shell.armlinux.org.uk>
References: <20230609004400.1276734-1-kuba@kernel.org>
 <7aaec2ea-5459-46c6-877c-41d9cf93bcc1@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7aaec2ea-5459-46c6-877c-41d9cf93bcc1@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 05:31:42PM +0200, Andrew Lunn wrote:
> > I was asked if "Linux reports" this information.
> 
> Linux does, in /sys/kernel/debug/sfpX/status. It gives your the GPIOs
> value.

That's for SFPs, but I didn't work out a sane way to drive QSFPs. I did
make a start on the basic bare bones, and it would be nice to put more
time into it, but I need a greater understanding of how setups with
quad interfaces are modelled in the kernel - and that's something I
very little experience of.

My mental stumbling block is that quad interfaces seem to act as either
four separate network interfaces, or I think the lanes can be combined
to double or quadruple the data bandwidth. How this looks from the
firmware description perspective (in either DT or elsewhere) I don't
know. Can they be dynamically changed too?

It's relevant because QSFPs give status per individual lanes, so
anything bridging between the QSFP and a set of MACs needs to know
which lanes are associated with which MACs.

One of the SolidRun platforms I have does have a QSFP cage, and that's
where I made a start, but I very much feel that the canvas is blank
about how this should be modelled.

Now, as for SFPs, there's... the hardware signal state and software
signal state. The debugfs file you point at is merely for debug, it's
not an API (it's in debugfs!) We do report there the hardware and
software state. Whether we should have a proper API for that
information, and whether we should be able to reset the tx fault
state once it's happened too many times and we've locked out...
so far I don't think anyone has got to that point though.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

