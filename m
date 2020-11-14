Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93A92B29C3
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgKNARi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:17:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgKNARi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 19:17:38 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9199222252;
        Sat, 14 Nov 2020 00:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605313058;
        bh=S2NVtfPjItVwtnVxumDQCMV3jlsPBo0ElN0P79JEU7c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=my7C62aRIAX9IIn3wqaxHcwVpvJmiuv+SJrCfzqpzt8sRIrqr0Y+JXv0DX0uSSIMk
         lp9gRsalG1OI7Ntaq8Kp5FYma6L/AOo40ObRfhBUtEbhICckIVQrRIIJLD3IvsBUUn
         aRDaGQrEwHg249c8QmtZnTBnXJ6uamDSWADvgu1g=
Date:   Fri, 13 Nov 2020 16:17:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <Bryan.Whitehead@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        John Haechten <John.Haechten@microchip.com>,
        Netdev List <netdev@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: phy: mscc: remove non-MACSec compatible phy
Message-ID: <20201113161736.68c51cf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADCXZ1wx_Uxp46hRDuQakzApPTRLKufyoH-tybyQ4m3nvV=w7A@mail.gmail.com>
References: <20201113091116.1102450-1-steen.hegelund@microchip.com>
        <CADCXZ1wx_Uxp46hRDuQakzApPTRLKufyoH-tybyQ4m3nvV=w7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 09:27:30 +0000 Antoine Tenart wrote:
> Quoting Steen Hegelund (2020-11-13 10:11:16)
> > Selecting VSC8575 as a MACSec PHY was not correct
> >
> > The relevant datasheet can be found here:
> >   - VSC8575: https://www.microchip.com/wwwproducts/en/VSC8575
> >
> > History:
> > v1 -> v2:
> >    - Corrected the sha in the "Fixes:" tag
> >
> > Fixes: 1bbe0ecc2a1a ("net: phy: mscc: macsec initialization")
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>  
> 
> Reviewed-by: Antoine Tenart <atenart@kernel.org>

Applied, thanks!
