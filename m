Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E0329F962
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 01:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgJ3ACv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 20:02:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53504 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgJ3ACv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 20:02:51 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYHsV-004FsI-S3; Fri, 30 Oct 2020 01:02:47 +0100
Date:   Fri, 30 Oct 2020 01:02:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Greg Ungerer <gerg@linux-m68k.org>
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com, cphealy@gmail.com,
        dkarr@vyex.com, clemens.gruber@pqgruber.com
Subject: Re: [PATCH v2] net: fec: fix MDIO probing for some FEC hardware
 blocks
Message-ID: <20201030000247.GA1013203@lunn.ch>
References: <20201028052232.1315167-1-gerg@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028052232.1315167-1-gerg@linux-m68k.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 03:22:32PM +1000, Greg Ungerer wrote:
> Some (apparently older) versions of the FEC hardware block do not like
> the MMFR register being cleared to avoid generation of MII events at
> initialization time. The action of clearing this register results in no
> future MII events being generated at all on the problem block. This means
> the probing of the MDIO bus will find no PHYs.
> 
> Create a quirk that can be checked at the FECs MII init time so that
> the right thing is done. The quirk is set as appropriate for the FEC
> hardware blocks that are known to need this.
> 
> Fixes: f166f890c8f0 ("net: ethernet: fec: Replace interrupt driven MDIO with polled IO")
> Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>

Tested-by: Andrew Lunn <andrew@lunn.ch>

I tested this on Vybrid, which is not the best of platforms, since i
never had any of these problems on this platform.

Jakub, this is for net.

    Andrew
