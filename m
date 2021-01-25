Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8FB30266A
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 15:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbhAYOnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 09:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729713AbhAYOnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 09:43:12 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF139C061574;
        Mon, 25 Jan 2021 06:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=18CAxTK3LlXW3fAUVds+hr8MiQ4foh0e7sgTFpboodo=; b=tHhuyGGNmnjdGP80Qihex9fMO
        5llpohjDXMEW9bGa+M7hZLmqjplEL5SQidV7PuCL3mz9cJWM5nfcqrsfdAPM4S55KNAavdG4Z3xaS
        li1bUoXc9TW/yyuCCdwOrR/AGL8VUJDM44CuGLgdMnWVY6yWR2N9S52QEfS49jvpHy6DTE7mPBkEG
        IF+8n8pP6KDJ8O4sZZNdagEc/byno8eVR+ympfOsX4MwoVRYeLC/Csn3ASdm5yVoD7awt/qrxJzKU
        Azw1dk3ztXa7HHR+UyaTneV/wA8wLDxhs8s7q38gpjYb9T73dxwtWMuxPX3UpzjgGAuHqYojNJQgd
        iwyWFhA+A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52568)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l434R-0003Gw-0Q; Mon, 25 Jan 2021 14:42:23 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l434P-0002pn-TI; Mon, 25 Jan 2021 14:42:21 +0000
Date:   Mon, 25 Jan 2021 14:42:21 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] net: sfp: add support for GPON RTL8672/RTL9601C
 and Ubiquiti U-Fiber
Message-ID: <20210125144221.GE1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210111113909.31702-1-pali@kernel.org>
 <20210118093435.coy3rnchbmlkinpe@pali>
 <20210125140957.4afiqlfprm65jcr5@pali>
 <20210125141643.GD1551@shell.armlinux.org.uk>
 <20210125142301.qkvjyzrm3efkkikn@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210125142301.qkvjyzrm3efkkikn@pali>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 03:23:01PM +0100, Pali Rohár wrote:
> On Monday 25 January 2021 14:16:44 Russell King - ARM Linux admin wrote:
> > On Mon, Jan 25, 2021 at 03:09:57PM +0100, Pali Rohár wrote:
> > > On Monday 18 January 2021 10:34:35 Pali Rohár wrote:
> > > > On Monday 11 January 2021 12:39:07 Pali Rohár wrote:
> > > > > This is a third version of patches which add workarounds for
> > > > > RTL8672/RTL9601C EEPROMs and Ubiquiti U-Fiber Instant SFP.
> > > > > 
> > > > > Russel's PATCH v2 2/3 was dropped from this patch series as
> > > > > it is being handled separately.
> > > > 
> > > > Andrew and Russel, are you fine with this third iteration of patches?
> > > > Or are there still some issues which needs to be fixed?
> > > 
> > > PING!
> > 
> > What about the commit message suggestions from Marek?
> 
> I have already wrote that I'm fine with those suggestions.
> 
> It is the only thing to handle? If yes, should I send a new patch series
> with fixed commit messages?

Yes, because that's the way the netdev list works - patches sent to
netdev go into patchwork, when they get reviewed and acks etc,
patchwork updates itself. Jakub or David can then see what the status
is and apply them to the net or net-next trees as appropriate.

The "finished" patches need to be posted for this process to start.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
