Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCF3293235
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389192AbgJTAHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:07:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35662 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389158AbgJTAHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 20:07:51 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUfBq-002ZjZ-I1; Tue, 20 Oct 2020 02:07:46 +0200
Date:   Tue, 20 Oct 2020 02:07:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: Re: [PATCH net] net: dsa: reference count the host mdb addresses
Message-ID: <20201020000746.GR456889@lunn.ch>
References: <20201015212711.724678-1-vladimir.oltean@nxp.com>
 <20201019165514.1fe7d8f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019165514.1fe7d8f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 04:55:14PM -0700, Jakub Kicinski wrote:
> On Fri, 16 Oct 2020 00:27:11 +0300 Vladimir Oltean wrote:
> > Currently any DSA switch that implements the multicast ops (properly,
> > that is) gets these errors after just sitting for a while, with at least
> > 2 ports bridged:
> > 
> > [  286.013814] mscc_felix 0000:00:00.5 swp3: failed (err=-2) to del object (id=3)
> > 
> > The reason has to do with this piece of code:
> > 
> > 	netdev_for_each_lower_dev(dev, lower_dev, iter)
> > 		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);
> 
> We need a review on this one, anyone?

Hi Jakub

Thanks for the reminder. It has been on my TODO list since i got back
from vacation.

	Andrew
