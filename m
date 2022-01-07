Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C685487D27
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 20:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbiAGThL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 14:37:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56498 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230338AbiAGThL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 14:37:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9sKi4CRCyWYxTnM/K2tFC/IMbJHjyxPdes3PqTSlElc=; b=maRxfKHq/yVXg/VoLNNnvqQhfr
        YRFnoqRgp6X5qkH6SUMaDDewR0IRO0IxpoNu2h29Iy1I+yc6cZgGGXWXrUUwPbyjGJ52LUsl9fVMf
        VtbwIOZCPACLCCeS5JKbrB6tQWDSgSfg+tM7oWc/E6zVPlrrMdybtn43iFjHWCHyU9as=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n5v2x-000n92-Vv; Fri, 07 Jan 2022 20:37:07 +0100
Date:   Fri, 7 Jan 2022 20:37:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: remove ndo_get_phys_port_name
 and ndo_get_port_parent_id
Message-ID: <YdiWYydfY8flreN4@lunn.ch>
References: <20220107184842.550334-1-vladimir.oltean@nxp.com>
 <20220107184842.550334-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107184842.550334-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 08:48:41PM +0200, Vladimir Oltean wrote:
> There are no legacy ports, DSA registers a devlink instance with ports
> unconditionally for all switch drivers. Therefore, delete the old-style
> ndo operations used for determining bridge forwarding domains.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Hi Vladimir

Maybe ask Ido or Jiri to review this? But none of the Mellanox drivers
use use these ndo's, suggesting it is correct.

	   Andrew
