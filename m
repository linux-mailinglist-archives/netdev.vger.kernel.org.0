Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C573FAE6A
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 22:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbhH2URP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 16:17:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231417AbhH2URO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Aug 2021 16:17:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KDIxZT3/x9fPJ4BS6ZWjlTZ+Byifs+nCTwd1Hh1ZsAs=; b=zSefzRrafQTgHv4eUQcqLniEoX
        gKbsJvwawQ5ewEJGXc8/D0hg9QWOQEE260nLVImqRbY8ko9tca0a6i28fUFKXQ2RZzv0TaW9t8bU3
        0TA2ooFeczh8f2wsE4JfeRsg5O4B5xDmSrFnoBJpLUHypw28mzjPteSZqUSfNfMel0hU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mKRDq-004Rrb-D3; Sun, 29 Aug 2021 22:16:06 +0200
Date:   Sun, 29 Aug 2021 22:16:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Message-ID: <YSvrBvLJ3IRTn9FR@lunn.ch>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
 <20210829080512.3573627-2-maciej.machnikowski@intel.com>
 <20210829151017.GA6016@hoboy.vegasvil.org>
 <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I have nothing against exposing the DPLL if you need to, however I'd like to have
> > an interface that support plain Gigabit as well.  This could be done in a generic
> > way by offering Control Register 9 as described in 802.3.

Are we talking about Clause 22, register 9, also known as MII_CTRL1000?

> This part of Gigabit interface is a different part of SyncE device. It controls Master/Slave
> operation of auto-negotiation.

This is controlled using ethtool -s

      ethtool -s devname [speed N] [duplex half|full] [port tp|aui|bnc|mii]
              ....
              [sopass xx:yy:zz:aa:bb:cc] [master-slave preferred-
              master|preferred-slave|forced-master|forced-slave]

      Andrew
