Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80746303213
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 03:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbhAYOtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 09:49:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729751AbhAYOsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 09:48:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC58206A1;
        Mon, 25 Jan 2021 14:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611586026;
        bh=OElRR0M5SRbBEfxPfgXyUJEQfFwS4nH58aREv01PJsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OslQhIIDiMAufN7st/mjLPJp9zQA8U08rDnU09gWAFK9c+5iYUijEBFq5T6w5F7C6
         t8qNuklThOOr36cMk5q3SRLUOCvgXXRWAWIb0ONdYOcuCy/qinRmFPem2C5XH9LXGQ
         CHTdUCKcAki5PzhtCf3FrQC5Mp5PcSB1m1W9VyZlyU9KyV39sbJg0PUIoavDrtS7lN
         RbsZlFwPPL2r3aRGpw6ljbRZgCITk2rTd112y79VTsxwCavHzDIZx2R/+0N1S4PUw8
         aZOXtGtG/L9lgjG88V1EQlxSeUbqdFBDBhVmfDT5tzw3puVTW6NhSGA2YE+zmmjyBZ
         EZXsyG4xBQvow==
Received: by pali.im (Postfix)
        id AC487768; Mon, 25 Jan 2021 15:47:03 +0100 (CET)
Date:   Mon, 25 Jan 2021 15:47:03 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] net: sfp: add support for GPON RTL8672/RTL9601C
 and Ubiquiti U-Fiber
Message-ID: <20210125144703.ekzvp27uqwgdxmsn@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210111113909.31702-1-pali@kernel.org>
 <20210118093435.coy3rnchbmlkinpe@pali>
 <20210125140957.4afiqlfprm65jcr5@pali>
 <20210125141643.GD1551@shell.armlinux.org.uk>
 <20210125142301.qkvjyzrm3efkkikn@pali>
 <20210125144221.GE1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210125144221.GE1551@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 25 January 2021 14:42:21 Russell King - ARM Linux admin wrote:
> On Mon, Jan 25, 2021 at 03:23:01PM +0100, Pali Rohár wrote:
> > On Monday 25 January 2021 14:16:44 Russell King - ARM Linux admin wrote:
> > > On Mon, Jan 25, 2021 at 03:09:57PM +0100, Pali Rohár wrote:
> > > > On Monday 18 January 2021 10:34:35 Pali Rohár wrote:
> > > > > On Monday 11 January 2021 12:39:07 Pali Rohár wrote:
> > > > > > This is a third version of patches which add workarounds for
> > > > > > RTL8672/RTL9601C EEPROMs and Ubiquiti U-Fiber Instant SFP.
> > > > > > 
> > > > > > Russel's PATCH v2 2/3 was dropped from this patch series as
> > > > > > it is being handled separately.
> > > > > 
> > > > > Andrew and Russel, are you fine with this third iteration of patches?
> > > > > Or are there still some issues which needs to be fixed?
> > > > 
> > > > PING!
> > > 
> > > What about the commit message suggestions from Marek?
> > 
> > I have already wrote that I'm fine with those suggestions.
> > 
> > It is the only thing to handle? If yes, should I send a new patch series
> > with fixed commit messages?
> 
> Yes, because that's the way the netdev list works - patches sent to
> netdev go into patchwork, when they get reviewed and acks etc,
> patchwork updates itself. Jakub or David can then see what the status
> is and apply them to the net or net-next trees as appropriate.

Ok! If this is the only remaining issue, I will update commit messages
and send a new patch series. I was just waiting for a response if
somebody else has other comments or if somebody write that is fine with
it.

> The "finished" patches need to be posted for this process to start.
> 
> Thanks.
