Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478E51511BF
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 22:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgBCVVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 16:21:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34580 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbgBCVVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 16:21:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8YNbaMkCwfZYOn+Lj/TQzffzWSnxWWH/YZXjjq216rs=; b=qqLLLqQ3aAoAMLhF/QCtWBj5LJ
        S4vTOo3tLRWuHosI8dIARIgClpH2AHO8WPkKvZ4eN9T0gSxEkbFyEa4Vxns+/NXWF4uv2e/abnV4a
        qWTsEbSKEuVb1WbQsdESvkhE2V2jRfA5L7FsBMRs1nfgSVoE/aQzF77HKcQTjolpxbxk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iyjAB-0005KX-0i; Mon, 03 Feb 2020 22:21:47 +0100
Date:   Mon, 3 Feb 2020 22:21:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org,
        opendmb@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        hkallweit1@gmail.com
Subject: Re: [PATCH 3/6] net: bcmgenet: enable automatic phy discovery
Message-ID: <20200203212147.GG13856@lunn.ch>
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-4-jeremy.linton@arm.com>
 <20200201152518.GI9639@lunn.ch>
 <608e7fab-69a3-700d-bfcf-88e5711ce58f@arm.com>
 <800ec5d6-44d5-22aa-cf0c-0e7c5de1feb3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <800ec5d6-44d5-22aa-cf0c-0e7c5de1feb3@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I do not think we are asking to get properties hard coded, we are asking
> to get a proper representation of these MDIO devices, including their
> supserset that PHY devices are into ACPI, in a way that is usable by the
> core MDIO layer without drivers cutting corners.

Yes.

And i'm also interested in this in a generic way. Ethernet switches
often have MDIO busses, with lots of PHYs on them. Some might argue
that switches are out of scope for ACPI, but people have shown
interest in getting ACPI working on Espressobin,
http://espressobin.net/ which has a marvell Switch on it.

There are also some broadcom SoCs with generic PHYs, not ethernet PHYs
as devices on MDIO busses.

And we have people submitting patches to other drivers at the moment,
which just seem to stuff DT properties into ACPI tables. At least in
networking, ACPI seems to be a wild west, anything goes, no
documentation, no standardisation, nobody has an ACPI maintainer role
over the whole kernel who cares about it.

   Andrew
