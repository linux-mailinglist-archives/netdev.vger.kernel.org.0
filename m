Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBEA3902AF
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 15:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhEYNot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 09:44:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56252 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233364AbhEYNor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 09:44:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=E7uLc6cWpD6Tgkm7IcKb2bF7/CZHFm+BaW23q1xO7wQ=; b=ENziuWO0kvc+Q8Ky9LN1Ya80fi
        reA6Ijycx0ZTAI5NvOdz67PtNxjWZ9eBWT4q4Jgh9icSZt6QnAdCY4ujGk/12o88R+o4TJnMV/fIH
        N8R+IX0r4vRVFYfs9WNxInIxB+gmKbXob2jEJXRa044GB0dwYsbaV/x4tEnqunE2zWks=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llXKz-006B7o-Vz; Tue, 25 May 2021 15:43:13 +0200
Date:   Tue, 25 May 2021 15:43:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 11/13] net: dsa: sja1105: register the MDIO
 buses for 100base-T1 and 100base-TX
Message-ID: <YKz+8QcRS3Px7tZR@lunn.ch>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-12-olteanv@gmail.com>
 <YKxecB8aDJ4m5x7R@lunn.ch>
 <20210525115429.6bj4pvmudur3ixyy@skbuf>
 <YKz4xA3QNIoEv5pp@lunn.ch>
 <20210525132117.gvjr4zcmpnhcwxyc@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525132117.gvjr4zcmpnhcwxyc@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Just to be clear, what is your suggestion for this? I am not a great fan
> of 2 internal MDIO buses, but as mentioned, the PHY access procedure is
> different for the 100base-TX and the 100base-T1 PHYs.

Do what the mv88e6xxx driver does. Have two busses, but do not put
them into a container node. You then avoid issues with the yaml
validater and not need the reg values etc.

	  Andrew
