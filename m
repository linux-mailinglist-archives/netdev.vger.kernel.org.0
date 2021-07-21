Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0923D176B
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 22:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239929AbhGUTMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 15:12:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38996 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238276AbhGUTMk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 15:12:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=casm0fBJN/w1gZgDxRShD84HThb0ogBtG634HmnOurQ=; b=bL5qYm8tX3U43g+EGgU4AHaYRh
        tWkV82c+7AVniUnYgQcSRTug7fhvl1J5ozeeviKzpjNaWUQ+9cUZeNxLM706lfZPGb8Z/c93NdjJr
        sA02T2KF+6JEwR5v2U6YAMphhRThZ5R/wzmOXXNU1mR7I3cWgYKw0RxSvlkCpmzGCjhA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6IHJ-00EFMq-7P; Wed, 21 Jul 2021 21:53:13 +0200
Date:   Wed, 21 Jul 2021 21:53:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sasha Neftin <sasha.neftin@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 09/12] igc: Remove _I_PHY_ID checking
Message-ID: <YPh7KTyNQScVjp13@lunn.ch>
References: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
 <20210720232101.3087589-10-anthony.l.nguyen@intel.com>
 <YPg0PRYHe74+TucS@lunn.ch>
 <6cb7fbe9-35e2-8fb1-11fa-cbd6ce01bab2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cb7fbe9-35e2-8fb1-11fa-cbd6ce01bab2@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 09:02:13PM +0300, Sasha Neftin wrote:
> On 7/21/2021 17:50, Andrew Lunn wrote:
> > On Tue, Jul 20, 2021 at 04:20:58PM -0700, Tony Nguyen wrote:
> > > From: Sasha Neftin <sasha.neftin@intel.com>
> > > 
> > > i225 devices have only one PHY vendor. There is no point checking
> > > _I_PHY_ID during the link establishment and auto-negotiation process.
> > > This patch comes to clean up these pointless checkings.
> > 
> > I don't know this hardware....
> > 
> > Is the PHY integrated into the MAC? Or is it external?
> i225 controller offers a fully-integrated Media Access Control
> (MAC) and Physical Layer (PHY) port.
> Both components (MAC and PHY) supports 2.5G

Hi Sasha

Thanks for the info. Then this change make sense. But the commit
message could of been better. It is not really about there being one
PHY vendor, it is simply impossible for the PHY to be anything else,
so there is no need to check.

	Andrew
