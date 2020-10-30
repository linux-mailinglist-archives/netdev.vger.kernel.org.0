Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9312A09BA
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgJ3P01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbgJ3P01 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 11:26:27 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A46DB20725;
        Fri, 30 Oct 2020 15:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604071587;
        bh=NcN/rhcOLySeO7K19khQjxoeDSwMfQuQC/LClRbw8Pc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kBSs3SPuT5M1XkgMBZPHTzhPUL8l45JjSXhV5fafItIAMDXhR1Bwu1Q8+AhX8SeXf
         Wsjv9zui4azGOR2MsJhXHNEdtI08KgGP/y6laW1jShUWyfv3HLSVW4Xyj7Px1ccM43
         K98IZ1CNVtD8p5aP02CaJczo5qQvHb6QbACLpg2M=
Date:   Fri, 30 Oct 2020 08:26:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Greg Ungerer <gerg@linux-m68k.org>, netdev@vger.kernel.org,
        fugang.duan@nxp.com, cphealy@gmail.com, dkarr@vyex.com,
        clemens.gruber@pqgruber.com
Subject: Re: [PATCH v2] net: fec: fix MDIO probing for some FEC hardware
 blocks
Message-ID: <20201030082620.0a71ea51@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030000247.GA1013203@lunn.ch>
References: <20201028052232.1315167-1-gerg@linux-m68k.org>
        <20201030000247.GA1013203@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 01:02:47 +0100 Andrew Lunn wrote:
> On Wed, Oct 28, 2020 at 03:22:32PM +1000, Greg Ungerer wrote:
> > Some (apparently older) versions of the FEC hardware block do not like
> > the MMFR register being cleared to avoid generation of MII events at
> > initialization time. The action of clearing this register results in no
> > future MII events being generated at all on the problem block. This means
> > the probing of the MDIO bus will find no PHYs.
> > 
> > Create a quirk that can be checked at the FECs MII init time so that
> > the right thing is done. The quirk is set as appropriate for the FEC
> > hardware blocks that are known to need this.
> > 
> > Fixes: f166f890c8f0 ("net: ethernet: fec: Replace interrupt driven MDIO with polled IO")
> > Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>  
> 
> Tested-by: Andrew Lunn <andrew@lunn.ch>
> 
> I tested this on Vybrid, which is not the best of platforms, since i
> never had any of these problems on this platform.
> 
> Jakub, this is for net.

Applied, thanks everyone!
