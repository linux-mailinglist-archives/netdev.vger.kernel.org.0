Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697481D6BCC
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 20:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgEQSpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 14:45:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36112 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgEQSpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 14:45:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Om2ihcIcTTCsJd0V7LPMZGBDdv56p7fhVEVGIu/z1NU=; b=OMXPGZuN2DUGWDOvdepI0drpje
        t0J+q5DXzijClPE7jaWI2Sf3cBDPuyovR0ikl/G2EuuBXnb1Gld/gCjnmJBySqz55xZU4CFf7AB2j
        mWTPjiAJG3RkRwknMC0NxDHZLvwlSOX7qO/IJZCe4pE+75yG2DfHl8UspU+y6i9GtCMQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jaOHi-002YO6-5d; Sun, 17 May 2020 20:45:14 +0200
Date:   Sun, 17 May 2020 20:45:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
Message-ID: <20200517184514.GD606317@lunn.ch>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
 <20200516.133739.285740119627243211.davem@davemloft.net>
 <CA+h21hoNW_++QHRob+NbWC2k7y7sFec3kotSjTL6s8eZGGT+2Q@mail.gmail.com>
 <20200516.151932.575795129235955389.davem@davemloft.net>
 <CA+h21hrg_CeD2-zT+7v3b3hPRFaeggmZC9NqPp+soedCYwG63A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrg_CeD2-zT+7v3b3hPRFaeggmZC9NqPp+soedCYwG63A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 01:51:19PM +0300, Vladimir Oltean wrote:
> On Sun, 17 May 2020 at 01:19, David Miller <davem@davemloft.net> wrote:
> >
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Date: Sun, 17 May 2020 00:03:39 +0300
> >
> > > As to why this doesn't go to tc but to ethtool: why would it go to tc?
> >
> > Maybe you can't %100 duplicate the on-the-wire special format and
> > whatever, but the queueing behavior ABSOLUTELY you can emulate in
> > software.
> >
> > And then you have the proper hooks added for HW offload which can
> > do the on-the-wire stuff.
> >
> > That's how we do these things, not with bolted on ethtool stuff.
> 
> When talking about frame preemption in the way that it is defined in
> 802.1Qbu and 802.3br, it says or assumes nothing about queuing. It
> describes the fact that there are 2 MACs per interface, 1 MAC dealing
> with some traffic classes and the other dealing with the rest.

I did not follow the previous discussion, but i assume you talked
about modelling it in Linux as two MACs? Why was that approach not
followed?

   Andrew
