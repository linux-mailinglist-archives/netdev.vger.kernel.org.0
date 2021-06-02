Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE20397F11
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 04:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhFBCaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 22:30:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40078 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhFBCaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 22:30:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4JoMGfga1VbTByDb+krUTuutqYAcuOdoQ70Y27jTzf8=; b=fJXgFc/GRD6OG68GN6GC7fmcNJ
        sCxWFlYEPPu4yPMgLkS+5YrzUpNY5fCDZ0fhqbHEIo9tjUD3owCdEJNgisENn7quOI6GK7UPcesrt
        1I8Qv271k43/RVjJiIT/byYplg7l0n5DINSoQjQynWPfsSi4PXfnM+ZMOGjUgGwdSuSs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1loGcD-007NlP-ME; Wed, 02 Jun 2021 04:28:17 +0200
Date:   Wed, 2 Jun 2021 04:28:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: stmmac: enable platform specific
 safety features
Message-ID: <YLbswWVdgGgAKpwo@lunn.ch>
References: <20210601135235.1058841-1-vee.khee.wong@linux.intel.com>
 <YLawrTO4pkgc6tnb@lunn.ch>
 <20210601225332.GA28151@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601225332.GA28151@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 06:53:32AM +0800, Wong Vee Khee wrote:
> On Wed, Jun 02, 2021 at 12:11:57AM +0200, Andrew Lunn wrote:
> > On Tue, Jun 01, 2021 at 09:52:35PM +0800, Wong Vee Khee wrote:
> > > On Intel platforms, not all safety features are enabled on the hardware.
> > 
> > Is it possible to read a register is determine what safety features
> > have been synthesised?
> >
> 
> No. The value of these registers after reset are 0x0. We need to set it
> manually.

That is not what i asked. Sometimes with IP you synthesise from VHDL
or Verilog, there are registers which describe which features you have
actually enabled/disabled in the synthesis. Maybe the stmmac has such
a register describing which safety features are actually available in
your specific version of the IP? You could go ask your ASIC engineers.
Or maybe Synopsys can say that there are no such registers.

     Andrew
