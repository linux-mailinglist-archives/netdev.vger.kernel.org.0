Return-Path: <netdev+bounces-1744-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B67D6FF091
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7936E1C20F28
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCB619BA9;
	Thu, 11 May 2023 11:32:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512B965E
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:32:55 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D277AA7
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=aTYwuHdzAw6rOQjUzr5Q2SbsMbNhuUmk9fM7LUF3fc4=; b=zqacytQPTg7CQEA1BBpHOdsNj3
	i3rt58Gwe61gAEyxrifQm7Qd3ZrSzGZ2M0U9Rc2wzdnn3BL4pVIgcgJhW3eZM94fJr3hr5T64we1v
	YorCSrctMZnjB7euO+eaoYRMkcslg7LbxiPFd7uB45pi7YlNEj9AGzdzkhldoj1m1F2mhmPTmoW5F
	qKqoSwu/HayE2/icurCLzuEAFsUvsyHiW5vQBJWq4F1R1shwUVeQcJvDFZbGBgycCT1InZgqPj2yp
	4VTHHRyANaFTHk+gwPkA0rvcLZF55yftLaN7faA8mhUReTPly5gcEJ5q9g4U1+kUNRS22wznhPFAO
	c3qPAfDg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44188)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1px4XH-0006SD-37; Thu, 11 May 2023 12:32:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1px4XF-0003yp-A0; Thu, 11 May 2023 12:32:37 +0100
Date: Thu, 11 May 2023 12:32:37 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylink: constify fwnode arguments
Message-ID: <ZFzSVciEsAU/pKLB@shell.armlinux.org.uk>
References: <E1pwhbd-001XUm-Km@rmk-PC.armlinux.org.uk>
 <75dd5f74abe1d168e9bb679d1e47947f4900a1f9.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75dd5f74abe1d168e9bb679d1e47947f4900a1f9.camel@redhat.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 01:29:50PM +0200, Paolo Abeni wrote:
> On Wed, 2023-05-10 at 12:03 +0100, Russell King (Oracle) wrote:
> > diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> > index 71755c66c162..02c777ad18f2 100644
> > --- a/include/linux/phylink.h
> > +++ b/include/linux/phylink.h
> > @@ -568,7 +568,8 @@ void phylink_generic_validate(struct phylink_config *config,
> >  			      unsigned long *supported,
> >  			      struct phylink_link_state *state);
> >  
> > -struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
> > +struct phylink *phylink_create(struct phylink_config *,
> > +			       const struct fwnode_handle *,
> 
> While touching the above, could you please also add the missing params
> name, to keep checkpatch happy and be consistent with the others
> arguments?

For interest, when did naming parameters in a prototype become a
requirement?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

