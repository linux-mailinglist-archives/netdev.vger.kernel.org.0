Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E553C203F7B
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbgFVSw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:52:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54004 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730030AbgFVSw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 14:52:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jnRYP-001hz7-Fk; Mon, 22 Jun 2020 20:52:25 +0200
Date:   Mon, 22 Jun 2020 20:52:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Allow MAC configuration for ports
 with internal PHY
Message-ID: <20200622185225.GF405672@lunn.ch>
References: <20200622183443.3355240-1-daniel@zonque.org>
 <20200622184115.GE405672@lunn.ch>
 <b8a67f7d-9854-9854-3f53-983dd4eb8fda@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8a67f7d-9854-9854-3f53-983dd4eb8fda@zonque.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 08:44:51PM +0200, Daniel Mack wrote:
> On 6/22/20 8:41 PM, Andrew Lunn wrote:
> > On Mon, Jun 22, 2020 at 08:34:43PM +0200, Daniel Mack wrote:
> >> Ports with internal PHYs that are not in 'fixed-link' mode are currently
> >> only set up once at startup with a static config. Attempts to change the
> >> link speed or duplex settings are currently prevented by an early bail
> >> in mv88e6xxx_mac_config(). As the default config forces the speed to
> >> 1000M, setups with reduced link speed on such ports are unsupported.
> > 
> > Hi Daniel
> > 
> > How are you trying to change the speed?
> 
> With ethtool for instance. But all userspace tools are bailing out early
> on this port for the reason I described.

So you mean ethtool -s devname advertise 0x001

set make it advertise 10BaseT Half?

    Andrew
