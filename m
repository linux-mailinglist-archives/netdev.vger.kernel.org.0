Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0F89C0B1
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 00:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfHXWSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 18:18:45 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53874 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfHXWSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 18:18:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2gX0YBMomljkwshRej6u+EEHPfaWAXoeifTSU8RFO4A=; b=qot0e0wLKpStolVBR004h9dZq
        kbYoixlHybIeKJaES850gjNw58K34Gh8X98UgXdCVNOZ/bM/ufShUavrNPM1hIsixRihZfNwNfR9t
        H98vH8pu7Xk6CG6b91qM0OlruYfQY7T3kj4gbuB2UVYR7hGTcCOe2C2ZkduK0wNFTcXdED2q/Pmsy
        CV8MzM3z7j2WI+rRXQpAU0YlKqLyWhyny06Hj1x3IVUU8brSncVBdCmFdNfUI77q3R5DNTUQfxHAS
        RHkioXEtrwSlnFWg/9rfET5govArt2hkNwB2Kk0z0CVI4MTm0fg+AWji9dEmYygzd7Dkiyc06U6TP
        qitksgu5Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37580)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i1eMl-0005SV-Bf; Sat, 24 Aug 2019 23:18:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i1eMg-0002y9-Ln; Sat, 24 Aug 2019 23:18:30 +0100
Date:   Sat, 24 Aug 2019 23:18:30 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, frank-w@public-files.de,
        netdev@vger.kernel.org, sean.wang@mediatek.com,
        linux-mips@vger.kernel.org, opensource@vdorst.com,
        linux-mediatek@lists.infradead.org, john@phrozen.org,
        matthias.bgg@gmail.com, vivien.didelot@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 0/3] net: dsa: mt7530: Convert to PHYLINK and
 add support for port 5
Message-ID: <20190824221830.GF13294@shell.armlinux.org.uk>
References: <20190821144547.15113-1-opensource@vdorst.com>
 <20190822.162047.1140525762795777800.davem@davemloft.net>
 <20190823010928.GK13020@lunn.ch>
 <20190824.141803.1656753287804303137.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190824.141803.1656753287804303137.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 24, 2019 at 02:18:03PM -0700, David Miller wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Fri, 23 Aug 2019 03:09:28 +0200
> 
> > That would be Russell.
> > 
> > We should try to improve MAINTAINER so that Russell King gets picked
> > by the get_maintainer script.
> 
> Shoule he be added to the mt7530 entry?

Probably some way to make MAINTAINERS pick up on phylink-containing
patches.  Something like:

K:	phylink

maybe?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
