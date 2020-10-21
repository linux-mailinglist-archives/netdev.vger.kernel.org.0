Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7C0294EAA
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 16:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443501AbgJUO2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 10:28:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38286 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437408AbgJUO2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 10:28:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kVF5w-002pSb-NS; Wed, 21 Oct 2020 16:28:04 +0200
Date:   Wed, 21 Oct 2020 16:28:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <ardeleanalex@gmail.com>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        David Miller <davem@davemloft.net>, kuba@kernel.org
Subject: Re: [PATCH 2/2] net: phy: adin: implement cable-test support
Message-ID: <20201021142804.GP139700@lunn.ch>
References: <20201021135140.51300-1-alexandru.ardelean@analog.com>
 <20201021135140.51300-2-alexandru.ardelean@analog.com>
 <20201021140852.GN139700@lunn.ch>
 <CA+U=DsrZM4gRpmez6KqT8XTEBYwA-gwHjHQWa3Pn+G1nsYD3CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+U=DsrZM4gRpmez6KqT8XTEBYwA-gwHjHQWa3Pn+G1nsYD3CA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Actually, I'd also be interested [for this PHY], to report a
> "significance impedance" detection, which is similar to the
> short-detection that is already done.

You can add that as just another element of the enum.

> At first, this report would sound like it could be interesting; but
> feel free to disagree with me.
> 
> And there's also some "busy" indicator; as-in "unknown activity during
> diagnostics"; to-be-honest, I don't know what this is yet.

The link partner did not go quiet. You can only do cable tests if the
partner is not sending frames or pulses. You will find most PHYs have
some sort of error status for this. For the Marvell driver, this is 
MII_VCT7_RESULTS_INVALID. In that case, the Marvell driver returns
ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC.

	Andrew
