Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D546255CA7
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 16:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgH1Ogc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 10:36:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58266 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgH1OgM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 10:36:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kBfU5-00CHvr-RG; Fri, 28 Aug 2020 16:36:05 +0200
Date:   Fri, 28 Aug 2020 16:36:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     David Thompson <dthompson@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Asmaa Mnebhi <Asmaa@mellanox.com>
Subject: Re: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Message-ID: <20200828143605.GZ2403519@lunn.ch>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
 <20200731183851.GG1748118@lunn.ch>
 <CH2PR12MB389568AB4EBE620FD22894A8D7520@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB389568AB4EBE620FD22894A8D7520@CH2PR12MB3895.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 28, 2020 at 02:24:28PM +0000, Asmaa Mnebhi wrote:
> > > +	  The second generation BlueField SoC from Mellanox Technologies
> > > +	  supports an out-of-band Gigabit Ethernet management port to the
> > > +	  Arm subsystem.
> > 
> > You might want to additionally select the PHY driver you are using.
> > 

> It is preferable to not set a specific PHY driver here because it is
> susceptible to change. And even customers might use a different PHY
> device.

O.K. Not a problem.

     Andrew
