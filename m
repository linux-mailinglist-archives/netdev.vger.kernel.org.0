Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9571F1F76
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 21:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgFHTFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 15:05:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbgFHTFS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 15:05:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DVh1K26spkBIM0ML/SgEjDXK1bwgcA9UJYFN187xfys=; b=DOUEcOyXDtVbezZAZ8FghnTb9s
        WDN2JMTBxasQgoTW/BnFYHZRkXVcRN+H9m2Cy6/lBLn+ql96i36dsMTJD8nnFysATFYbzqZS/3WRc
        PTVz2Kt7LbOJRGMrt1y19GznuVbSBAXXKw6nsHHUpj2NjySIKpbBoHqE24ExSEmRe54g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jiN59-004QVj-Hr; Mon, 08 Jun 2020 21:05:15 +0200
Date:   Mon, 8 Jun 2020 21:05:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [RFC PATCH v2] net: dsa: qca8k: Improve SGMII interface handling
Message-ID: <20200608190515.GI1006885@lunn.ch>
References: <cover.1591380105.git.noodles@earth.li>
 <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
 <20200605183843.GB1006885@lunn.ch>
 <20200606074916.GM311@earth.li>
 <20200606083741.GK1551@shell.armlinux.org.uk>
 <20200606105909.GN311@earth.li>
 <20200608183953.GR311@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608183953.GR311@earth.li>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 07:39:53PM +0100, Jonathan McDowell wrote:
> On Sat, Jun 06, 2020 at 11:59:09AM +0100, Jonathan McDowell wrote:
> > I'll go away and roll a v2 moving qca8k over to phylink and then using
> > that to auto select the appropriate SGMII mode. Thanks for the feedback.
> 
> Ok, take 2. I've switched the driver over to phylink which has let me
> drop the need for any device tree configuration; if we're a CPU port
> then we're in SGMII-PHY mode, otherwise we choose between SGMII-MAC +
> Base-X on what phylink tells us.

Hi Johnathan

Could you split this into two parts. One or more patches which
converts to phylink, and a patch which adds new functionality. If it
breaks, we then have a better idea what broke it.

Conversions to phylink are not easy to review because a lot of code
gets moved around. It sometimes helps if you can turn existing code
into helpers, rather than inline them.

     Andrew
