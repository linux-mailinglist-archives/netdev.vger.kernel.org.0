Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781763CD85A
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 17:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242070AbhGSOVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 10:21:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33932 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242706AbhGSOUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 10:20:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kAaOYJ4WkAH+VU3g6V5deZBG0j2OSTdbwTHDQarLo/0=; b=qCNYPgSt4w9NG/eazm3PjtEnHn
        1VCeMWdqK/F4cAF/xCRs+yIf5Y7KBU5RqGXoFVmJJgDvReOaEVqPvEUcdfD4jPXOFEtG5Y8mmjXwP
        SIwpkFZh8U2BHys+owukwcAaOVa4IxTproR9MCma4E6z87EFHzPKQQQfQVCbchZgT4hE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5Ulb-00DuVB-HO; Mon, 19 Jul 2021 17:01:11 +0200
Date:   Mon, 19 Jul 2021 17:01:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ruud Bos <ruud.bos@hbkworld.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next 0/4 resend] igb: support PEROUT and EXTTS PTP
 pin functions on 82580/i354/i350
Message-ID: <YPWTt8h1HFfMbMuh@lunn.ch>
References: <AM0PR09MB42765A3A3BCB3852A26E6F0EF0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
 <YPWMHagXlVCgpYqN@lunn.ch>
 <AM0PR09MB42766646ADEF80E5C54D7EA8F0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR09MB42766646ADEF80E5C54D7EA8F0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 02:45:06PM +0000, Ruud Bos wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Monday, July 19, 2021 16:29
> > To: Ruud Bos <ruud.bos@hbkworld.com>
> > Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org;
> > jesse.brandeburg@intel.com; anthony.l.nguyen@intel.com; Richard Cochran
> > <richardcochran@gmail.com>
> > Subject: Re: [PATCH net-next 0/4 resend] igb: support PEROUT and EXTTS
> > PTP pin functions on 82580/i354/i350
> >
> > On Mon, Jul 19, 2021 at 11:33:11AM +0000, Ruud Bos wrote:
> > > The igb driver provides support for PEROUT and EXTTS pin functions that
> > > allow adapter external use of timing signals. At Hottinger Bruel & Kjaer we
> > > are using the PEROUT function to feed a PTP corrected 1pps signal into an
> > > FPGA as cross system synchronized time source.
> >
> > Please always Cc: The PTP maintainer for PTP patches.
> > Richard Cochran <richardcochran@gmail.com>
> 
> Thanks, will do that!
> Do I need to resend again?

It is probably a good idea to resend. It will make it easier for
Richard if the patches are in his mailbox.

> This is my first ever contribution, so it's all kinda new to me,
> sorry :-)

Cc: Richard is not so obvious as it should be, since
./scripts/get_maintainers.pl would not of suggested it, since you are
not modify the PTP core. It takes a bit of experience to know this.

This is the second time something like this has happened recently for
Intel Ethernet drivers. The other case was making use of the LED
subsystem from within an Ethernet driver, and the LED subsystem
maintainers were not Cc:. It would be good if the Intel Maintainers
actually took notice of this, they have the experience to know better.

I noticed your patches are not threaded. Did you use git send-email?
It normally does thread a patchset. The threading keeps the patchset
together, which can be important for some of the bots which scoop up
patches in emails and run tests on them. Please see if you can fix
that in the resend.

     Andrew
